import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { AdoptionRequestsController } from './adoption-requests.controller';
import { AdoptionRequestsService } from './adoption-requests.service';
import { AdoptionRequest, AdoptionRequestSchema } from './adoption-request.schema';
import { AnimalsModule } from '../animals/animals.module';
import { AiServiceModule } from '../ai-service/ai-service.module';
import { UsersModule } from '../users/users.module';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: AdoptionRequest.name, schema: AdoptionRequestSchema }]),
    AnimalsModule,
    AiServiceModule,
    UsersModule,
  ],
  controllers: [AdoptionRequestsController],
  providers: [AdoptionRequestsService],
})
export class AdoptionRequestsModule {}
