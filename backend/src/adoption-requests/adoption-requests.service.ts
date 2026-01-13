import { Injectable, NotFoundException, ForbiddenException, BadRequestException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { AdoptionRequest, AdoptionStatus } from './adoption-request.schema';
import { AnimalsService } from '../animals/animals.service';
import { AiServiceService } from '../ai-service/ai-service.service';
import { AnimalStatus } from '../animals/animal.schema';

@Injectable()
export class AdoptionRequestsService {
  constructor(
    @InjectModel(AdoptionRequest.name)
    private requestModel: Model<AdoptionRequest>,
    private animalsService: AnimalsService,
    private aiService: AiServiceService,
  ) {}

  async create(userId: string, animalId: string, message?: string): Promise<AdoptionRequest> {
    // Check if animal exists and is available
    const animal = await this.animalsService.findOne(animalId);
    
    if (animal.status !== AnimalStatus.AVAILABLE) {
      throw new BadRequestException('This animal is not available for adoption');
    }

    // Check if user already has a pending request for this animal
    const existingRequest = await this.requestModel.findOne({
      userId: new Types.ObjectId(userId),
      animalId: new Types.ObjectId(animalId),
      status: AdoptionStatus.PENDING,
    }).exec();

    if (existingRequest) {
      throw new BadRequestException('You already have a pending request for this animal');
    }

    // Get compatibility score - use fallback if AI service unavailable
    let compatibilityScore = 75.0; // Default fallback
    try {
      const compatibility = await this.aiService.predictCompatibility(userId, animal);
      compatibilityScore = compatibility.compatibility_score;
    } catch (error) {
      console.warn('⚠️ AI service unavailable, using fallback compatibility score');
    }

    const request = new this.requestModel({
      userId: new Types.ObjectId(userId),
      animalId: new Types.ObjectId(animalId),
      message: message || '', // Convert undefined/null to empty string
      compatibilityScore: compatibilityScore,
      status: AdoptionStatus.PENDING,
    });

    // Update animal status to pending
    // shelterId is populated, so access _id field
    const animalShelterId = animal.shelterId['_id']?.toString() || animal.shelterId.toString();
    await this.animalsService.update(
      animalId,
      { status: AnimalStatus.PENDING },
      animalShelterId,
      'shelter'
    );

    const savedRequest = await request.save();
    
    // Convert null fields to empty strings before returning
    const result = savedRequest.toObject();
    if (result.message === null || result.message === undefined) {
      result.message = '';
    }
    if (result.shelterNotes === null || result.shelterNotes === undefined) {
      result.shelterNotes = '';
    }
    
    return result as AdoptionRequest;
  }

  async findAll(): Promise<AdoptionRequest[]> {
    return this.requestModel.find()
      .populate('userId', 'name email')
      .populate({
        path: 'animalId',
        populate: { path: 'shelterId', select: 'name email' }
      })
      .sort({ createdAt: -1 })
      .exec();
  }

  async findByUser(userId: string): Promise<AdoptionRequest[]> {
    const requests = await this.requestModel.find({ userId: new Types.ObjectId(userId) })
      .populate({
        path: 'animalId',
        populate: { path: 'shelterId', select: 'name email' }
      })
      .sort({ createdAt: -1 })
      .exec();
    
    // Convert null message fields to empty strings to avoid JSON parsing issues
    return requests.map(req => {
      const obj = req.toObject();
      if (obj.message === null) {
        obj.message = '';
      }
      if (obj.shelterNotes === null) {
        obj.shelterNotes = '';
      }
      return obj as AdoptionRequest;
    });
  }

  async findByShelter(shelterId: string): Promise<AdoptionRequest[]> {
    const animals = await this.animalsService.findByShelter(shelterId);
    const animalIds = animals.map(a => a._id);
    
    const requests = await this.requestModel.find({ animalId: { $in: animalIds } })
      .populate('userId', 'name email')
      .populate('animalId')
      .sort({ createdAt: -1 })
      .exec();
    
    // Convert null message fields to empty strings to avoid JSON parsing issues
    return requests.map(req => {
      const obj = req.toObject();
      if (obj.message === null) {
        obj.message = '';
      }
      if (obj.shelterNotes === null) {
        obj.shelterNotes = '';
      }
      return obj as AdoptionRequest;
    });
  }

  async findOne(id: string): Promise<AdoptionRequest> {
    const request = await this.requestModel.findById(id)
      .populate('userId', 'name email')
      .populate({
        path: 'animalId',
        populate: { path: 'shelterId', select: 'name email' }
      })
      .exec();

    if (!request) {
      throw new NotFoundException(`Adoption request with ID ${id} not found`);
    }

    // Convert null fields to empty strings
    const obj = request.toObject();
    if (obj.message === null || obj.message === undefined) {
      obj.message = '';
    }
    if (obj.shelterNotes === null || obj.shelterNotes === undefined) {
      obj.shelterNotes = '';
    }
    
    return obj as AdoptionRequest;
  }

  async updateStatus(
    id: string,
    status: AdoptionStatus,
    userId: string,
    userRole: string,
    shelterNotes?: string,
  ): Promise<AdoptionRequest> {
    const request = await this.findOne(id);

    console.log('🔒 Permission check:');
    console.log('  - request.animalId:', request.animalId);
    console.log('  - request.animalId.shelterId:', request.animalId['shelterId']);
    console.log('  - userId (shelterId):', userId);
    console.log('  - userRole:', userRole);

    // Only shelter owner can update status
    // shelterId is populated, so access _id field
    const animalShelterId = request.animalId['shelterId']._id?.toString() || request.animalId['shelterId'].toString();
    if (animalShelterId !== userId && userRole !== 'admin') {
      console.log('❌ Permission denied: animalShelterId !== userId');
      console.log('  - animalShelterId:', animalShelterId);
      console.log('  - userId:', userId);
      throw new ForbiddenException('You do not have permission to update this request');
    }

    await this.requestModel.findByIdAndUpdate(id, { 
      status, 
      shelterNotes: shelterNotes || '' 
    }).exec();

    // Extract animalId from populated object
    const animalId = request.animalId._id?.toString() || request.animalId.toString();

    // Update animal status based on adoption request status
    if (status === AdoptionStatus.APPROVED || status === AdoptionStatus.COMPLETED) {
      await this.animalsService.update(
        animalId,
        { status: AnimalStatus.ADOPTED },
        animalShelterId,
        'shelter'
      );

      // Reject all other pending requests for this animal
      await this.requestModel.updateMany(
        { animalId: request.animalId._id || request.animalId, status: AdoptionStatus.PENDING },
        { status: AdoptionStatus.REJECTED, shelterNotes: 'Animal adopted by another user' }
      ).exec();
    } else if (status === AdoptionStatus.REJECTED) {
      // Check if there are other pending requests
      const otherPendingRequests = await this.requestModel.countDocuments({
        animalId: request.animalId._id || request.animalId,
        status: AdoptionStatus.PENDING,
      }).exec();

      // If no other pending requests, set animal back to available
      if (otherPendingRequests === 0) {
        await this.animalsService.update(
          animalId,
          { status: AnimalStatus.AVAILABLE },
          animalShelterId,
          'shelter'
        );
      }
    }

    return this.findOne(id);
  }

  async remove(id: string, userId: string): Promise<void> {
    const request = await this.findOne(id);

    // Only requester can delete their own request
    if (request.userId.toString() !== userId) {
      throw new ForbiddenException('You can only delete your own requests');
    }

    if (request.status !== AdoptionStatus.PENDING) {
      throw new BadRequestException('Can only delete pending requests');
    }

    await this.requestModel.findByIdAndDelete(id).exec();

    // Check if there are other pending requests for this animal
    const otherPendingRequests = await this.requestModel.countDocuments({
      animalId: request.animalId,
      status: AdoptionStatus.PENDING,
    }).exec();

    // If no other pending requests, set animal back to available
    if (otherPendingRequests === 0) {
      await this.animalsService.update(
        request.animalId.toString(),
        { status: AnimalStatus.AVAILABLE },
        request.animalId['shelterId'].toString(),
        'shelter'
      );
    }
  }
}
