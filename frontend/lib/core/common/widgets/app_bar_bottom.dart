import 'package:flutter/material.dart';
import 'package:frontend/core/res/styles/colours.dart';
import 'package:frontend/core/utils/core_utils.dart';

class AppBarBottom extends StatelessWidget implements PreferredSize {
  const AppBarBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: ColoredBox(
        color: CoreUtils.adaptiveColor(context,
            lightModeColor: Colors.white,
            darkModeColor: Colours.darkThemeDarkSharColour),
        child: const SizedBox(
          height: 1,
          width: double.maxFinite,
        ),
      ),
    );
  }

  @override
  Widget get child => throw UnimplementedError();

  @override
  Size get preferredSize => Size.zero;
}
