import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  
  // Enable CORS
  app.enableCors({
    origin: '*',
    credentials: true,
  });
  
  // Enable validation
  app.useGlobalPipes(new ValidationPipe({
    whitelist: true,
    transform: true,
    forbidNonWhitelisted: true,
    exceptionFactory: (errors) => {
      console.log('❌ Validation failed:', JSON.stringify(errors, null, 2));
      const messages = errors.map(error => ({
        field: error.property,
        constraints: error.constraints,
        value: error.value
      }));
      console.log('❌ Validation errors:', JSON.stringify(messages, null, 2));
      return new ValidationPipe().createExceptionFactory()(errors);
    },
  }));
  
  const port = process.env.PORT || 3000;
  await app.listen(port);
  
  console.log(`🚀 Backend API running on: http://localhost:${port}`);
  console.log(`🤖 AI Service URL: ${process.env.AI_SERVICE_URL}`);
}

bootstrap();
