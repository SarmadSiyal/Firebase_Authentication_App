# Firebase_Authentication_App

A clean and professional Flutter app integrated with Firebase Authentication using email and password. Designed to demonstrate secure sign-up, login, password reset, and smooth user experience with real-time validation, error handling, and modern UI features.

# Features
- Email & Password Sign Up
- Email & Password Login
- Sign Out
- Forgot Password via Email
- Show/Hide Password Toggle
- Real-time Field Validation
- Friendly Error Messages (Network, Wrong Input, etc.)
- Auto-Clear Fields After Success
- Fully Responsive UI with Gradient Background

# Dependencies
- firebase_core: ^2.30.0
- firebase_auth: ^4.17.0
  
# Folder Structure
## lib/
- main.dart
├── login_screen.dart
├── signup_screen.dart
├── forgot_password_screen.dart
├── home_screen.dart
├── custom_textfield.dart


# Firebase Setup 
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project
3. Register Android app (use your actual `applicationId`)
4. Download `google-services.json` and place it in:
