import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class GoogleAuthKeys {
  static String get clientId {
    if (kReleaseMode) {
      return const String.fromEnvironment('GOOGLE_CLIENT_ID', defaultValue: '');
    }

    return dotenv.env['GOOGLE_CLIENT_ID'] ?? '';
  }

  static String get clientSecret {
    if (kReleaseMode) {
      return const String.fromEnvironment(
        'GOOGLE_CLIENT_SECRET',
        defaultValue: '',
      );
    }
    return dotenv.env['GOOGLE_CLIENT_SECRET'] ?? '';
  }
}
