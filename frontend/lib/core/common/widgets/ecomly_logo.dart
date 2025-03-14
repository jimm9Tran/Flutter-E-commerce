import 'package:flutter/material.dart';
import 'package:frontend/core/extensions/text_style_extensions.dart';
import 'package:frontend/core/res/styles/colours.dart';
import 'package:frontend/core/res/styles/text.dart';

class EcomlyLogo extends StatelessWidget {
  const EcomlyLogo({super.key, this.style});

  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text.rich(TextSpan(
        text: "Ecom",
        style: style ?? TextStyles.appLogo.white,
        children: const [
          TextSpan(
              text: 'Ly',
              style: TextStyle(color: Colours.lightThemeSecondaryColour))
        ]));
  }
}
