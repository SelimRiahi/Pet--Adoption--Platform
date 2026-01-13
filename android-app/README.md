# Android Pet Adoption App

Native Android application built with **Kotlin** and **Jetpack Compose**.

## Tech Stack

- **Kotlin** - Modern programming language for Android
- **Jetpack Compose** - Declarative UI framework
- **Material 3** - Modern Material Design
- **Retrofit** - REST API client
- **Kotlin Coroutines** - Asynchronous programming
- **ViewModel** - State management
- **Navigation Compose** - Screen navigation
- **DataStore** - Secure token storage
- **Coil** - Image loading

## Architecture

- **MVVM** (Model-View-ViewModel) pattern
- **Repository pattern** for data access
- **Single Activity** with Compose navigation

## Project Structure

```
app/src/main/java/com/petadoption/app/
├── data/
│   ├── model/          # Data models (User, Animal, AdoptionRequest)
│   ├── remote/         # API service & client
│   └── repository/     # Data repositories
├── ui/
│   ├── screens/        # UI screens
│   │   ├── auth/       # Login/Register
│   │   └── home/       # Home screen
│   ├── theme/          # App theme & colors
│   └── navigation/     # Navigation setup
├── MainActivity.kt     # Main activity
└── PetAdoptionApp.kt   # Application class
```

## Features Implemented

✅ Authentication (Login/Register)  
✅ API integration with Retrofit  
✅ Material 3 design  
✅ Navigation system  
✅ Secure token storage  
🚧 Animal listing (pending backend)  
🚧 Adoption requests  
🚧 User profile

## Setup Instructions

### Prerequisites

- **Android Studio** Hedgehog (2023.1.1) or later
- **JDK 17** or later
- **Android SDK** with minimum API 24 (Android 7.0)

### Installation

1. Open Android Studio
2. Click **File → Open**
3. Navigate to `android-app` directory
4. Wait for Gradle sync to complete
5. Connect Android device or start emulator
6. Click **Run** ▶️

### Backend Configuration

The app connects to the backend at `http://10.0.2.2:3000` (Android emulator localhost).

For physical devices, update the BASE_URL in [ApiClient.kt](app/src/main/java/com/petadoption/app/data/remote/ApiClient.kt):

```kotlin
private const val BASE_URL = "http://YOUR_COMPUTER_IP:3000/"
```

## Building

### Debug Build

```bash
./gradlew assembleDebug
```

### Release Build

```bash
./gradlew assembleRelease
```

## Key Dependencies

- Compose BOM 2024.01.00
- Kotlin 1.9.20
- Retrofit 2.9.0
- Coroutines 1.7.3
- Navigation Compose 2.7.6
- Material 3
