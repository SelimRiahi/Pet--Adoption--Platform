# Quick script to run Android app
Write-Host "🤖 Building and Installing Android App..." -ForegroundColor Cyan
Write-Host ""
Write-Host "Make sure you have:" -ForegroundColor Yellow
Write-Host "  1. Android Studio installed" -ForegroundColor Yellow
Write-Host "  2. An emulator running OR device connected" -ForegroundColor Yellow
Write-Host ""

cd android-app

# Check if gradlew exists
if (Test-Path ".\gradlew.bat") {
    Write-Host "Building APK..." -ForegroundColor Green
    .\gradlew.bat assembleDebug
    
    Write-Host ""
    Write-Host "Installing to device..." -ForegroundColor Green
    .\gradlew.bat installDebug
    
    Write-Host ""
    Write-Host "✅ App installed! Launch 'Pet Adoption' from device." -ForegroundColor Green
} else {
    Write-Host "❌ Gradle wrapper not found. Please use Android Studio instead." -ForegroundColor Red
    Write-Host ""
    Write-Host "Steps:" -ForegroundColor Yellow
    Write-Host "  1. Open Android Studio" -ForegroundColor Yellow
    Write-Host "  2. File → Open → android-app folder" -ForegroundColor Yellow
    Write-Host "  3. Wait for Gradle sync" -ForegroundColor Yellow
    Write-Host "  4. Click Run ▶️" -ForegroundColor Yellow
}

Read-Host "Press Enter to close"
