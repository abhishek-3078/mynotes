# Project Name

This Flutter project utilizes Firebase for backend services. Follow the instructions below to set up Firebase configuration files for Android, iOS, and the custom `firebase_app_id_file.json`.

## Firebase Configuration

### 1. Create a Firebase Project

- Visit the [Firebase Console](https://console.firebase.google.com/).
- Click on "Add Project" to create a new project or select an existing project.

### 2. Enable Firebase Services

- In the Firebase Console, navigate to your project.
- Enable the Firebase services that your project requires (e.g., Realtime Database, Firestore, Authentication).

### 3. Add an App to Your Project

- In the Firebase Console, go to Project Settings.
- In the "General" tab, scroll down to the "Your apps" section.
- Click on the platform you're targeting (iOS or Android) and follow the setup instructions.

### 4. Retrieve API Key

- Once you've added the app, find the API key in the "Your apps" section under the appropriate platform.
  - For Android, it's the "Web API Key."
  - For iOS, it's in the `GoogleService-Info.plist` file.

### 5. Generate Firebase Configuration Files

#### For Android:

- Download the `google-services.json` file from the Firebase Console.
- Place the downloaded file in the `android/app/` directory of your Flutter project.

#### For iOS:

- Download the `GoogleService-Info.plist` file from the Firebase Console.
- Place the downloaded file in the `ios/Runner/` directory of your Flutter project.

Or use Firebase CLI.
