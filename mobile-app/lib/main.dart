import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/routes/app_router.dart';
import 'core/services/api_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/animals/bloc/animals_bloc.dart';
import 'features/profile/bloc/profile_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();
  const secureStorage = FlutterSecureStorage();
  final apiService = ApiService(secureStorage: secureStorage);

  runApp(MyApp(
    apiService: apiService,
    sharedPreferences: sharedPreferences,
    secureStorage: secureStorage,
  ));
}

class MyApp extends StatelessWidget {
  final ApiService apiService;
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;

  const MyApp({
    super.key,
    required this.apiService,
    required this.sharedPreferences,
    required this.secureStorage,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: apiService),
        RepositoryProvider.value(value: sharedPreferences),
        RepositoryProvider.value(value: secureStorage),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              apiService: apiService,
              secureStorage: secureStorage,
            )..add(AuthCheckRequested()),
          ),
          BlocProvider(
            create: (context) => AnimalsBloc(apiService: apiService),
          ),
          BlocProvider(
            create: (context) => ProfileBloc(apiService: apiService),
          ),
        ],
        child: Builder(
          builder: (context) {
            final authBloc = context.read<AuthBloc>();
            return MaterialApp.router(
              title: 'Pet Adoption',
              theme: AppTheme.lightTheme,
              routerConfig: AppRouter.router(authBloc),
              debugShowCheckedModeBanner: false,
            );
          },
        ),
      ),
    );
  }
}
