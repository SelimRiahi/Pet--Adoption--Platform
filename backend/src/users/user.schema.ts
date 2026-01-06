import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';
import { Exclude } from 'class-transformer';

export enum UserRole {
  USER = 'user',
  SHELTER = 'shelter',
  ADMIN = 'admin',
}

export enum HousingType {
  APARTMENT = 'apartment',
  HOUSE_SMALL = 'house_small',
  HOUSE_LARGE = 'house_large',
}

export enum Experience {
  NONE = 'none',
  SOME = 'some',
  EXPERT = 'expert',
}

@Schema({ timestamps: true })
export class User extends Document {
  @Prop({ required: true, unique: true })
  email: string;

  @Prop({ required: true })
  @Exclude()
  password: string;

  @Prop({ required: true })
  name: string;

  @Prop({ type: String, enum: UserRole, default: UserRole.USER })
  role: UserRole;

  @Prop({ type: String, enum: HousingType })
  housingType?: HousingType;

  @Prop({ type: Number, default: 5 })
  availableTime?: number;

  @Prop({ type: String, enum: Experience, default: Experience.NONE })
  experience?: Experience;

  @Prop({ type: Boolean, default: false })
  hasChildren: boolean;

  @Prop({ type: Boolean, default: false })
  hasOtherPets: boolean;

  @Prop()
  phoneNumber?: string;

  @Prop()
  address?: string;
}

export const UserSchema = SchemaFactory.createForClass(User);
