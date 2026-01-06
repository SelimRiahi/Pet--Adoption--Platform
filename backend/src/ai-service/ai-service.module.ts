import { Module } from '@nestjs/common';
import { HttpModule } from '@nestjs/axios';
import { AiServiceService } from './ai-service.service';
import { UsersModule } from '../users/users.module';

@Module({
  imports: [HttpModule, UsersModule],
  providers: [AiServiceService],
  exports: [AiServiceService],
})
export class AiServiceModule {}
