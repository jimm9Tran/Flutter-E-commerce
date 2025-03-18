import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/features/account/widgets/below_app_bar.dart';
import 'package:ecommerce_major_project/features/account/widgets/orders.dart';
import 'package:ecommerce_major_project/features/account/widgets/top_buttons.dart';
import 'package:ecommerce_major_project/features/search_delegate/my_search_screen.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalVariables.getAppBar(
          context: context,
          wantBackNavigation: false,
          title: "Tài khoản của bạn",
          onClickSearchNavigateTo: MySearchScreen()),
      body: Column(
        children: [
          SizedBox(height: mq.width * .025),
          const BelowAppBar(),
          SizedBox(height: mq.width * .025),
          TopButtons(),
          SizedBox(height: mq.width * .045),
          const Orders(),
        ],
      ),
    );
  }
}
