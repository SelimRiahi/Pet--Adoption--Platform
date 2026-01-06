import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { UsersService } from './users/users.service';
import { AnimalsService } from './animals/animals.service';
import { UserRole } from './users/user.schema';
import { AnimalSpecies, AnimalSize } from './animals/animal.schema';

async function bootstrap() {
  const app = await NestFactory.createApplicationContext(AppModule);
  
  const usersService = app.get(UsersService);
  const animalsService = app.get(AnimalsService);

  console.log('🌱 Starting database seeding...');

  // Create shelter users
  const shelter1 = await usersService.create({
    email: 'happypaws@shelter.com',
    password: 'password123',
    name: 'Happy Paws Shelter',
    role: UserRole.SHELTER,
  });

  const shelter2 = await usersService.create({
    email: 'furryfriends@shelter.com',
    password: 'password123',
    name: 'Furry Friends Rescue',
    role: UserRole.SHELTER,
  });

  console.log('✅ Created shelter accounts');

  // Create sample animals
  const animalsData = [
    {
      name: 'Max',
      species: AnimalSpecies.DOG,
      breed: 'Golden Retriever',
      age: 3,
      size: AnimalSize.LARGE,
      temperament: 'friendly',
      energyLevel: 9,
      description: 'Max is a friendly and energetic Golden Retriever who loves to play fetch and go for long walks. Great with kids!',
      shelterId: shelter1._id.toString(),
      imageUrl: 'https://images.unsplash.com/photo-1633722715463-d30f4f325e24?w=400',
    },
    {
      name: 'Luna',
      species: AnimalSpecies.CAT,
      breed: 'Siamese',
      age: 2,
      size: AnimalSize.SMALL,
      temperament: 'calm',
      energyLevel: 3,
      description: 'Luna is a calm and affectionate Siamese cat. She enjoys quiet environments and loves to cuddle.',
      shelterId: shelter1._id.toString(),
      imageUrl: 'https://images.unsplash.com/photo-1513360371669-4adf3dd7dff8?w=400',
    },
    {
      name: 'Rocky',
      species: AnimalSpecies.DOG,
      breed: 'German Shepherd',
      age: 5,
      size: AnimalSize.LARGE,
      temperament: 'protective',
      energyLevel: 8,
      description: 'Rocky is a loyal and protective German Shepherd. Well-trained and great for active families.',
      shelterId: shelter2._id.toString(),
      imageUrl: 'https://images.unsplash.com/photo-1568572933382-74d440642117?w=400',
    },
    {
      name: 'Bella',
      species: AnimalSpecies.DOG,
      breed: 'Labrador',
      age: 2,
      size: AnimalSize.LARGE,
      temperament: 'friendly',
      energyLevel: 7,
      description: 'Bella is a sweet Labrador who loves everyone she meets. Perfect family dog!',
      shelterId: shelter2._id.toString(),
      imageUrl: 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=400',
    },
    {
      name: 'Whiskers',
      species: AnimalSpecies.CAT,
      breed: 'Persian',
      age: 4,
      size: AnimalSize.SMALL,
      temperament: 'calm',
      energyLevel: 2,
      description: 'Whiskers is a gentle Persian cat who enjoys a peaceful home. Very low maintenance.',
      shelterId: shelter1._id.toString(),
      imageUrl: 'https://images.unsplash.com/photo-1574158622682-e40e69881006?w=400',
    },
    {
      name: 'Charlie',
      species: AnimalSpecies.DOG,
      breed: 'Beagle',
      age: 1,
      size: AnimalSize.MEDIUM,
      temperament: 'playful',
      energyLevel: 9,
      description: 'Charlie is a playful Beagle puppy full of energy. Loves to explore and play!',
      shelterId: shelter2._id.toString(),
      imageUrl: 'https://images.unsplash.com/photo-1505628346881-b72b27e84530?w=400',
    },
    {
      name: 'Mittens',
      species: AnimalSpecies.CAT,
      breed: 'Tabby',
      age: 3,
      size: AnimalSize.SMALL,
      temperament: 'independent',
      energyLevel: 5,
      description: 'Mittens is an independent tabby who likes her space but also enjoys attention on her terms.',
      shelterId: shelter1._id.toString(),
      imageUrl: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?w=400',
    },
    {
      name: 'Buddy',
      species: AnimalSpecies.DOG,
      breed: 'Poodle',
      age: 6,
      size: AnimalSize.MEDIUM,
      temperament: 'friendly',
      energyLevel: 6,
      description: 'Buddy is a well-behaved Poodle who is great with children and other pets.',
      shelterId: shelter2._id.toString(),
      imageUrl: 'https://images.unsplash.com/photo-1537151608828-ea2b11777ee8?w=400',
    },
  ];

  for (const animalData of animalsData) {
    const { shelterId, ...rest } = animalData;
    await animalsService.create(rest, shelterId);
  }

  console.log(`✅ Created ${animalsData.length} sample animals`);
  console.log('🎉 Seeding completed!');
  
  await app.close();
}

bootstrap();
