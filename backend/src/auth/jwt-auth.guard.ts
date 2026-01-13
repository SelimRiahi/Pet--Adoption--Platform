import { Injectable, ExecutionContext, UnauthorizedException } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {
  canActivate(context: ExecutionContext) {
    const request = context.switchToHttp().getRequest();
    const authHeader = request.headers.authorization;
    console.log('🔒 JWT Guard - Authorization header:', authHeader ? `${authHeader.substring(0, 50)}...` : 'MISSING');
    return super.canActivate(context);
  }

  handleRequest(err: any, user: any, info: any) {
    if (err || !user) {
      console.log('❌ JWT Guard - Authentication failed:', info?.message || err?.message || 'Unknown error');
      throw err || new UnauthorizedException(info?.message || 'Unauthorized');
    }
    console.log('✅ JWT Guard - User authenticated:', user.email);
    return user;
  }
}
