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

  @Post()
  async create(@Body() createDto: CreateAdoptionRequestDto, @Request() req) {
    console.log('📤 Create adoption request, user:', req.user, 'body userId:', createDto.userId);
    // Use userId from body (sent by frontend) or fallback to mock user
    let userId = createDto.userId || req.user?.userId;
    if (!userId) {
      const mockUser = await this.usersService.findByEmail('john@example.com');
      userId = mockUser._id.toString();
    }
    return this.requestsService.create(userId, createDto.animalId, createDto.message);
  }

  @Get()
  async findAll(@Request() req, @Query('userId') queryUserId?: string) {
    console.log('🔍 Adoption requests endpoint, user:', req.user, 'query userId:', queryUserId);
    // Use userId from query param (sent by frontend), JWT, or mock user
    let userId = queryUserId || req.user?.userId;
    let userRole = req.user?.role;
    if (!userId) {
      const mockUser = await this.usersService.findByEmail('john@example.com');
      userId = mockUser._id.toString();
      userRole = mockUser.role;
    }
    // If user is shelter, show requests for their animals
    if (userRole === 'shelter') {
      return this.requestsService.findByShelter(userId);
    }
    // If regular user, show their requests
    return this.requestsService.findByUser(userId);
  }

  @Get('my-requests')
  async findMyRequests(@Request() req) {
    console.log('🔍 My requests endpoint, user:', req.user);
    // Mock user for testing - use john's account
    let userId = req.user?.userId;
    if (!userId) {
      const mockUser = await this.usersService.findByEmail('john@example.com');
      userId = mockUser._id.toString();
    }
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

  @Patch(':id/status')
  async updateStatus(
    @Param('id') id: string,
    @Body() updateDto: UpdateAdoptionStatusDto,
    @Request() req,
  ) {
    console.log('📝 Update request status');
    console.log('  - user:', req.user);
    console.log('  - body:', updateDto);
    console.log('  - body shelterId:', updateDto.shelterId);
    console.log('  - body status:', updateDto.status);
    
    // Use shelterId from body (sent by frontend) or fallback
    let shelterId = updateDto.shelterId || req.user?.userId;
    if (!shelterId) {
      const mockShelter = await this.usersService.findByEmail('happypaws@shelter.com');
      shelterId = mockShelter._id.toString();
    }
    const role = req.user?.role || 'shelter';
    
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

  @Delete(':id')
  remove(@Param('id') id: string, @Request() req) {
    return this.requestsService.remove(id, req.user.userId);
  }
}
