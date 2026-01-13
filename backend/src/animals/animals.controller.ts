import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards, Request, Query } from '@nestjs/common';
import { AnimalsService } from './animals.service';
import { AiServiceService } from '../ai-service/ai-service.service';
import { UsersService } from '../users/users.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { Animal, AnimalSpecies, AnimalSize } from './animal.schema';
import { IsNotEmpty, IsEnum, IsNumber, IsBoolean, IsOptional, IsString, Min, Max } from 'class-validator';

class CreateAnimalDto {
  @IsNotEmpty()
  name: string;

  @IsEnum(AnimalSpecies)
  species: AnimalSpecies;

  @IsNotEmpty()
  breed: string;

  @IsNumber()
  @Min(0)
  @Max(30)
  age: number;

  @IsOptional()
  @IsString()
  gender?: string;

  @IsEnum(AnimalSize)
  size: AnimalSize;

  @IsNumber()
  @Min(0)
  @Max(10)
  energyLevel: number;

  @IsBoolean()
  goodWithChildren: boolean;

  @IsBoolean()
  goodWithPets: boolean;

  @IsNotEmpty()
  description: string;

  @IsOptional()
  @IsString()
  imageUrl?: string;

  @IsOptional()
  @IsBoolean()
  specialNeeds?: boolean;

  @IsOptional()
  @IsString()
  spaceRequirement?: string;

  @IsOptional()
  @IsString()
  shelterId?: string;
}

@Controller('animals')
export class AnimalsController {
  constructor(
    private readonly animalsService: AnimalsService,
    private readonly aiService: AiServiceService,
    private readonly usersService: UsersService,
  ) {}

  @UseGuards(JwtAuthGuard)
  @Post()
  async create(@Body() createAnimalDto: CreateAnimalDto, @Request() req) {
    console.log('🐾 Create animal endpoint hit');
    console.log('  - req.user:', req.user);
    console.log('  - body RAW:', JSON.stringify(createAnimalDto, null, 2));
    console.log('  - body species type:', typeof createAnimalDto.species, createAnimalDto.species);
    console.log('  - body size type:', typeof createAnimalDto.size, createAnimalDto.size);
    console.log('  - body energyLevel type:', typeof createAnimalDto.energyLevel, createAnimalDto.energyLevel);
    
    const shelterId = req.user.userId;
    console.log('  - resolved shelterId:', shelterId);
    
    // Remove shelterId, gender, specialNeeds, and spaceRequirement from DTO before passing to service
    const { shelterId: _, gender: __, specialNeeds: ___, spaceRequirement: ____, ...animalData } = createAnimalDto;
    console.log('  - animalData to create:', JSON.stringify(animalData, null, 2));
    
    try {
      const result = await this.animalsService.create(animalData, shelterId);
      console.log('✅ Animal created successfully');
      return result;
    } catch (error) {
      console.error('❌ Error creating animal:', error.message);
      console.error('❌ Error stack:', error.stack);
      throw error;
    }
  }

  @Get()
  findAll(@Query() filters: any) {
    return this.animalsService.findAll(filters);
  }

  @Get('shelter/:shelterId')
  findByShelter(@Param('shelterId') shelterId: string) {
    return this.animalsService.findByShelter(shelterId);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.animalsService.findOne(id);
  }

  @UseGuards(JwtAuthGuard)
  @Get(':id/compatibility')
  async getCompatibility(@Param('id') id: string, @Request() req) {
    try {
      console.log('🧬 Compatibility endpoint, user:', req.user);
      const animal = await this.animalsService.findOne(id);
      const userId = req.user.userId;
      console.log('  - Calculating compatibility for userId:', userId, 'animalId:', id);
      const compatibility = await this.aiService.predictCompatibility(userId, animal);
      console.log('  - Got compatibility score:', compatibility.compatibility_score);
      return compatibility;
    } catch (error) {
      console.error('⚠️ Compatibility check failed:', error.message);
      // Return mock compatibility if AI service is down
      return {
        compatibility_score: 75.0,
        recommendation: 'AI service unavailable - showing estimated compatibility',
      };
    }
  }

  @UseGuards(JwtAuthGuard)
  @Post('recommendations')
  async getRecommendations(@Request() req, @Body() body: { animalIds?: string[] }) {
    let animals: Animal[];
    
    if (body.animalIds && body.animalIds.length > 0) {
      animals = await Promise.all(
        body.animalIds.map(id => this.animalsService.findOne(id))
      );
    } else {
      animals = await this.animalsService.findAll({ status: 'available' });
    }
    
    const recommendations = await this.aiService.batchPredict(req.user.userId, animals);
    return recommendations;
  }

  @UseGuards(JwtAuthGuard)
  @Patch(':id')
  update(
    @Param('id') id: string,
    @Body() updateAnimalDto: Partial<CreateAnimalDto>,
    @Request() req,
  ) {
    // Remove shelterId from DTO if present
    const { shelterId: _, ...animalData } = updateAnimalDto;
    return this.animalsService.update(id, animalData, req.user.userId, req.user.role);
  }

  @UseGuards(JwtAuthGuard)
  @Delete(':id')
  remove(@Param('id') id: string, @Request() req) {
    return this.animalsService.remove(id, req.user.userId, req.user.role);
  }
}
