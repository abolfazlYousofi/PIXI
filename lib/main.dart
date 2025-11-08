import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/phone_auth_screen.dart';
import 'firebase_options.dart'; // ← این فایل باید با flutterfire configure تولید شود

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const PixiApp());
}

class PixiApp extends StatelessWidget {
  const PixiApp({super.key});

  // Supported locales: fa, en, fr. otherwise default to en
  Locale _resolveLocale(Locale? deviceLocale) {
    if (deviceLocale == null) return const Locale('en');
    final code = deviceLocale.languageCode;
    if (code == 'fa' || code == 'en' || code == 'fr') {
      return Locale(code);
    }
    return const Locale('en');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF7B2FF7),
      ),
      supportedLocales: const [Locale('en'), Locale('fa'), Locale('fr')],
      localeResolutionCallback: (deviceLocale, supportedLocales) =>
          _resolveLocale(deviceLocale),
      initialRoute: '/',
      routes: {
        '/': (ctx) => const OnboardingScreen(),
        '/login': (ctx) => const LoginScreen(),
        '/home': (ctx) => const HomeScreen(),
        '/phone-auth': (ctx) => const PhoneAuthScreen(),
      },
    );
  }
}
