import 'package:flutter/foundation.dart';

bool isMobileWeb() {
  if (!kIsWeb) return false;

  return defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.android;
}
