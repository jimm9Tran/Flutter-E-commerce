import 'package:flutter/material.dart';
import 'package:frontend/src/on_boarding/presentation/on_boarding_infor_section.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _OnBoardingScreenState();
  }
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    debugPrint("onBoardingScreen");
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: PageView(
          allowImplicitScrolling: true,
          controller: pageController,
          children: const [
            OnBoardingInforSection.second(),
            OnBoardingInforSection.first(),
          ],
        ),
      )),
    );
  }
}
