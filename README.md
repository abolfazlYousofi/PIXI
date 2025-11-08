# Pixi

Pixi is a Flutter mobile application that provides user authentication through multiple methods including email/password, Google Sign-In, and phone number verification.

## Features

- Multiple authentication methods:
  - Email/Password authentication
  - Google Sign-In
  - Phone number verification (OTP)
- Multi-language support (English, French, Persian)
- Material Design 3 with dynamic color theming
- Firebase backend integration

## Prerequisites

Before you begin, ensure you have met the following requirements:
* Flutter SDK (latest stable version)
* Firebase account and project set up
* Android Studio / Xcode for mobile development

## Getting Started

1. Clone the repository
```bash
git clone https://github.com/abolfazlYousofi/PIXI.git
cd PIXI
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure Firebase
- Create a new Firebase project in the [Firebase Console](https://console.firebase.google.com/)
- Run the following command to configure Firebase for your project:
```bash
flutterfire configure
```

4. Run the app
```bash
flutter run
```

## Configuration

To use this app, you need to:

1. Set up Firebase Authentication in the Firebase Console
2. Enable the authentication providers you want to use (Email/Password, Google, Phone)
3. Add your Android app to Firebase and download the `google-services.json`
4. Add your iOS app to Firebase and download the `GoogleService-Info.plist`

## Project Structure

```
lib/
  ├── screens/          # UI screens
  ├── services/         # Business logic and services
  ├── utils/           # Utility functions and constants
  └── main.dart        # App entry point
```

## Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details

## Contact

Your Name - [@your_twitter](https://twitter.com/your_twitter)

Project Link: [https://github.com/abolfazlYousofi/PIXI](https://github.com/abolfazlYousofi/PIXI)
