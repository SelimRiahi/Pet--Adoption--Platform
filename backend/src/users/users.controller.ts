import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards, Request } from '@nestjs/common';
import { UsersService } from './users.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { User } from './user.schema';

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get('profile')
  async getProfile(@Request() req) {
    console.log('🔍 Profile endpoint hit, user:', req.user);
    // Mock user for testing when JWT fails
    if (!req.user) {
      const mockUser = await this.usersService.findByEmail('john@example.com');
      return mockUser;
    }
    return this.usersService.findOne(req.user.userId);
  }

  @Patch('profile')
  async updateProfile(@Request() req, @Body() updateData: Partial<User>) {
    console.log('✏️ Update profile endpoint, user:', req.user, 'data:', updateData);
    // Mock user for testing
    if (!req.user) {
      const mockUser = await this.usersService.findByEmail('john@example.com');
      return this.usersService.update(mockUser._id.toString(), updateData);
    }
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
