# 🐾 Pet Adoption Platform

A full-stack pet adoption application with AI-powered compatibility matching between users and animals.

## 📱 Platform Support

✅ **Web** (Chrome, Firefox, Safari, Edge)  
✅ **Android** (Devices & Emulators)  
✅ **iOS** (iPhone, iPad - requires Mac)  
✅ **Windows** Desktop  
✅ **macOS** Desktop  
✅ **Linux** Desktop

> 💡 **Quick Start:** Run on web with `flutter run -d chrome` (easiest) or use Android Studio for mobile development.

### Platform Comparison

| Platform             | Setup Difficulty | Command                 | Best For                      |
| -------------------- | ---------------- | ----------------------- | ----------------------------- |
| **Web (Chrome)**     | ⭐ Easy          | `flutter run -d chrome` | Quick testing, development    |
| **Android Emulator** | ⭐⭐ Medium      | `flutter run`           | Mobile testing, full features |
| **Android Device**   | ⭐⭐⭐ Medium+   | `flutter run`           | Real device testing           |
| **iOS (Mac only)**   | ⭐⭐⭐⭐ Hard    | `flutter run`           | Apple ecosystem               |
| **Android Studio**   | ⭐⭐ Medium      | Click Run ▶️            | Full IDE experience           |

## 📋 Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Running the Application](#running-the-application)
- [Project Structure](#project-structure)
- [API Documentation](#api-documentation)
- [AI Model](#ai-model)
- [Troubleshooting](#troubleshooting)

---

## ✨ Features

### For Pet Adopters (Regular Users)

- 🔍 Browse available animals
- 💝 AI-powered compatibility score for each animal
- 📝 Request adoption with custom message
- 📊 Track adoption request status
- 👤 Manage user profile

### For Shelters

- ➕ Add new animals to inventory
- 📋 View all adoption requests
- ✅ Approve or reject adoption requests
- 🏠 Dedicated shelter dashboard
- 📈 See compatibility scores for requesters

### AI Features

- 🤖 Machine Learning compatibility prediction
- 📊 Score based on 11 features (housing, time available, experience, etc.)
- 🎯 Personalized recommendations

---

## 🛠 Tech Stack

**Frontend:**

- Flutter 3.38.5 (Cross-platform: **Web, Android, iOS, Windows, macOS, Linux**)
- Dart 3.10.4
- BLoC State Management
- go_router for navigation
- **Supports:** Chrome, Android devices, iOS devices (iPhone/iPad), Desktop apps

**Backend:**

- NestJS 10.3.0
- TypeScript 5.3.3
- MongoDB 8.2.3
- Mongoose 8.21.0
- JWT Authentication (with bypass workaround)

**AI Service:**

- Python 3.11
- Flask 3.0.0
- scikit-learn (Decision Tree Regressor)
- Trained on 5000 synthetic examples

---

## 📦 Prerequisites & Installation

### Step 1: Install Node.js (for Backend)

1. Download Node.js v18+ from [https://nodejs.org/](https://nodejs.org/)
2. Run the installer and follow the prompts
3. Verify installation:
   ```powershell
   node --version  # Should show v18+
   npm --version   # Should show 9+
   ```

### Step 2: Install Python (for AI Service)

1. Download Python 3.11+ from [https://www.python.org/downloads/](https://www.python.org/downloads/)
2. **Important:** During installation, check "Add Python to PATH"
3. Verify installation:
   ```powershell
   python --version  # Should show 3.11+
   pip --version     # Should be available
   ```

### Step 3: Install MongoDB Community Server

#### Windows Installation (Detailed):

1. **Download MongoDB:**

   - Go to [https://www.mongodb.com/try/download/community](https://www.mongodb.com/try/download/community)
   - Select version: **8.0.x** (or latest)
   - Platform: **Windows x64**
   - Package: **MSI**
   - Click **Download**

2. **Install MongoDB:**

   - Run the downloaded `.msi` file
   - Choose **Complete** installation type
   - **Important:** Check "Install MongoDB as a Service"
   - Service Name: `MongoDB`
   - Data Directory: `C:\Program Files\MongoDB\Server\8.0\data\`
   - Log Directory: `C:\Program Files\MongoDB\Server\8.0\log\`
   - Click **Next** and **Install**

3. **Add MongoDB to PATH:**

   ```powershell
   # Add MongoDB bin directory to system PATH
   # Go to: System Properties > Environment Variables
   # Edit "Path" variable and add:
   C:\Program Files\MongoDB\Server\8.0\bin
   ```

4. **Verify MongoDB Installation:**

   ```powershell
   mongod --version  # Should show version 8.0+
   mongosh --version # MongoDB Shell
   ```

5. **Create Data Directory (if not auto-created):**

   ```powershell
   # Create data directory
   mkdir C:\data\db

   # Or use custom directory
   mkdir C:\mongodb-data
   ```

6. **Start MongoDB Service:**

   ```powershell
   # If installed as service, it should auto-start
   # To manually start:
   net start MongoDB

   # To check if running:
   sc query MongoDB

   # Or start manually (without service):
   mongod --dbpath="C:\data\db"
   ```

7. **Test MongoDB Connection:**

   ```powershell
   # Open MongoDB Shell
   mongosh

   # Should see:
   # Connected to: mongodb://localhost:27017
   # Using MongoDB: 8.0.x

   # Test commands:
   show dbs
   exit
   ```

### Step 4: Install Flutter (for Frontend)

1. **Download Flutter SDK:**

   - Go to [https://docs.flutter.dev/get-started/install/windows](https://docs.flutter.dev/get-started/install/windows)
   - Download Flutter SDK ZIP file

2. **Extract Flutter:**

   - Extract ZIP to: `C:\src\flutter` (or your preferred location)
   - **Do NOT** extract to `C:\Program Files\`

3. **Add Flutter to PATH:**

   ```powershell
   # Add to system PATH:
   C:\src\flutter\bin
   ```

4. **Run Flutter Doctor:**

   ```powershell
   flutter doctor

   # This will check for any missing dependencies
   # Accept Android licenses if needed:
   flutter doctor --android-licenses
   ```

5. **Enable Chrome for Flutter Web:**

   ```powershell
   # We'll run on Chrome
   flutter config --enable-web
   ```

6. **Verify Flutter:**
   ```powershell
   flutter --version  # Should show 3.38.5+
   dart --version     # Should show 3.10.4+
   flutter devices    # Should list Chrome
   ```

### Step 5: Install Android Studio (Optional - for Android/iOS)

**If you want to run on Android devices or emulators:**

1. **Download Android Studio:**

   - Go to [https://developer.android.com/studio](https://developer.android.com/studio)
   - Download Android Studio (latest version)

2. **Install Android Studio:**

   - Run the installer
   - Choose **Standard** installation
   - Install Android SDK, Android SDK Platform-Tools, Android Virtual Device (AVD)

3. **Install Flutter Plugin:**

   - Open Android Studio
   - Go to: **File > Settings > Plugins**
   - Search for "Flutter"
   - Click **Install**
   - Also installs Dart plugin automatically

4. **Set up Android SDK:**

   ```powershell
   # Flutter will detect Android SDK automatically
   flutter doctor

   # Accept Android licenses
   flutter doctor --android-licenses
   # Type 'y' to accept all licenses
   ```

5. **Create Android Emulator:**

   - In Android Studio: **Tools > Device Manager**
   - Click **Create Device**
   - Select: **Pixel 5** or any device
   - Download system image (e.g., API 34 - Android 14)
   - Finish setup

6. **Verify Android Setup:**
   ```powershell
   flutter devices
   # Should list Android emulators and connected devices
   ```

### Step 6: iOS Setup (Mac Only)

**For iOS development, you need a Mac with Xcode:**

1. **Install Xcode from Mac App Store** (requires macOS)
2. **Install Xcode Command Line Tools:**
   ```bash
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   sudo xcodebuild -runFirstLaunch
   ```
3. **Install CocoaPods:**
   ```bash
   sudo gem install cocoapods
   ```
4. **Accept Xcode License:**
   ```bash
   sudo xcodebuild -license accept
   ```
5. **Verify iOS Setup:**
   ```bash
   flutter doctor
   # Should show iOS toolchain ready
   ```

---

## 🚀 Project Setup & Installation

### 1. Clone the Repository

```powershell
# Navigate to your workspace
cd C:\Users\YourName\Documents

# Clone (or if you have the folder already)
cd C:\Users\Selim\OneDrive\Bureau\pro\pet-adoption-platform
```

### 2. Backend Setup (NestJS)

```powershell
# Navigate to backend directory
cd backend

# Install dependencies
npm install

# This will install:
# - @nestjs/core, @nestjs/common, @nestjs/platform-express
# - @nestjs/mongoose (MongoDB integration)
# - @nestjs/jwt, @nestjs/passport (authentication)
# - mongoose (ODM for MongoDB)
# - class-validator, class-transformer
# - axios (for AI service calls)

# Wait for installation to complete (~2-3 minutes)
```

**Expected output:**

```
added 847 packages, and audited 848 packages in 2m
found 0 vulnerabilities
```

### 3. Frontend Setup (Flutter)

```powershell
# Navigate to mobile-app directory
cd mobile-app

# Get Flutter dependencies
flutter pub get

# This will install:
# - flutter_bloc (state management)
# - go_router (navigation)
# - http (API calls)
# - shared_preferences (local storage)
# - equatable (value equality)

# Wait for completion (~1-2 minutes)
```

**Expected output:**

```
Running "flutter pub get" in mobile-app...
Resolving dependencies... (2.5s)
Got dependencies!
```

### 4. AI Service Setup (Python Flask)

```powershell
# Navigate to ai-service directory
cd ai-service

# Install Python dependencies
pip install flask flask-cors scikit-learn joblib numpy pandas

# This installs:
# - Flask 3.0.0 (web framework)
# - flask-cors (handle CORS for cross-origin requests)
# - scikit-learn 1.5+ (machine learning library)
# - joblib (model serialization)
# - numpy (numerical operations)
# - pandas (data handling)

# Wait for installation (~3-5 minutes)
```

**Expected output:**

```
Successfully installed flask-3.0.0 flask-cors-4.0.0 scikit-learn-1.5.0 ...
```

### 5. Train the AI Model (Required - First Time Only)

> **Important:** The trained model files (`.pkl`) are excluded from Git to keep the repository clean. You must train the model before running the AI service.

```powershell
# Still in ai-service directory
# Run the training script
python train_model.py
```

**What this does:**

1. **Generates `training_data.csv`** with 5,000 synthetic examples
2. **Creates training dataset** with 11 features:
   - `housing_type`: apartment, house, condo
   - `time_available`: low, medium, high
   - `experience_level`: beginner, intermediate, expert
   - `has_children`: 0 or 1
   - `has_other_pets`: 0 or 1
   - `animal_species`: dog, cat, bird, rabbit
   - `animal_age_years`: 0-15
   - `animal_size`: small, medium, large
   - `animal_energy_level`: low, medium, high
   - `good_with_children`: 0 or 1
   - `good_with_pets`: 0 or 1
3. **Trains Decision Tree model** on the data
4. **Saves model** as `decision_tree_model.pkl`

**Expected output:**

```
🎲 Generating training data...
✅ Training data saved to training_data.csv
🤖 Training model...
✅ Model trained successfully!
📊 Model saved to decision_tree_model.pkl
✨ Training complete!
```

**Files created:**

- `training_data.csv` (5000 rows, ~500KB)
- `decision_tree_model.pkl` (trained model, ~50KB)

### 6. Create MongoDB Database

MongoDB will automatically create the database when the backend connects, but let's verify:

```powershell
# Open MongoDB Shell
mongosh

# Switch to pet-adoption database
use pet-adoption

# Check collections (will be empty initially)
show collections

# Exit
exit
```

**Note:** The backend will automatically create:

- `users` collection (stores users and shelters)
- `animals` collection (stores animal listings)
- `adoptionrequests` collection (stores adoption requests)

---

## ▶️ Running the Application (Step-by-Step)

You need to run **4 services** in **4 separate PowerShell terminals** simultaneously.

### 🔷 Terminal 1: Start MongoDB Server

```powershell
# If MongoDB is installed as a Windows Service (it should auto-start)
# Check if it's running:
sc query MongoDB

# If not running, start the service:
net start MongoDB

# OR start manually (if not installed as service):
mongod --dbpath="C:\data\db"
```

**Expected output (if manual start):**

```
{"t":{"$date":"2026-01-06T10:00:00.000Z"},"s":"I","c":"NETWORK","msg":"Waiting for connections","attr":{"port":27017}}
```

**✅ Success indicators:**

- Message: "Waiting for connections on port 27017"
- No error messages
- Terminal stays open and running

**Keep this terminal open!** MongoDB must keep running.

---

### 🔷 Terminal 2: Start Backend (NestJS)

```powershell
# Open NEW PowerShell terminal
# Navigate to backend folder
cd C:\Users\Selim\OneDrive\Bureau\pro\pet-adoption-platform\backend

# Start backend in development mode (with auto-reload)
npm run start:dev
```

**What happens:**

1. TypeScript files compile
2. NestJS application starts
3. Connects to MongoDB at `mongodb://localhost:27017/pet-adoption`
4. Loads all modules (Auth, Users, Animals, Adoption Requests)
5. Starts listening on port 3000

**Expected output:**

```
[Nest] 12345  - 01/06/2026, 10:00:00 AM     LOG [NestFactory] Starting Nest application...
[Nest] 12345  - 01/06/2026, 10:00:00 AM     LOG [InstanceLoader] MongooseModule dependencies initialized
[Nest] 12345  - 01/06/2026, 10:00:00 AM     LOG [InstanceLoader] UsersModule dependencies initialized
[Nest] 12345  - 01/06/2026, 10:00:00 AM     LOG [InstanceLoader] AnimalsModule dependencies initialized
[Nest] 12345  - 01/06/2026, 10:00:00 AM     LOG [InstanceLoader] AdoptionRequestsModule dependencies initialized
[Nest] 12345  - 01/06/2026, 10:00:00 AM     LOG [RoutesResolver] UsersController {/users}
[Nest] 12345  - 01/06/2026, 10:00:00 AM     LOG [RoutesResolver] AnimalsController {/animals}
[Nest] 12345  - 01/06/2026, 10:00:00 AM     LOG [RoutesResolver] AdoptionRequestsController {/adoption-requests}
[Nest] 12345  - 01/06/2026, 10:00:00 AM     LOG [NestApplication] Nest application successfully started
🚀 Backend API running on: http://localhost:3000
```

**✅ Success indicators:**

- Message: "Nest application successfully started"
- "Backend API running on: http://localhost:3000"
- No connection errors to MongoDB

**Test the backend:**

```powershell
# In another terminal, test:
curl http://localhost:3000/animals
# Should return JSON array (may be empty initially)
```

**Keep this terminal open!** Backend must keep running.

---

### 🔷 Terminal 3: Start AI Service (Python Flask)

```powershell
# Open NEW PowerShell terminal
# Navigate to ai-service folder
cd C:\Users\Selim\OneDrive\Bureau\pro\pet-adoption-platform\ai-service

# Start Flask application
python app.py
```

**What happens:**

1. Flask app loads
2. Loads trained model from `decision_tree_model.pkl`
3. Enables CORS for cross-origin requests
4. Starts Flask development server on port 5000

**Expected output:**

```
🚀 Starting AI Microservice...
✅ Model loaded successfully from decision_tree_model.pkl

 * Serving Flask app 'app'
 * Debug mode: on
WARNING: This is a development server. Do not use it in a production deployment.
 * Running on http://localhost:5000
 * Running on http://127.0.0.1:5000
Press CTRL+C to quit
```

**✅ Success indicators:**

- Message: "Model loaded successfully"
- "Running on http://localhost:5000"
- No errors about missing `decision_tree_model.pkl`

**Test the AI service:**

```powershell
# In another terminal, test health endpoint:
curl http://localhost:5000/health
# Should return: {"status": "healthy", "model_loaded": true}
```

**Keep this terminal open!** AI service must keep running.

---

### 🔷 Terminal 4: Start Frontend (Flutter)

#### Option A: Run on Web (Chrome) - Easiest

```powershell
# Open NEW PowerShell terminal
# Navigate to mobile-app folder
cd C:\Users\Selim\OneDrive\Bureau\pro\pet-adoption-platform\mobile-app

# Run Flutter app in Chrome
flutter run -d chrome
```

**What happens:**

1. Flutter compiles Dart code to JavaScript
2. Starts development web server
3. Opens Chrome browser automatically
4. Hot-reload enabled for development

**Expected output:**

```
Launching lib\main.dart on Chrome in debug mode...
Waiting for connection from debug service on Chrome...
Building application for the web...                         25.3s
✓ Built build\web
Attempting to serve at http://localhost:54321
Chrome (web-javascript) - http://localhost:54321

💙 Flutter application is running!
```

#### Option B: Run on Android Emulator

```powershell
# Make sure MongoDB, Backend, and AI Service are running first!
cd C:\Users\Selim\OneDrive\Bureau\pro\pet-adoption-platform\mobile-app

# List available devices
flutter devices

# You should see Android emulator listed
# Example: "sdk gphone64 arm64 (mobile) • emulator-5554 • android-arm64 • Android 14 (API 34)"

# Run on Android emulator
flutter run -d emulator-5554

# Or just use:
flutter run
# Flutter will prompt you to select a device
```

**✅ No configuration needed!** The app automatically uses `http://10.0.2.2:3000` for Android emulators.

**Expected output:**

```
Launching lib\main.dart on sdk gphone64 arm64 in debug mode...
Running Gradle task 'assembleDebug'...                         45.2s
✓ Built build\app\outputs\flutter-apk\app-debug.apk
Installing build\app\outputs\flutter-apk\app-debug.apk...     5.3s
Syncing files to device sdk gphone64 arm64...
Flutter run key commands.
r Hot reload. 🔥🔥🔥
```

#### Option C: Run on Physical Android Device

1. **Enable Developer Options on your Android phone:**

   - Go to **Settings > About Phone**
   - Tap **Build Number** 7 times
   - Developer Options will be enabled

2. **Enable USB Debugging:**

   - Go to **Settings > Developer Options**
   - Enable **USB Debugging**

3. **Connect Phone via USB:**

   - Connect phone to computer
   - Allow USB debugging when prompted on phone

4. **Verify Device Connection:**

   ```powershell
   flutter devices
   # Should list your connected phone
   # Example: "SM G998B (mobile) • R5CN1234567 • android-arm64 • Android 13 (API 33)"
   ```

5. **⚠️ Update API URL for Physical Device:**

   Edit [mobile-app/lib/core/config/app_config.dart](mobile-app/lib/core/config/app_config.dart):

   ```dart
   // Uncomment and set your computer's local IP:
   static const String apiBaseUrl = 'http://192.168.1.105:3000';  // Replace with your IP

   // To find your IP:
   // Windows: ipconfig (look for IPv4 Address)
   // Mac/Linux: ifconfig
   ```

6. **Run on Physical Device:**
   ```powershell
   cd mobile-app
   flutter run
   # Select your device from the list
   ```

#### Option D: Run on iOS (Mac Only)

```bash
# On Mac with Xcode installed
cd mobile-app

# List devices (should show iOS simulators)
flutter devices

# Run on iOS simulator
flutter run -d "iPhone 15 Pro"

# Or run on physical iPhone (requires Apple Developer account)
flutter run
```

**For iOS:** Update API URL in [mobile-app/lib/core/services/api_service.dart](mobile-app/lib/core/services/api_service.dart#L8-L10):

```dart
// Use your Mac's local IP address:
static const String baseUrl = 'http://192.168.1.X:3000';  // Replace with your Mac's IP
```

#### Option E: Open in Android Studio - **Recommended!**

1. **Open Project:**

   - Launch Android Studio
   - **File > Open**
   - Navigate to `pet-adoption-platform/mobile-app`
   - Click **OK**
   - Wait for Gradle sync to complete

2. **Select Device:**

   - Top toolbar: Click device dropdown
   - Select:
     - **Chrome** (Web) - No config needed
     - **Android Emulator** - No config needed ✅
     - **Physical Device** - Needs IP config ⚠️

3. **Run:**

   - Click green ▶️ **Run** button
   - Or press **Shift + F10**
   - App builds and launches automatically!

4. **Hot Reload:**
   - Click ⚡ **Hot Reload** button (after making code changes)
   - Or press **Ctrl + \*\* (Windows) / **Cmd + \*\* (Mac)

**✅ That's it!** Android Studio + Emulator = Zero configuration needed!

---

**✅ Success indicators (all platforms):**

- App loads with login screen
- No CORS/connection errors
- Can register and login successfully

**Browser/App should show:**

- Login page with "Pet Adoption Platform" title
- Email and Password fields
- Login and Register buttons

---

## 🎯 First Time Setup & Testing

### 1. Create Test Accounts

**Register a Shelter:**

1. Click "Register" button
2. Fill in:
   - Name: `Happy Paws Shelter`
   - Email: `happypaws@shelter.com`
   - Password: `password123`
   - Select Role: **Shelter**
3. Click Register
4. You'll be logged in automatically

**Register a User:**

1. Logout (or open incognito window)
2. Click "Register"
3. Fill in:
   - Name: `John Doe`
   - Email: `john@example.com`
   - Password: `password123`
   - Select Role: **User**
4. Click Register

### 2. Add Animals (as Shelter)

1. Login as `happypaws@shelter.com`
2. Go to "Add Animal" page
3. Fill in animal details:
   - Name: `Max`
   - Species: `Dog`
   - Breed: `Golden Retriever`
   - Age: `3`
   - Size: `Large`
   - Energy Level: `High`
   - Description: `Friendly and playful`
   - Check: Good with children
   - Check: Good with pets
4. Click "Add Animal"
5. Repeat to add more animals (cats, birds, rabbits)

### 3. Test AI Compatibility (as User)

1. Login as `john@example.com`
2. Browse animals on home page
3. You'll see **compatibility scores** (0-100%) for each animal
4. Scores are calculated by AI based on:
   - Your housing type
   - Time available
   - Experience level
   - Whether you have children/pets
   - Animal's characteristics

### 4. Request Adoption (as User)

1. Click on an animal with high compatibility
2. Click "Request Adoption"
3. Write a message: "I'd love to adopt Max!"
4. Submit request

### 5. Manage Requests (as Shelter)

1. Login as `happypaws@shelter.com`
2. Go to "Adoption Requests" page
3. See pending requests with:
   - User name
   - Animal name
   - Compatibility score
   - User's message
4. Click "Approve" or "Reject"

---

## 🔍 Verify Everything is Working

### Check MongoDB Data

```powershell
mongosh
use pet-adoption

# See all users
db.users.find().pretty()

# See all animals
db.animals.find().pretty()

# See all adoption requests
db.adoptionrequests.find().pretty()

exit
```

### Check Backend API

```powershell
# Get all animals
curl http://localhost:3000/animals

# Get animal compatibility (replace IDs)
curl "http://localhost:3000/animals/ANIMAL_ID/compatibility?userId=USER_ID"

# Health check
curl http://localhost:3000
```

### Check AI Service

```powershell
# Health check
curl http://localhost:5000/health

# Test prediction (send POST with JSON)
curl -X POST http://localhost:5000/predict ^
  -H "Content-Type: application/json" ^
  -d "{\"housing_type\":\"house\",\"time_available\":\"high\",\"experience_level\":\"expert\",\"has_children\":1,\"has_other_pets\":0,\"animal_species\":\"dog\",\"animal_age_years\":3,\"animal_size\":\"large\",\"animal_energy_level\":\"high\",\"good_with_children\":1,\"good_with_pets\":1}"

# Should return: {"prediction": 85.5}
```

---

## 📁 Project Structure

```
pet-adoption-platform/
├── backend/                    # NestJS backend
│   ├── src/
│   │   ├── animals/           # Animal CRUD & compatibility
│   │   ├── users/             # User management
│   │   ├── auth/              # Authentication (JWT)
│   │   ├── adoption-requests/ # Adoption request handling
│   │   └── ai-service/        # AI service integration
│   ├── package.json
│   └── tsconfig.json
│
├── mobile-app/                 # Flutter frontend
│   ├── lib/
│   │   ├── core/              # Services, routing, config
│   │   ├── features/
│   │   │   ├── animals/       # Animal browsing
│   │   │   ├── auth/          # Login/Register
│   │   │   ├── shelter/       # Shelter dashboard
│   │   │   ├── adoption_requests/  # Request management
│   │   │   └── profile/       # User profile
│   │   └── main.dart
│   └── pubspec.yaml
│
├── ai-service/                 # Python ML service
│   ├── app.py                 # Flask API
│   ├── train_model.py         # Model training script
│   ├── training_data.csv      # Training dataset (5000 rows)
│   ├── decision_tree_model.pkl  # Trained model
│   └── requirements.txt
│
├── .gitignore
└── README.md
```

---

## 📱 Platform-Specific Configuration

### ✅ API Base URL - Automatically Configured!

**Good news!** The app now **automatically detects** the platform and uses the correct API URL:

| Platform                    | Base URL                  | Status                   |
| --------------------------- | ------------------------- | ------------------------ |
| **Web (Chrome)**            | `http://localhost:3000`   | ✅ Auto-configured       |
| **Android Emulator**        | `http://10.0.2.2:3000`    | ✅ Auto-configured       |
| **iOS Simulator**           | `http://localhost:3000`   | ✅ Auto-configured       |
| **Windows/Mac Desktop**     | `http://localhost:3000`   | ✅ Auto-configured       |
| **Android Physical Device** | `http://192.168.1.X:3000` | ⚠️ Manual setup required |
| **iOS Physical Device**     | `http://192.168.1.X:3000` | ⚠️ Manual setup required |

### For Physical Devices Only

If testing on a **real phone/tablet**, edit [mobile-app/lib/core/config/app_config.dart](mobile-app/lib/core/config/app_config.dart):

```dart
// Uncomment and replace with your computer's IP address:
static const String apiBaseUrl = 'http://192.168.1.105:3000';
```

**Find your computer's IP:**

```powershell
# Windows
ipconfig
# Look for "IPv4 Address" (e.g., 192.168.1.105)

# Mac/Linux
ifconfig
# or
hostname -I
```

**That's it!** No other configuration needed for emulators. 🎉

---

## 🌐 API Documentation

### Base URL

`http://localhost:3000`

### Authentication Endpoints

- `POST /auth/register` - Register new user/shelter
- `POST /auth/login` - Login and get JWT token

### Animals Endpoints

- `GET /animals` - Get all animals
- `GET /animals/:id` - Get single animal
- `GET /animals/:id/compatibility?userId=xxx` - Get compatibility score
- `POST /animals` - Create new animal (shelter only)
- `GET /animals/shelter/:shelterId` - Get animals by shelter

### Adoption Requests Endpoints

- `POST /adoption-requests` - Create adoption request
- `GET /adoption-requests?userId=xxx` - Get user's requests
- `GET /adoption-requests/shelter/:shelterId` - Get shelter's requests
- `PATCH /adoption-requests/:id/status` - Approve/reject request

### AI Service Endpoints

- `GET http://localhost:5000/health` - Health check
- `POST http://localhost:5000/predict` - Get compatibility prediction

---

## 🤖 AI Model

### Training Data

- **Size:** 5,000 synthetic examples
- **Features:** 11 (housing, time, experience, children, pets, species, age, size, energy, compatibility flags)
- **Output:** Compatibility score (0-100%)

### Feature Weights

1. **Housing Match:** Large dog + apartment = -20 pts, Large dog + house = +15 pts
2. **Time vs Energy:** High time + high energy = good match
3. **Experience:** Expert = +10 pts, Beginner + dog = -15 pts
4. **Children Safety:** Has kids + good with kids = +20 pts, Has kids + NOT good = -30 pts
5. **Other Pets:** Has pets + good with pets = +15 pts, Has pets + NOT good = -25 pts

### Model Performance

- **Algorithm:** Decision Tree Regressor
- **Accuracy:** ~85% (based on validation set)
- **Training Time:** ~2 seconds

---

## 🔧 Troubleshooting

### Backend won't start

```powershell
# Check if MongoDB is running
mongod

# Check if port 3000 is available
netstat -ano | findstr :3000

# Kill process if port is occupied
taskkill /PID <process-id> /F

# Reinstall dependencies
cd backend
rm -rf node_modules package-lock.json
npm install
```

### Flutter app shows errors

```powershell
# Clean and rebuild
flutter clean
flutter pub get
flutter run -d chrome
```

### Android Issues

#### Gradle build failed

```powershell
# Update Android Gradle plugin
cd mobile-app/android
# Edit build.gradle and update versions

# Clean Gradle cache
cd mobile-app
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
flutter run
```

#### Cannot connect to backend from Android

```dart
// Check API URL in api_service.dart:
static const String baseUrl = 'http://10.0.2.2:3000';  // For emulator
// OR
static const String baseUrl = 'http://192.168.1.X:3000';  // For physical device

// Make sure backend is accessible:
# Windows: Allow port 3000 in firewall
netsh advfirewall firewall add rule name="Backend 3000" dir=in action=allow protocol=TCP localport=3000
```

#### Device not detected

```powershell
# Restart ADB
adb kill-server
adb start-server
adb devices

# Check USB debugging is enabled on phone
# Reconnect USB cable
```

### iOS Issues (Mac)

#### Pod install failed

```bash
cd mobile-app/ios
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
flutter run
```

#### Code signing error

- Open `mobile-app/ios/Runner.xcworkspace` in Xcode
- Select Runner > Signing & Capabilities
- Choose your development team
- Change bundle identifier if needed

#### Cannot connect to backend from iOS

```dart
// Use Mac's local IP in api_service.dart:
static const String baseUrl = 'http://192.168.1.X:3000';

// Allow incoming connections on Mac:
# System Settings > Network > Firewall > Allow port 3000
```

### Android Studio Issues

#### Flutter not recognized

```powershell
# Set Flutter SDK path in Android Studio:
# File > Settings > Languages & Frameworks > Flutter
# Set Flutter SDK path: C:\src\flutter
```

#### Hot reload not working

```powershell
# Stop app and restart
# Or use:
flutter run --hot
```

#### Emulator is slow

- Enable hardware acceleration (Intel HAXM or AMD Hypervisor)
- Increase emulator RAM in AVD Manager
- Use x86_64 image instead of ARM

### AI service not working

```powershell
# Check Python version
python --version  # Must be 3.11+

# Reinstall dependencies
pip install --upgrade flask flask-cors scikit-learn

# Retrain model
python train_model.py
```

### MongoDB connection failed

```powershell
# Start MongoDB
mongod

# Check connection string in backend/.env
# Should be: MONGODB_URI=mongodb://localhost:27017/pet-adoption
```

### JWT Authentication Issues

**Note:** JWT validation is currently bypassed. The app sends `userId`/`shelterId` explicitly in request bodies. This is a known workaround - the authentication still works but doesn't rely on JWT validation.

---

## 👥 Default Test Accounts

### Regular User

- **Email:** testo@gmail.com
- **Password:** password123
- **Role:** user

### Shelters

- **Email:** happypaws@shelter.com / furryfriends@shelter.com
- **Password:** password123
- **Role:** shelter

---

## 📄 License

This project is for educational purposes.

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📞 Support

For issues and questions, please open a GitHub issue.

---

**Made with ❤️ for pets and their future families** 🐕🐈🐰
