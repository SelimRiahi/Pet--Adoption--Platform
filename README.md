# 🐾 Pet Adoption Platform

A full-stack pet adoption application with AI-powered compatibility matching between adopters and animals. Built with NestJS, MongoDB, Python ML, and native Android/iOS apps.

## 📱 Features

### For Adopters (Users)

- 🔍 Browse available animals with detailed profiles
- 🤖 **AI Compatibility Scores** - Personalized match percentages based on your lifestyle
- 💝 Submit adoption requests instantly
- 📊 Track request status (pending/approved/rejected)
- 👤 Profile management with lifestyle preferences
- ❤️ Personalized recommendations

### For Shelters

- ➕ Add animals to the platform
- 📋 View adoption requests for your animals
- ✅ Approve/reject requests
- 🏠 Dashboard with real-time AI compatibility scores
- 📊 See which adopters are best matches

### AI Features

- **Machine Learning Model** - Decision Tree Regressor trained on 5000 samples
- **11 Features** - Housing type, yard space, experience level, time available, children, other pets, age preference, etc.
- **Real-time Predictions** - Instant compatibility calculations
- **R² Score: 0.82** - Highly accurate predictions

---

## 🛠 Tech Stack

| Component       | Technologies                                              |
| --------------- | --------------------------------------------------------- |
| **Backend**     | NestJS, TypeScript, MongoDB, Mongoose, JWT Auth           |
| **AI Service**  | Python, Flask, scikit-learn, pandas, numpy                |
| **Android App** | Kotlin, Jetpack Compose, Material 3, Retrofit, Coroutines |
| **iOS App**     | Swift, SwiftUI, URLSession, async/await                   |

---

## 📦 Prerequisites

Before starting, ensure you have installed:

