import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { MongooseModule } from '@nestjs/mongoose';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { AnimalsModule } from './animals/animals.module';
import { AdoptionRequestsModule } from './adoption-requests/adoption-requests.module';
import { AiServiceModule } from './ai-service/ai-service.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    MongooseModule.forRoot(
      process.env.MONGODB_URI || 'mongodb://localhost:27017/pet_adoption',
    ),
    AuthModule,
    UsersModule,
    AnimalsModule,
    AdoptionRequestsModule,
    AiServiceModule,
  ],
})
export class AppModule {}
