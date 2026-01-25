import 'package:flutter_dotenv/flutter_dotenv.dart';

class GoogleAuthKeys {
  static String get clientId =>
      dotenv.maybeGet('GOOGLE_CLIENT_ID') ??
      const String.fromEnvironment('GOOGLE_CLIENT_ID', defaultValue: '');
  static String get clientSecret =>
      dotenv.maybeGet('GOOGLE_CLIENT_SECRET') ??
      const String.fromEnvironment('GOOGLE_CLIENT_SECRET', defaultValue: '');
}
