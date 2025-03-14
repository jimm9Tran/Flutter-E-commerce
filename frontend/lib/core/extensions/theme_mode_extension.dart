import 'package:flutter/material.dart';

extension ThemeModeExtension on ThemeMode {
  String get stringValue {
    return switch (this) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      _ => 'system'
    };
  }
}
