import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend/core/extensions/context_extensions.dart';

abstract class CoreUtils {
  const CoreUtils();

  static void postFrameCall(VoidCallback callback) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  static Color adaptiveColor(BuildContext context,
      {required Color lightModeColor, required Color darkModeColor}) {
    return context.isDarkMode ? darkModeColor : lightModeColor;
  }
}
