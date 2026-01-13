# iOS Pet Adoption App

Native iOS application built with **Swift** and **SwiftUI**.

## Tech Stack

- **Swift** - Modern programming language for iOS
- **SwiftUI** - Declarative UI framework
- **URLSession** - Network requests
- **Combine** - Reactive programming
- **UserDefaults** - Token storage

## Architecture

- **MVVM** (Model-View-ViewModel) pattern
- **ObservableObject** for state management
- **async/await** for asynchronous operations

## Project Structure

```
PetAdoption/
├── Models/              # Data models (User, Animal, AdoptionRequest)
├── Services/            # API service layer
├── ViewModels/          # View models (AuthViewModel)
├── Views/               # SwiftUI views
│   ├── Auth/            # Login/Register
│   └── Home/            # Home screen
├── PetAdoptionApp.swift # App entry point
└── ContentView.swift    # Main content view
```

## Features Implemented

✅ Authentication (Login/Register)  
✅ API integration with URLSession  
✅ SwiftUI modern design  
✅ Navigation system  
✅ Token storage  
🚧 Animal listing (pending backend)  
🚧 Adoption requests  
🚧 User profile

## Setup Instructions

### Prerequisites

- **Xcode 15.0** or later
- **macOS 13.0** (Ventura) or later
- **iOS 16.0+** deployment target
- **Apple Developer Account** (for device testing)

### Installation

1. Open Xcode
2. Click **File → Open**
3. Navigate to `ios-app` directory
4. Open `PetAdoption.xcodeproj`
5. Select target device or simulator
6. Click **Run** ▶️

### Backend Configuration

The app connects to the backend at `http://localhost:3000`.

For iOS Simulator, update the baseURL in [APIService.swift](PetAdoption/Services/APIService.swift):

```swift
private let baseURL = "http://localhost:3000"
```

For physical devices, use your computer's IP:

```swift
private let baseURL = "http://YOUR_COMPUTER_IP:3000"
```

## Building

### Debug Build

Select **Product → Build** (⌘B)

### Run on Simulator

Select **Product → Run** (⌘R)

### Run on Device

1. Connect iPhone/iPad
2. Select device in Xcode
3. Click **Run** ▶️

## Key Features

- **SwiftUI** for modern declarative UI
- **async/await** for clean asynchronous code
- **MVVM architecture** for separation of concerns
- **Environment objects** for state management
- **NavigationStack** for navigation

## Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+
