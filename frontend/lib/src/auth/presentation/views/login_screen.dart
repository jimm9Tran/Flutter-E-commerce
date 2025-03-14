import 'package:flutter/material.dart';
import 'package:frontend/core/common/widgets/app_bar_bottom.dart';
import 'package:frontend/core/res/styles/text.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const path = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Sign In",
            style: TextStyles.headingSemiBold,
          ),
          bottom: const AppBarBottom(),
        ),
        body: Container());
  }
}
