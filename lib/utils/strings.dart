import 'package:flutter/widgets.dart';

String t(BuildContext ctx, String key) {
  final locale = Localizations.localeOf(ctx).languageCode;
  final map = <String, Map<String, String>>{
    'welcomeTitle': {
      'en': 'Welcome to Pixi',
      'fa': 'به Pixi خوش آمدید',
      'fr': 'Bienvenue sur Pixi',
    },
    'welcomeDesc': {
      'en': 'Enhance your photos with AI in one tap.',
      'fa': 'عکس‌هات رو با یک لمس بهبود بده.',
      'fr': "Améliorez vos photos en un clic.",
    },
    'next': {'en': 'Next', 'fa': 'بعدی', 'fr': 'Suivant'},
    'start': {'en': 'Get Started', 'fa': 'شروع کنید', 'fr': 'Commencer'},
    'loginWithGoogle': {
      'en': 'Sign in with Google',
      'fa': 'ورود با گوگل',
      'fr': 'Google',
    },
    'loginWithFacebook': {
      'en': 'Sign in with Facebook',
      'fa': 'ورود با فیسبوک',
      'fr': 'Facebook',
    },
  };
  return map[key]?[locale] ?? map[key]?['en'] ?? key;
}
