import 'package:ecommerce_major_project/common/widgets/bottom_bar.dart';
import 'package:ecommerce_major_project/common/widgets/color_loader_2.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/features/account/screens/all_orders_screen.dart';
import 'package:ecommerce_major_project/features/account/services/account_services.dart';
import 'package:ecommerce_major_project/features/account/widgets/single_product.dart';
import 'package:ecommerce_major_project/features/order_details/screens/order_details_screen.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/models/order.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

// Trạng thái đơn hàng:
// 0: Chờ xử lý
// 1: Hoàn thành
// 2: Đã nhận
// 3: Đã giao
// 4: Đã trả lại sản phẩm

class _OrdersState extends State<Orders> {
  List<Order>? orders;
  final AccountServices accountServices = AccountServices();
  bool showLoader = false;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    setState(() {
      showLoader = true;
    });
    orders = await accountServices.fetchMyOrders(context: context);
    setState(() {
      showLoader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(left: mq.width * 0.04),
              child: const Text("Đơn hàng của bạn",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            ),
            InkWell(
              onTap: orders == null || orders!.isEmpty
                  ? null
                  : () {
                      Navigator.pushNamed(context, AllOrdersScreen.routeName,
                          arguments: orders);
                    },
              child: Container(
                padding: EdgeInsets.only(right: mq.width * 0.04),
                child: Text(
                  "Xem tất cả",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: GlobalVariables.selectedNavBarColor),
                ),
              ),
            ),
          ],
        ),
        showLoader
            ? const ColorLoader2()
            : orders!.isEmpty
                ? Column(
                    children: [
                      Image.asset("assets/images/no-orderss.png",
                          height: mq.height * .15),
                      const Text("Không có đơn hàng"),
                      SizedBox(height: mq.height * 0.02),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, BottomBar.routeName);
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              backgroundColor: Colors.deepPurpleAccent),
                          child: const Text(
                            "Tiếp tục khám phá",
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  )
                : Container(
                    height: mq.height * .2,
                    padding: EdgeInsets.only(
                        left: mq.width * .025, top: mq.width * .05, right: 0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: orders!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              OrderDetailsScreen.routeName,
                              arguments: orders![index],
                            );
                          },
                          child: SingleProduct(
                              image: orders![index].products[0].images[0]),
                        );
                      },
                    ),
                  )
      ],
    );
  }
}
