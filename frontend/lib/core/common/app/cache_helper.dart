import 'package:flutter/material.dart';
import 'package:frontend/core/common/singletons/cache.dart';
import 'package:frontend/core/extensions/string_extensions.dart';
import 'package:frontend/core/extensions/theme_mode_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  const CacheHelper(this._prefs);
  final SharedPreferences _prefs;

  static const _sesstionTokenKey = 'user-session-token';
  static const _userIdKey = 'user-id';
  static const _themeModeKey = 'theme-mode';
  static const _firstTimerKey = 'is-user-first-timer';

  Future<bool> cacheSesstionToken(String token) async {
    try {
      final result = await _prefs.setString(_sesstionTokenKey, token);
      Cache.instance.setSesstionToken(token);
      return result;
    } catch (e) {
      return false;
    }
  }

  Future<bool> cacheUserId(String userId) async {
    try {
      final result = await _prefs.setString(_userIdKey, userId);
      Cache.instance.setUserId(userId);
      return result;
    } catch (e) {
      return false;
    }
  }

  Future<void> cacheFirstTime() async {
    await _prefs.setBool(_firstTimerKey, false);
  }

  Future<void> cacheThemeMode(ThemeMode themeMode) async {
    await _prefs.setString(_themeModeKey, themeMode.stringValue);
    Cache.instance.setThemeMode(themeMode);
  }

  String? getSesstionToken() {
    final sesstionToken = _prefs.getString(_sesstionTokenKey);
    if (sesstionToken case String()) {
      Cache.instance.setSesstionToken(sesstionToken);
    }
    return sesstionToken;
  }

  String? getUserId() {
    final userId = _prefs.getString(_userIdKey);
    if (userId case String()) {
      Cache.instance.setUserId(userId);
    }
    return userId;
  }

  ThemeMode getThemeMode() {
    final themeModeStringValue = _prefs.getString(_themeModeKey);
    final themeMode = themeModeStringValue?.toThemeMode ?? ThemeMode.system;
    Cache.instance.setThemeMode(themeMode);
    return themeMode;
  }

  Future<void> resetSesstion() async {
    await _prefs.remove(_sesstionTokenKey);
    await _prefs.remove(_userIdKey);
    Cache.instance.resetSesstion();
  }

  bool isFirstTime() => _prefs.getBool(_firstTimerKey) ?? true;
}
