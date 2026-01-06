import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';

export enum AnimalSpecies {
  CAT = 'cat',
  DOG = 'dog',
  BIRD = 'bird',
  RABBIT = 'rabbit',
  OTHER = 'other',
}

export enum AnimalSize {
  SMALL = 'small',
  MEDIUM = 'medium',
  LARGE = 'large',
}

export enum AnimalStatus {
  AVAILABLE = 'available',
  PENDING = 'pending',
  ADOPTED = 'adopted',
}

@Schema({ timestamps: true })
export class Animal extends Document {
  @Prop({ required: true })
  name: string;

  @Prop({ type: String, enum: AnimalSpecies, required: true })
  species: AnimalSpecies;

  @Prop({ required: true })
  breed: string;

  @Prop({ type: Number, required: true })
  age: number;

  @Prop({ type: String, enum: AnimalSize, required: true })
  size: AnimalSize;

  @Prop({ type: Number, required: true })
  energyLevel: number;

  @Prop({ type: Boolean, default: true })
  goodWithChildren: boolean;

  @Prop({ type: Boolean, default: true })
  goodWithPets: boolean;

  @Prop({ required: true })
  description: string;

  @Prop()
  imageUrl?: string;

  @Prop({ type: String, enum: AnimalStatus, default: AnimalStatus.AVAILABLE })
  status: AnimalStatus;

  @Prop({ type: Types.ObjectId, ref: 'User', required: true })
  shelterId: Types.ObjectId;
}

export const AnimalSchema = SchemaFactory.createForClass(Animal);
