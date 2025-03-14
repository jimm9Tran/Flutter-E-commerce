import 'package:flutter/material.dart';

class Cache {
  Cache._internal();

  static final Cache instance = Cache._internal();

  String? _sesstionToken;
  String? _userId;
  final themeModeNotifier = ValueNotifier(ThemeMode.system);

  String? get sessionToken => _sesstionToken;
  String? get userId => _userId;

  void setSesstionToken(String? newToken) {
    if (_sesstionToken != newToken) {
      _sesstionToken = newToken;
    }
  }

  void setUserId(String? newUserId) {
    if (_userId != newUserId) {
      _userId = newUserId;
    }
  }

  void setThemeMode(ThemeMode themeMode) {
    if (themeModeNotifier.value != themeMode) {
      themeModeNotifier.value = themeMode;
    }
  }

  void resetSesstion() {
    setSesstionToken(null);
    setUserId(null);
  }
}

// void main() {
//   final cache = Cache._internal();
// }
