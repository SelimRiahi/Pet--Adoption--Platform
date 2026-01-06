# NestJS Backend API

REST API for the pet adoption platform with JWT authentication and AI integration.

## Features

- **Authentication**: JWT-based with Passport.js
- **User Management**: Profile management with lifestyle information
- **Animal Management**: CRUD operations for shelters
- **Adoption Requests**: Full workflow from request to approval
- **AI Integration**: Compatibility scoring via AI microservice
- **Role-Based Access**: User, Shelter, and Admin roles

## Tech Stack

- NestJS 10
- TypeORM with PostgreSQL
- JWT Authentication
- Class-validator
- Axios for HTTP requests

## Setup

### 1. Install Dependencies

```bash
npm install
```

### 2. Configure Database

Create a PostgreSQL database and configure `.env`:

```bash
cp .env.example .env
```

Edit `.env` with your database credentials:
```
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_USER=postgres
DATABASE_PASSWORD=your_password
DATABASE_NAME=pet_adoption
```

### 3. Start the API

```bash
# Development
npm run start:dev

# Production
npm run build
npm run start:prod
```

API runs on `http://localhost:3000`

## API Endpoints

### Authentication

**Register**
```
POST /auth/register
{
  "email": "user@example.com",
  "password": "password123",
  "name": "John Doe",
  "role": "user" // or "shelter"
}
```

**Login**
```
POST /auth/login
{
  "email": "user@example.com",
  "password": "password123"
}
```

Returns:
```json
{
  "access_token": "jwt_token",
  "user": { ... }
}
```

### Users

**Get Profile**
```
GET /users/profile
Authorization: Bearer <token>
```

**Update Profile**
```
PATCH /users/profile
Authorization: Bearer <token>
{
  "housingType": "apartment",
  "availableTime": 4,
  "experience": "some",
  "hasChildren": true,
  "hasOtherPets": false
}
```

### Animals

**List Animals**
```
GET /animals
GET /animals?species=dog&size=small&goodWithChildren=true
```

**Get Animal**
```
GET /animals/:id
```

**Create Animal** (Shelter only)
```
POST /animals
Authorization: Bearer <token>
{
  "name": "Buddy",
  "species": "dog",
  "breed": "Golden Retriever",
  "age": 3,
  "size": "large",
  "energyLevel": 7,
  "goodWithChildren": true,
  "goodWithPets": true,
  "description": "Friendly and energetic",
  "imageUrl": "https://..."
}
```

**Get Compatibility Score**
```
GET /animals/:id/compatibility
Authorization: Bearer <token>
```

Returns:
```json
{
  "compatibility_score": 78.45,
  "recommendation": "good"
}
```

**Get Recommendations**
```
POST /animals/recommendations
Authorization: Bearer <token>
{
  "animalIds": ["uuid1", "uuid2"] // Optional, if not provided returns all
}
```

Returns sorted list by compatibility score.

### Adoption Requests

**Create Request**
```
POST /adoption-requests
Authorization: Bearer <token>
{
  "animalId": "uuid",
  "message": "I would love to adopt this pet"
}
```

**List Requests**
```
GET /adoption-requests
Authorization: Bearer <token>
```
- Users see their requests
- Shelters see requests for their animals

**Update Status** (Shelter only)
```
PATCH /adoption-requests/:id/status
Authorization: Bearer <token>
{
  "status": "approved", // or "rejected", "completed"
  "shelterNotes": "Great match!"
}
```

**Delete Request**
```
DELETE /adoption-requests/:id
Authorization: Bearer <token>
```

## Database Schema

### Users Table
- id, email, password, name, role
- housingType, availableTime, experience
- hasChildren, hasOtherPets
- phoneNumber, address

### Animals Table
- id, name, species, breed, age, size
- energyLevel, goodWithChildren, goodWithPets
- description, imageUrl, status
- shelterId (FK to users)

### Adoption Requests Table
- id, userId (FK), animalId (FK)
- status, compatibilityScore
- message, shelterNotes
- createdAt

## Environment Variables

See `.env.example` for all required variables.

## Development

```bash
# Watch mode
npm run start:dev

# Run tests
npm run test

# Format code
npm run format
```

## Production Considerations

1. Set `synchronize: false` in TypeORM config
2. Run migrations instead of auto-sync
3. Use environment variables for secrets
4. Enable HTTPS
5. Add rate limiting
6. Configure proper CORS
