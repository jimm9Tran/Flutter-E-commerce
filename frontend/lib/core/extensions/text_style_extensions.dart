import 'package:flutter/material.dart';
import 'package:frontend/core/res/styles/colours.dart';

extension TextStyleExt on TextStyle {
  TextStyle get orange => copyWith(color: Colours.lightThemeSecondaryColour);
  TextStyle get darkk => copyWith(color: Colours.lightThemePrimaryTextColour);
  TextStyle get grey => copyWith(color: Colours.lightThemeSeconaryTextColour);
  TextStyle get white => copyWith(color: Colours.lightThemeWhiteColour);
  TextStyle get primary => copyWith(color: Colours.lightThemePrimaryColour);
  TextStyle adaptiveColor(BuildContext context) =>
      copyWith(color: Colours.classicAdaptiveTextColor(context));
}