- **Node.js** v18+ ([Download](https://nodejs.org/))
- **MongoDB** v6+ ([Download](https://www.mongodb.com/try/download/community))
- **Python** v3.9+ ([Download](https://www.python.org/downloads/))
- **Android Studio** (for Android app) ([Download](https://developer.android.com/studio))
- **Xcode** (for iOS app, macOS only) ([Download](https://apps.apple.com/app/xcode/id497799835))

---

## 🚀 Quick Start

### 1️⃣ Clone the Repository

```bash
git clone <your-repo-url>
cd pet-adoption-platform
```

### 2️⃣ Start MongoDB

**Windows:**

```bash
mongod
```

**macOS/Linux:**

```bash
sudo systemctl start mongod
# or
brew services start mongodb-community
```

### 3️⃣ Backend Setup

```bash
cd backend
npm install
npm run start:dev
```

Backend will run on **http://localhost:3000**

### 4️⃣ AI Service Setup

```bash
cd ai-service
python -m venv venv
# Windows:
venv\Scripts\activate
# macOS/Linux:
source venv/bin/activate

pip install -r requirements.txt
python train_model.py    # Train the ML model (takes ~3 seconds)
python app.py            # Start Flask server
```

AI Service will run on **http://localhost:5000**

### 5️⃣ Android App Setup

1. Open **Android Studio**
2. Open the `android-app` folder
3. Wait for Gradle sync to complete
4. Update API URL if needed in `ApiClient.kt`:
   ```kotlin
   private const val BASE_URL = "http://10.0.2.2:3000/" // Android emulator
   // Use "http://YOUR_IP:3000/" for physical device
   ```
5. Run on emulator or device

### 6️⃣ iOS App Setup (macOS only)

1. Open **Xcode**
2. Open `ios-app/PetAdoption.xcodeproj`
3. Update API URL in `ApiService.swift` if needed:
   ```swift
   private let baseURL = "http://localhost:3000"
   // Use your Mac's IP for physical device
   ```
4. Run on simulator or device

---

## 📁 Project Structure

```
pet-adoption-platform/
├── backend/              # NestJS REST API
│   ├── src/
│   │   ├── auth/         # JWT authentication
│   │   ├── users/        # User management
│   │   ├── animals/      # Animal CRUD + compatibility
│   │   ├── adoption-requests/  # Request management
│   │   └── ai-service/   # AI service integration
│   └── package.json
│
├── ai-service/           # Python Flask ML API
│   ├── app.py           # Flask server
│   ├── train_model.py   # Model training script
│   ├── training_data.csv # Synthetic training data
│   └── requirements.txt
│
├── android-app/          # Native Android Kotlin app
│   ├── app/src/main/java/com/petadoption/app/
│   │   ├── ui/screens/  # Compose UI screens
│   │   ├── data/        # Models, API client
│   │   └── ui/navigation/
│   └── build.gradle
│
└── ios-app/              # Native iOS Swift app
    ├── PetAdoption/
    │   ├── Views/       # SwiftUI views
    │   ├── Models/      # Data models
    │   └── Services/    # API service
    └── PetAdoption.xcodeproj
```

---

## 🔐 Authentication

The platform uses **JWT (JSON Web Tokens)** for authentication:

1. **Register** a new account (user or shelter)
2. **Login** to receive a JWT token
3. Token is automatically included in all requests
4. Token expires after 7 days

### Test Accounts (After Seed)

You can seed the database with test data:

```bash
cd backend
npm run seed
```

Default accounts:

- **User:** `john@example.com` / `password123`
- **Shelter:** `shelter@example.com` / `password123`

---

## 🤖 AI Model Details

### Training Process

```bash
cd ai-service
python train_model.py
```

**What it does:**

1. Generates 5000 synthetic user-animal pairs
2. Calculates compatibility scores using rule-based logic
3. Trains a Decision Tree Regressor
4. Saves model as `decision_tree_model.pkl`
5. Outputs metrics: R² score, MSE

### Compatibility Scoring Rules

The AI considers:

- **Housing Match** (apartment vs house, yard space)
- **Energy Level** (high energy pet + low available time = penalty)
- **Experience Level** (beginner + high-maintenance pet = penalty)
- **Children/Pets Compatibility** (deal-breakers: -40 points)
- **Age Preferences** (puppies + inexperienced = penalty)
- **Randomness** (adds realism, ±8 points variance)

Scores range from **0-100%**:

- 80-100%: Excellent match ✅
- 65-79%: Good match 👍
- 45-64%: Moderate match ⚠️
- 0-44%: Poor match ❌

---

## 🔧 Configuration

### Backend Environment Variables

Create `backend/.env`:

```env
MONGODB_URI=mongodb://localhost:27017/pet-adoption
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
PORT=3000
AI_SERVICE_URL=http://localhost:5000
```

### API Endpoints

| Endpoint                        | Method | Description                     |
| ------------------------------- | ------ | ------------------------------- |
| `/auth/register`                | POST   | Register new user               |
| `/auth/login`                   | POST   | Login and get JWT               |
| `/users/profile`                | GET    | Get user profile                |
| `/users/profile`                | PATCH  | Update profile                  |
| `/animals`                      | GET    | List all available animals      |
| `/animals`                      | POST   | Add animal (shelter only)       |
| `/animals/:id`                  | GET    | Get animal details              |
| `/animals/:id/compatibility`    | GET    | Get AI compatibility score      |
| `/adoption-requests`            | GET    | List user's requests            |
| `/adoption-requests`            | POST   | Submit adoption request         |
| `/adoption-requests/:id/status` | PATCH  | Update request status (shelter) |

---

## 🐛 Troubleshooting

### Backend won't start

- ✅ Check MongoDB is running: `mongod`
- ✅ Verify Node.js version: `node -v` (should be v18+)
- ✅ Delete `node_modules` and reinstall: `npm install`

### AI Service errors

- ✅ Check Python version: `python --version` (3.9+)
- ✅ Activate virtual environment first
- ✅ Retrain model: `python train_model.py`
- ✅ Check if `decision_tree_model.pkl` exists

### Android app can't connect

- ✅ Use `10.0.2.2:3000` for emulator
- ✅ Use your PC's IP address for physical device
- ✅ Check backend is running on port 3000
- ✅ Disable any VPN or firewall blocking connections

### iOS app can't connect

- ✅ Use `localhost:3000` for simulator
- ✅ Use your Mac's IP for physical device
- ✅ Check Info.plist allows HTTP connections (App Transport Security)

### Compatibility scores all 100%

- ✅ Restart backend to pick up new code
- ✅ Check Python terminal for prediction logs
- ✅ Verify AI service is running on port 5000
- ✅ Test AI endpoint: `curl http://localhost:5000/health`

---

## 🎯 How We Built It

### 1. Backend Development

- Created NestJS project with TypeScript
- Set up MongoDB with Mongoose schemas
- Implemented JWT authentication with guards
- Built REST API endpoints for CRUD operations
- Integrated with AI service using HTTP calls

### 2. AI Service Development

- Generated synthetic training data (5000 samples)
- Designed compatibility scoring algorithm
- Trained Decision Tree Regressor model
- Built Flask API to serve predictions
- Added detailed logging for debugging

### 3. Android App Development

- Created Kotlin project with Jetpack Compose
- Implemented MVVM architecture with ViewModels
- Built Material 3 UI components
- Used Retrofit for API calls with JWT auth
- Added navigation with Compose Navigation

### 4. iOS App Development

- Created Swift project with SwiftUI
- Implemented MVVM with ObservableObject
- Built native iOS UI components
- Used URLSession for API calls
- Added NavigationStack for routing

### 5. Integration & Testing

- Fixed JWT secret mismatches
- Handled null value serialization issues
- Debugged API connectivity problems
- Optimized AI prediction calls
- Added auto-refresh on navigation

---

## 📝 API Testing

### Using curl

**Login:**

```bash
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"john@example.com","password":"password123"}'
```

**Get Animals (with auth):**

```bash
curl http://localhost:3000/animals \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

**Check AI Compatibility:**

```bash
curl http://localhost:3000/animals/ANIMAL_ID/compatibility \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

---

## 🤝 Contributing

This project was built as a full-stack development exercise with AI integration. Feel free to:

- Report bugs
- Suggest features
- Submit pull requests
- Use it for your own learning

---

## 📄 License

MIT License - Feel free to use this project for learning or personal use.

---

## 🎓 Learning Resources

Built using:

- [NestJS Documentation](https://docs.nestjs.com/)
- [MongoDB Documentation](https://www.mongodb.com/docs/)
- [scikit-learn Documentation](https://scikit-learn.org/)
- [Jetpack Compose](https://developer.android.com/jetpack/compose)
- [SwiftUI](https://developer.apple.com/xcode/swiftui/)

---

## ✨ Key Features Implemented

✅ JWT Authentication with token refresh  
✅ Real-time AI compatibility predictions  
✅ Native mobile apps (Android + iOS)  
✅ Shelter dashboard with request management  
✅ Profile customization with lifestyle data  
✅ Null-safe JSON serialization  
✅ Auto-refresh on navigation  
✅ Material 3 / iOS native design  
✅ MVVM architecture on all platforms

---

**Built with ❤️ using NestJS, Python, Kotlin, and Swift**
