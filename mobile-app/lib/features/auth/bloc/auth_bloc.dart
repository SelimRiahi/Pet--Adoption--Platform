import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/models/user.dart';
import '../../../core/services/api_service.dart';

// Events
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String role;

  AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.name,
    required this.role,
  });

  @override
  List<Object?> get props => [email, password, name, role];
}

class AuthLogoutRequested extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  final String token;

  AuthAuthenticated({required this.user, required this.token});

  @override
  List<Object?> get props => [user, token];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService apiService;
  final FlutterSecureStorage secureStorage;

  AuthBloc({
    required this.apiService,
    required this.secureStorage,
  }) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final token = await apiService.getToken();
      final userData = await apiService.getUserData();

      if (token != null && userData != null) {
        final user = User.fromJson(userData);
        print('🔄 Restored session: ${user.email}, role: ${user.role}');
        emit(AuthAuthenticated(user: user, token: token));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      print('❌ Error restoring session: $e');
      await apiService.deleteToken();
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await apiService.post(
        '/auth/login',
        {'email': event.email, 'password': event.password},
        includeAuth: false,
      );

      final token = response['access_token'];
      final user = User.fromJson(response['user']);

      print(
          '🔐 Login successful, token: ${token.toString().substring(0, 20)}...');
      await apiService.saveToken(token);
      await apiService.saveUserData(response['user']);
      print('💾 Token and user data saved to storage');
      emit(AuthAuthenticated(user: user, token: token));
    } catch (e) {
      emit(AuthError(message: e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      print(
          '🔵 Registering with: ${event.email}, ${event.name}, ${event.role}');
      final response = await apiService.post(
        '/auth/register',
        {
          'email': event.email,
          'password': event.password,
          'name': event.name,
          'role': event.role,
        },
        includeAuth: false,
      );

      print('✅ Registration response: $response');
      final token = response['access_token'];
      print('📦 User data from backend: ${response['user']}');
      final user = User.fromJson(response['user']);
      print('👤 Parsed user role: ${user.role}');

      await apiService.saveToken(token);
      await apiService.saveUserData(response['user']);
      emit(AuthAuthenticated(user: user, token: token));
    } catch (e) {
      print('❌ Registration error: $e');
      emit(AuthError(message: e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await apiService.deleteToken();
    emit(AuthUnauthenticated());
  }
}
