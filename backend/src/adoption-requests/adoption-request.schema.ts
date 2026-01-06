import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';

export enum AdoptionStatus {
  PENDING = 'pending',
  APPROVED = 'approved',
  REJECTED = 'rejected',
  COMPLETED = 'completed',
}

@Schema({ timestamps: true })
export class AdoptionRequest extends Document {
  @Prop({ type: Types.ObjectId, ref: 'User', required: true })
  userId: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: 'Animal', required: true })
  animalId: Types.ObjectId;

  @Prop({ type: String, enum: AdoptionStatus, default: AdoptionStatus.PENDING })
  status: AdoptionStatus;

  @Prop({ type: Number })
  compatibilityScore?: number;

  @Prop()
  message?: string;

  @Prop()
  shelterNotes?: string;
}

export const AdoptionRequestSchema = SchemaFactory.createForClass(AdoptionRequest);
