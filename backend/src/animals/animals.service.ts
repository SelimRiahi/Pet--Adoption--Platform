import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Animal, AnimalStatus } from './animal.schema';

@Injectable()
export class AnimalsService {
  constructor(
    @InjectModel(Animal.name)
    private animalModel: Model<Animal>,
  ) {}

  async create(animalData: Partial<Animal>, shelterId: string): Promise<Animal> {
    const animal = new this.animalModel({
      ...animalData,
      shelterId: new Types.ObjectId(shelterId),
    });
    return animal.save();
  }

  async findAll(filters?: any): Promise<Animal[]> {
    const query: any = {};

    if (filters?.species) query.species = filters.species;
    if (filters?.size) query.size = filters.size;
    if (filters?.status) {
      query.status = filters.status;
    } else {
      query.status = AnimalStatus.AVAILABLE;
    }
    if (filters?.goodWithChildren !== undefined) query.goodWithChildren = filters.goodWithChildren === 'true';
    if (filters?.goodWithPets !== undefined) query.goodWithPets = filters.goodWithPets === 'true';

    return this.animalModel.find(query).populate('shelterId', 'name email').exec();
  }

  async findOne(id: string): Promise<Animal> {
    const animal = await this.animalModel.findById(id).populate('shelterId', 'name email').exec();
    if (!animal) {
      throw new NotFoundException(`Animal with ID ${id} not found`);
    }
    return animal;
  }

  async findByShelter(shelterId: string): Promise<Animal[]> {
    return this.animalModel.find({ shelterId: new Types.ObjectId(shelterId) }).populate('shelterId', 'name email').exec();
  }

  async update(id: string, animalData: Partial<Animal>, userId: string, userRole: string): Promise<Animal> {
    const animal = await this.findOne(id);
    // shelterId is populated, so access _id field
    const animalShelterId = animal.shelterId['_id']?.toString() || animal.shelterId.toString();
    if (animalShelterId !== userId && userRole !== 'admin') {
      throw new ForbiddenException('You do not have permission to update this animal');
    }
    return this.animalModel.findByIdAndUpdate(id, animalData, { new: true }).populate('shelterId', 'name email').exec();
  }

  async remove(id: string, userId: string, userRole: string): Promise<void> {
    const animal = await this.findOne(id);
    // shelterId is populated, so access _id field
    const animalShelterId = animal.shelterId['_id']?.toString() || animal.shelterId.toString();
    if (animalShelterId !== userId && userRole !== 'admin') {
      throw new ForbiddenException('You do not have permission to delete this animal');
    }
    await this.animalModel.findByIdAndDelete(id).exec();
  }
}
