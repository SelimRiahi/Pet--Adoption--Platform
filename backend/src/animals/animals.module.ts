import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { AnimalsController } from './animals.controller';
import { AnimalsService } from './animals.service';
import { Animal, AnimalSchema } from './animal.schema';
import { AiServiceModule } from '../ai-service/ai-service.module';
import { UsersModule } from '../users/users.module';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: Animal.name, schema: AnimalSchema }]),
    AiServiceModule,
    UsersModule,
  ],
  controllers: [AnimalsController],
  providers: [AnimalsService],
  exports: [AnimalsService],
})
export class AnimalsModule {}
