import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class GoogleAuthKeys {
  static const String _clientId = String.fromEnvironment('GOOGLE_CLIENT_ID');
  static const String _clientSecret = String.fromEnvironment(
    'GOOGLE_CLIENT_SECRET',
  );

  static String get clientId {
    return kReleaseMode ? _clientId : (dotenv.env['GOOGLE_CLIENT_ID'] ?? '');
  }

  static String get clientSecret {
    return kReleaseMode
        ? _clientSecret
        : (dotenv.env['GOOGLE_CLIENT_SECRET'] ?? '');
  }
}
