import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards, Request, Query } from '@nestjs/common';
import { AdoptionRequestsService } from './adoption-requests.service';
import { UsersService } from '../users/users.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { IsNotEmpty, IsEnum, IsOptional, IsString } from 'class-validator';
import { AdoptionStatus } from './adoption-request.schema';

class CreateAdoptionRequestDto {
  @IsNotEmpty()
  animalId: string;

  @IsOptional()
  @IsString()
  message?: string;

  @IsOptional()
  @IsString()
  userId?: string;
}

class UpdateAdoptionStatusDto {
  @IsEnum(AdoptionStatus)
  status: AdoptionStatus;

  @IsOptional()
  @IsString()
  shelterNotes?: string;

  @IsOptional()
  @IsString()
  shelterId?: string;
}

@Controller('adoption-requests')
export class AdoptionRequestsController {
  constructor(
    private readonly requestsService: AdoptionRequestsService,
    private readonly usersService: UsersService,
  ) {}

  @UseGuards(JwtAuthGuard)
  @Post()
  async create(@Body() createDto: CreateAdoptionRequestDto, @Request() req) {
    console.log('📤 Create adoption request, user:', req.user);
    const userId = req.user.userId;
    return this.requestsService.create(userId, createDto.animalId, createDto.message);
  }

  @UseGuards(JwtAuthGuard)
  @Get()
  async findAll(@Request() req) {
    console.log('🔍 Adoption requests endpoint, user:', req.user);
    const userId = req.user.userId;
    const userRole = req.user.role;
    // If user is shelter, show requests for their animals
    if (userRole === 'shelter') {
      return this.requestsService.findByShelter(userId);
    }
    // If regular user, show their requests
    return this.requestsService.findByUser(userId);
  }

  @UseGuards(JwtAuthGuard)
  @Get('my-requests')
  async findMyRequests(@Request() req) {
    console.log('🔍 My requests endpoint, user:', req.user);
    const userId = req.user.userId;
    return this.requestsService.findByUser(userId);
  }

  @Get('shelter/:shelterId')
  findByShelter(@Param('shelterId') shelterId: string) {
    return this.requestsService.findByShelter(shelterId);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.requestsService.findOne(id);
  }

  @UseGuards(JwtAuthGuard)
  @Patch(':id/status')
  async updateStatus(
    @Param('id') id: string,
    @Body() updateDto: UpdateAdoptionStatusDto,
    @Request() req,
  ) {
    console.log('📝 Update request status');
    console.log('  - user:', req.user);
    console.log('  - body:', updateDto);
    console.log('  - body status:', updateDto.status);
    
    const shelterId = req.user.userId;
    const role = req.user.role;
    
    console.log('  - resolved shelterId:', shelterId);
    console.log('  - resolved role:', role);
    
    return this.requestsService.updateStatus(
      id,
      updateDto.status,
      shelterId,
      role,
      updateDto.shelterNotes,
    );
  }

  @UseGuards(JwtAuthGuard)
  @Delete(':id')
  remove(@Param('id') id: string, @Request() req) {
    return this.requestsService.remove(id, req.user.userId);
  }
}
