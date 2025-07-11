class AppConstants {
  /// Size of the canvas in the Simulation Screen
  static const double canvasSize = 100_000.0;

  /// Width of Device Drawer
  static const double deviceDrawerWidth = 200.0;

  /// Animation Duration like opening a drawer
  static const int animationSpeed = 300; // in mili-seconds

  /// Size of Device in the Canvas
  static const double deviceSize = 100.0;
}

enum SimObjectType { router, switch_, host, connection }

extension SimObjectTypeX on SimObjectType {
  String get label {
    switch (this) {
      case SimObjectType.router:
        return 'Router';
      case SimObjectType.switch_:
        return 'Switch';
      case SimObjectType.host:
        return 'Host';
      case SimObjectType.connection:
        return 'Connection';
    }
  }
}
