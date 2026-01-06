import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/animals/screens/animal_detail_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/recommendations/screens/recommendations_screen.dart';
import '../../features/adoption_requests/screens/adoption_requests_screen.dart';
import '../../features/shelter/screens/shelter_dashboard_screen.dart';
import '../../features/shelter/screens/add_animal_screen.dart';
import '../../features/auth/bloc/auth_bloc.dart';

class AppRouter {
  static GoRouter router(AuthBloc authBloc) {
    return GoRouter(
      initialLocation: '/login',
      refreshListenable: _AuthChangeNotifier(authBloc),
      redirect: (context, state) {
        final authState = authBloc.state;
        final isAuthenticated = authState is AuthAuthenticated;
        final isAuthRoute = state.matchedLocation == '/login' ||
            state.matchedLocation == '/register';

        // Redirect to appropriate page based on role when authenticated
        if (isAuthenticated) {
          print('🔀 Router: user role = ${authState.user.role}');
          print('🔀 Router: current path = ${state.matchedLocation}');
          final isShelter = authState.user.role == 'shelter';
          print('🔀 Router: isShelter = $isShelter');

          // If trying to access auth pages, redirect to dashboard
          if (isAuthRoute) {
            return isShelter ? '/shelter-dashboard' : '/home';
          }

          // Prevent shelters from accessing user pages
          if (isShelter &&
              (state.matchedLocation == '/home' ||
                  state.matchedLocation == '/recommendations' ||
                  state.matchedLocation == '/adoption-requests')) {
            return '/shelter-dashboard';
          }

          // Prevent users from accessing shelter pages
          if (!isShelter && state.matchedLocation == '/shelter-dashboard') {
            return '/home';
          }
        }

        // Redirect to login if not authenticated and trying to access protected pages
        if (!isAuthenticated && !isAuthRoute) {
          return '/login';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          name: 'register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/animal/:id',
          name: 'animal-detail',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return AnimalDetailScreen(animalId: id);
          },
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/profile/edit',
          name: 'edit-profile',
          builder: (context, state) => const EditProfileScreen(),
        ),
        GoRoute(
          path: '/recommendations',
          name: 'recommendations',
          builder: (context, state) => const RecommendationsScreen(),
        ),
        GoRoute(
          path: '/adoption-requests',
          name: 'adoption-requests',
          builder: (context, state) => const AdoptionRequestsScreen(),
        ),
        GoRoute(
          path: '/shelter-dashboard',
          name: 'shelter-dashboard',
          builder: (context, state) => const ShelterDashboardScreen(),
        ),
        GoRoute(
          path: '/add-animal',
          name: 'add-animal',
          builder: (context, state) => const AddAnimalScreen(),
        ),
      ],
    );
  }
}

// Helper class to notify router when auth state changes
class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier(AuthBloc authBloc) {
    authBloc.stream.listen((_) {
      notifyListeners();
    });
  }
}
