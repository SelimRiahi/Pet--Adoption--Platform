import { ExtractJwt, Strategy } from 'passport-jwt';
import { PassportStrategy } from '@nestjs/passport';
import { Injectable } from '@nestjs/common';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor() {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: process.env.JWT_SECRET || 'super-secret-key',
    });
  }

  async validate(payload: any) {
    console.log('🔑 JWT Payload received:', payload);
    const user = { userId: payload.sub, email: payload.email, role: payload.role };
    console.log('✅ Validated user:', user);
    return user;
  }
}
