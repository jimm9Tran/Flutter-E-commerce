import 'package:flutter/material.dart';
import 'package:frontend/core/utils/core_utils.dart';

abstract class Colours {
  static const Color lightThemePrimaryTini = Color(0xff9e9cdc);
  static const Color lightThemePrimaryColour = Color(0xff524eb7);
  static const Color lightThemeSecondaryColour = Color(0xfff76631);
  static const Color lightThemePrimaryTextColour = Color(0xff282344);
  static const Color lightThemeSeconaryTextColour = Color(0xff9491a1);
  static const Color lightThemePinkColour = Color(0xfff08e98);
  static const Color lightThemeWhiteColour = Color(0xfff08e98);
  static const Color lightThemeBrownColour = Color(0xff8a6d4b);
  static const Color lightThemeBlueColour = Color(0xff0089cc);
  static const Color lightThemeGreenColour = Color(0xff4caf50);
  static const Color lightThemeYellowColour = Color(0xffffeb3b);
  static const Color lightThemeOrangeColour = Color(0xfff4511e);
  static const Color lightThemeTiniStockColour = Color(0xfff6f6f9);
  static const Color lightThemeStockColour = Color(0xffe4e4e9);
  static const Color darkThemeDarkSharColour = Color(0xff191821);
  static const Color darkThemeBGDark = Color(0xff0e0d11);
  static const Color darkThemeDarkNavbarColous = Color(0xff201f27);
  static Color classicAdaptiveTextColor(BuildContext context) =>
      CoreUtils.adaptiveColor(context,
          lightModeColor: lightThemePrimaryTextColour,
          darkModeColor: lightThemeWhiteColour);
}
