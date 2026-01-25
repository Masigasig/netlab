import 'package:flutter_dotenv/flutter_dotenv.dart';

class GoogleAuthKeys {
  static const String _clientId = String.fromEnvironment(
    'GOOGLE_CLIENT_ID',
    defaultValue: '',
  );
  static const String _clientSecret = String.fromEnvironment(
    'GOOGLE_CLIENT_SECRET',
    defaultValue: '',
  );

  static String get clientId => _getEnvOrConst('GOOGLE_CLIENT_ID', _clientId);
  static String get clientSecret =>
      _getEnvOrConst('GOOGLE_CLIENT_SECRET', _clientSecret);

  static String _getEnvOrConst(String key, String constValue) {
    try {
      final envValue = dotenv.env[key];
      if (envValue != null && envValue.isNotEmpty) {
        return envValue;
      }
    } catch (_) {
      // dotenv not loaded, use const value
    }
    return constValue;
  }
}
