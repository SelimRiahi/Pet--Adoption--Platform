import { Injectable, Logger } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import { firstValueFrom } from 'rxjs';
import { UsersService } from '../users/users.service';
import { Animal } from '../animals/animal.schema';

@Injectable()
export class AiServiceService {
  private readonly logger = new Logger(AiServiceService.name);
  private readonly aiServiceUrl = process.env.AI_SERVICE_URL || 'http://localhost:5000';

  constructor(
    private readonly httpService: HttpService,
    private readonly usersService: UsersService,
  ) {}

  async predictCompatibility(userId: string, animal: Animal): Promise<any> {
    try {
      const user = await this.usersService.findOne(userId);
      
      const payload = {
        user: {
          housing_type: user.housingType,
          available_time: user.availableTime,
          experience: user.experience,
          has_children: user.hasChildren,
          has_other_pets: user.hasOtherPets,
        },
        animal: {
          species: animal.species,
          age: animal.age,
          size: animal.size,
          energy_level: animal.energyLevel,
          good_with_children: animal.goodWithChildren,
          good_with_pets: animal.goodWithPets,
        },
      };

      const response = await firstValueFrom(
        this.httpService.post(`${this.aiServiceUrl}/predict`, payload)
      );

      return response.data;
    } catch (error) {
      this.logger.error(`Failed to get compatibility prediction: ${error.message}`);
      throw error;
    }
  }

  async batchPredict(userId: string, animals: Animal[]): Promise<any> {
    try {
      const user = await this.usersService.findOne(userId);
      
      const payload = {
        user: {
          housing_type: user.housingType,
          available_time: user.availableTime,
          experience: user.experience,
          has_children: user.hasChildren,
          has_other_pets: user.hasOtherPets,
        },
        animals: animals.map(animal => ({
          id: animal.id,
          species: animal.species,
          age: animal.age,
          size: animal.size,
          energy_level: animal.energyLevel,
          good_with_children: animal.goodWithChildren,
          good_with_pets: animal.goodWithPets,
        })),
      };

      const response = await firstValueFrom(
        this.httpService.post(`${this.aiServiceUrl}/predict/batch`, payload)
      );

      // Merge with full animal data
      const predictions = response.data.predictions;
      const enrichedPredictions = predictions.map((pred: any) => {
        const animal = animals.find(a => a.id === pred.animal_id);
        return {
          ...pred,
          animal,
        };
      });

      return { predictions: enrichedPredictions };
    } catch (error) {
      this.logger.error(`Failed to get batch predictions: ${error.message}`);
      throw error;
    }
  }
}
