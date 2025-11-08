// Temporary placeholder for Firebase configuration.
// Replace this file by running `flutterfire configure` and committing
// the generated `lib/firebase_options.dart` with the real options.

import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // These values are placeholders and will NOT work for real Firebase
    // services. They let the app start for UI debugging. Replace them
    // with the output of `flutterfire configure`.
    return const FirebaseOptions(
      apiKey: 'FAKE_API_KEY',
      appId: '1:000:android:0000000000000000',
      messagingSenderId: '000000000000',
      projectId: 'fake-project-id',
      authDomain: '',
      storageBucket: '',
    );
  }
}
