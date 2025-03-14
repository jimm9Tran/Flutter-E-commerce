import 'package:flutter/material.dart';
import 'package:frontend/core/common/app/cache_helper.dart';
import 'package:frontend/core/common/widgets/rounded_button.dart';
import 'package:frontend/core/extensions/text_style_extensions.dart';
import 'package:frontend/core/res/styles/colours.dart';
import 'package:frontend/core/res/styles/text.dart';
import 'package:frontend/core/services/injection_container.dart';
import 'package:frontend/core/utils/network_utils.dart';
import 'package:frontend/src/auth/presentation/views/login_screen.dart';
import 'package:go_router/go_router.dart';

class OnBoardingInforSection extends StatelessWidget {
  const OnBoardingInforSection.first({super.key}) : first = true;
  const OnBoardingInforSection.second({super.key}) : first = false;

  final bool first;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.center,
      children: [
        Image.asset(first
            ? "assets/images/on_board_female.png"
            : "assets/images/on_board_male.png"),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            switch (first) {
              true => Text.rich(
                  textAlign: TextAlign.left,
                  TextSpan(
                      text: "${DateTime.now().year}\n",
                      style: TextStyles.headingBold.orange,
                      children: [
                        TextSpan(
                            text: "Winter Sale is live now",
                            style: TextStyle(
                                color:
                                    Colours.classicAdaptiveTextColor(context)))
                      ])),
              _ => Text.rich(
                  textAlign: TextAlign.left,
                  TextSpan(
                      text: "Flash Sale\n",
                      style: TextStyles.headingBold.adaptiveColor(context),
                      children: [
                        const TextSpan(
                            text: "Men's ",
                            style: TextStyle(
                                color: Colours.lightThemeSeconaryTextColour)),
                        TextSpan(
                            text: "Shirts and Watches",
                            style: TextStyle(
                                color:
                                    Colours.classicAdaptiveTextColor(context)))
                      ]))
            },
            RoundedButton(
              text: "Get Started",
              onPressed: () {
                sl<CacheHelper>().cacheFirstTime();
                context.go(LoginScreen.path);
              },
            )
          ],
        )
      ],
    );
  }
}
