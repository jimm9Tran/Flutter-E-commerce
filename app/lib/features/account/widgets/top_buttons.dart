import 'package:ecommerce_major_project/features/account/services/account_services.dart';
import 'package:ecommerce_major_project/features/account/widgets/account_button.dart';
import 'package:ecommerce_major_project/features/cart/screens/cart_screen.dart';
import 'package:ecommerce_major_project/features/home/screens/wish_list_screen.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:flutter/material.dart';

class TopButtons extends StatelessWidget {
  TopButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AccountButton(text: "Đơn hàng của bạn", onTap: () {}),
            AccountButton(
                text: "Danh sách yêu thích",
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => WishListScreen()));
                }),
          ],
        ),
        SizedBox(height: mq.height * .01),
        Row(
          children: [
            AccountButton(
                text: "Giỏ hàng",
                onTap: () {
                  Navigator.pushNamed(context, CartScreen.routeName);
                }),
            AccountButton(
                text: "Đăng xuất",
                onTap: () => AccountServices().logOut(context)),
          ],
        )
      ],
    );
  }
}
