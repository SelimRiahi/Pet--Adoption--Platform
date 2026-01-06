import 'dart:io';
import 'package:flutter/foundation.dart';

class AppConfig {
  // Automatically detect the correct API URL based on platform
  static String get apiBaseUrl {
    if (kIsWeb) {
      // Web runs on same machine
      return 'http://localhost:3000';
    } else if (Platform.isAndroid) {
      // Android emulator uses special IP to reach host machine
      return 'http://10.0.2.2:3000';
    } else if (Platform.isIOS) {
      // iOS simulator can use localhost
      return 'http://localhost:3000';
    } else {
      // Desktop (Windows, macOS, Linux)
      return 'http://localhost:3000';
    }
  }

  // For physical devices, uncomment and set your computer's local IP:
  // static const String apiBaseUrl = 'http://192.168.1.105:3000';

  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration cacheValidDuration = Duration(minutes: 5);
}
