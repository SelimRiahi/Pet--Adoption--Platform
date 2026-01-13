import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards, Request } from '@nestjs/common';
import { UsersService } from './users.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { User } from './user.schema';

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @UseGuards(JwtAuthGuard)
  @Get('profile')
  async getProfile(@Request() req) {
    console.log('🔍 Profile endpoint hit, user:', req.user);
    const user = await this.usersService.findOne(req.user.userId);
    // Ensure boolean fields are never null
    if (user.hasChildren === null || user.hasChildren === undefined) user.hasChildren = false;
    if (user.hasOtherPets === null || user.hasOtherPets === undefined) user.hasOtherPets = false;
    return user;
  }

  @UseGuards(JwtAuthGuard)
  @Patch('profile')
  async updateProfile(@Request() req, @Body() updateData: Partial<User>) {
    console.log('✏️ Update profile endpoint, user:', req.user, 'data:', updateData);
    // Handle null boolean values - convert to false
    if (updateData.hasChildren === null) updateData.hasChildren = false;
    if (updateData.hasOtherPets === null) updateData.hasOtherPets = false;
    return this.usersService.update(req.user.userId, updateData);
  }

  @UseGuards(JwtAuthGuard)
  @Get()
  findAll() {
    return this.usersService.findAll();
  }

  @UseGuards(JwtAuthGuard)
  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.usersService.findOne(id);
  }

  @UseGuards(JwtAuthGuard)
  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.usersService.remove(id);
  }
}
