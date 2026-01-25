import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GoogleAuthKeys {
  static final String clientId =
      dotenv.env['GOOGLE_CLIENT_ID'] ??
      Platform.environment['GOOGLE_CLIENT_ID'] ??
      '';
  static final String clientSecret =
      dotenv.env['GOOGLE_CLIENT_SECRET'] ??
      Platform.environment['GOOGLE_CLIENT_SECRET'] ??
      '';
}
