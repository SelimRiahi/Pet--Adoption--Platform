import { ExtractJwt, Strategy } from 'passport-jwt';
import { PassportStrategy } from '@nestjs/passport';
import { Injectable, UnauthorizedException } from '@nestjs/common';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor() {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: 'your-super-secret-jwt-key-change-this-in-production',
    });
  }

  async validate(payload: any) {
    console.log('🔑 JWT Payload received:', payload);
    if (!payload.sub || !payload.email) {
      console.log('❌ Invalid JWT payload - missing sub or email');
      throw new UnauthorizedException('Invalid token payload');
    }
    const user = { userId: payload.sub, email: payload.email, role: payload.role };
    console.log('✅ Validated user:', user);
    return user;
  }
}
