# Pet Adoption Mobile App (Flutter)

A beautiful and intuitive mobile application for pet adoption with AI-powered compatibility matching.

## Features

### User Features

- ✅ Authentication (Login/Register)
- ✅ User profile with lifestyle information
- ✅ Browse animals available for adoption
- ✅ View detailed animal profiles
- ✅ AI-powered compatibility scoring
- ✅ Personalized recommendations
- ✅ Submit adoption requests
- ✅ Track adoption request status

### Shelter Features

- ✅ Add and manage animals
- ✅ Review adoption requests
- ✅ Approve/reject requests

## Tech Stack

- **Flutter 3.0+**
- **BLoC Pattern** (State Management)
- **go_router** (Navigation)
- **http** (API Communication)
- **flutter_secure_storage** (Secure Token Storage)
- **shared_preferences** (Local Storage)

## Project Structure

```
lib/
├── core/
│   ├── config/
│   │   └── app_config.dart          # API configuration
│   ├── models/
│   │   ├── user.dart                # User model
│   │   └── animal.dart              # Animal model
│   ├── routes/
│   │   └── app_router.dart          # Navigation routes
│   ├── services/
│   │   └── api_service.dart         # API client
│   └── theme/
│       └── app_theme.dart           # App theme
├── features/
│   ├── auth/
│   │   ├── bloc/
│   │   │   └── auth_bloc.dart       # Authentication BLoC
│   │   └── screens/
│   │       ├── login_screen.dart
│   │       └── register_screen.dart
│   ├── home/
│   │   └── screens/
│   │       └── home_screen.dart     # Main animal listing
│   ├── animals/
│   │   ├── bloc/
│   │   │   └── animals_bloc.dart
│   │   └── screens/
│   │       └── animal_detail_screen.dart
│   ├── profile/
│   │   ├── bloc/
│   │   │   └── profile_bloc.dart
│   │   └── screens/
│   │       ├── profile_screen.dart
│   │       └── edit_profile_screen.dart
│   ├── recommendations/
│   │   └── screens/
│   │       └── recommendations_screen.dart
│   └── adoption_requests/
│       └── screens/
│           └── adoption_requests_screen.dart
└── main.dart                        # App entry point
```

## Setup & Installation

### Prerequisites

- Flutter SDK 3.0 or higher
- Dart 3.0 or higher
- Android Studio / VS Code with Flutter extensions
- Android emulator or iOS simulator

### Installation Steps

1. **Navigate to the mobile-app directory:**

```bash
cd mobile-app
```

2. **Install dependencies:**

```bash
flutter pub get
```

3. **Configure API endpoint:**

Edit [lib/core/config/app_config.dart](lib/core/config/app_config.dart):

```dart
// For Android emulator
static const String apiBaseUrl = 'http://10.0.2.2:3000';

// For iOS simulator
// static const String apiBaseUrl = 'http://localhost:3000';

// For physical device (use your computer's IP)
// static const String apiBaseUrl = 'http://192.168.1.X:3000';
```

4. **Run the app:**

```bash
# Check available devices
flutter devices

# Run on specific device
flutter run -d <device_id>

# Or just run (will prompt for device)
flutter run
```

## Configuration

### API Configuration

The app connects to the NestJS backend. Make sure:

1. Backend is running on `http://localhost:3000`
2. AI service is running on `http://localhost:5000`
3. Update `apiBaseUrl` in [app_config.dart](lib/core/config/app_config.dart) based on your setup

### Network Configuration (Android)

For Android emulator to access localhost, use:

- `10.0.2.2` instead of `localhost`

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<application
    android:usesCleartextTraffic="true"
    ...>
```

## Features Walkthrough

### 1. Authentication

- Register as a user or shelter
- Login with email and password
- JWT token stored securely

### 2. Browse Animals

- Grid view of available animals
- Filter by species, size, etc.
- Pull to refresh

### 3. Animal Details

- Full profile with images
- AI compatibility score
- Request adoption button

### 4. Recommendations

- AI-powered matching
- Sorted by compatibility score
- Visual compatibility indicators

### 5. Profile Management

- Update lifestyle information
- Housing type, available time
- Experience level
- Children and other pets info

### 6. Adoption Requests

- View all requests
- Status tracking (pending/approved/rejected)
- Compatibility scores

## BLoC Architecture

The app uses BLoC (Business Logic Component) pattern:

```
UI → Events → BLoC → States → UI
```

### Example Flow:

1. User taps login button
2. UI dispatches `AuthLoginRequested` event
3. `AuthBloc` processes the event
4. Makes API call via `ApiService`
5. Emits `AuthAuthenticated` state
6. UI reacts to state change

## API Integration

All API calls go through [ApiService](lib/core/services/api_service.dart):

```dart
final apiService = context.read<ApiService>();

// GET request
final data = await apiService.get('/animals');

// POST request with auth
final result = await apiService.post('/adoption-requests', {
  'animalId': 'uuid',
  'message': 'I want to adopt!',
});
```

## State Management

Using `flutter_bloc` for state management:

```dart
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    if (state is AuthLoading) return CircularProgressIndicator();
    if (state is AuthAuthenticated) return HomeScreen();
    return LoginScreen();
  },
)
```

## Building for Production

### Android

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk

# Or build app bundle (recommended for Play Store)
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
# Requires Mac and Xcode
```

## Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

## Troubleshooting

### Issue: Cannot connect to backend

**Solution:**

- Verify backend is running
- Check `apiBaseUrl` in config
- For Android emulator, use `10.0.2.2:3000`
- For iOS simulator, use `localhost:3000`
- For physical device, use your computer's IP

### Issue: JWT token errors

**Solution:**

- Logout and login again
- Clear app data
- Check token expiration in backend

### Issue: Images not loading

**Solution:**

- Check network permissions in manifest
- Verify image URLs are accessible
- Add `usesCleartextTraffic="true"` for HTTP images

## Future Enhancements

- [ ] Push notifications
- [ ] In-app messaging
- [ ] Photo upload for animals
- [ ] Search and advanced filters
- [ ] Favorites list
- [ ] Share animal profiles
- [ ] Dark mode support
- [ ] Localization

## Dependencies

Main dependencies in `pubspec.yaml`:

- `flutter_bloc` - State management
- `equatable` - Value equality
- `http` - HTTP client
- `go_router` - Navigation
- `flutter_secure_storage` - Secure storage
- `shared_preferences` - Local storage
- `cached_network_image` - Image caching

## Contributing

1. Follow Flutter/Dart style guide
2. Use BLoC pattern for state management
3. Add tests for new features
4. Update documentation

## License

MIT License
