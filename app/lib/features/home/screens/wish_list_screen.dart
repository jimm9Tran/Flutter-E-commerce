import 'package:ecommerce_major_project/common/widgets/bottom_bar.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/features/home/screens/wish_list_product.dart';
import 'package:ecommerce_major_project/features/search_delegate/my_search_screen.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({Key? key}) : super(key: key);

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return Scaffold(
      appBar: GlobalVariables.getAppBar(
          context: context,
          title: "Danh sách yêu thích",
          onClickSearchNavigateTo: MySearchScreen()),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: mq.height * .02),
        child: user.wishList!.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/no-orderss.png",
                    height: mq.height * .25,
                  ),
                  const Text(
                    "Oops, không có sản phẩm trong danh sách yêu thích",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: mq.height * .01),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, BottomBar.routeName);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent),
                      child: const Text(
                        "Thêm sản phẩm ngay",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              )
            : Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                for (int index = 0; index < user.wishList!.length; index++)
                  WishListProduct(index: index)
              ]),
      ),
    );
  }
}
