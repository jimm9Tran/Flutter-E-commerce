import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/features/order_details/screens/order_details_screen.dart';
import 'package:ecommerce_major_project/features/search_delegate/my_search_screen.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/models/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AllOrdersScreen extends StatefulWidget {
  static const String routeName = '/all-orders-screen';
  final List<Order>? allOrders;

  AllOrdersScreen({Key? key, this.allOrders}) : super(key: key);

  @override
  State<AllOrdersScreen> createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalVariables.getAppBar(
        title: "Tất cả các đơn hàng",
        context: context,
        onClickSearchNavigateTo: MySearchScreen(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.allOrders!.length,
              itemBuilder: (context, index) {
                final order = widget.allOrders![index];
                return Card(
                  color: Color.fromARGB(255, 245, 239, 255),
                  margin: EdgeInsets.symmetric(horizontal: mq.width * .02),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(width: .2)),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: mq.height * .01, right: mq.height * .01),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.shade800,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "Mã đơn hàng : ${order.id}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ),
                            SizedBox(width: mq.height * .01),
                            InkWell(
                              onTap: () async {
                                await Clipboard.setData(
                                        ClipboardData(text: order.id))
                                    .then((_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Đã sao chép!")),
                                  );
                                });
                              },
                              child: Icon(Icons.copy, size: 17),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            OrderDetailsScreen.routeName,
                            arguments: order,
                          );
                        },
                        child: Column(
                          children: [
                            for (var product in order.products)
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: mq.width * .025),
                                child: Row(
                                  children: [
                                    Image.network(
                                      product.images[0],
                                      fit: BoxFit.contain,
                                      height: mq.width * .25,
                                      width: mq.width * .25,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: mq.width * .57,
                                          padding: EdgeInsets.only(
                                              left: mq.width * .025,
                                              top: mq.width * .0125),
                                          child: Text(
                                            product.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 16),
                                            maxLines: 1,
                                          ),
                                        ),
                                        Container(
                                          width: mq.width * .57,
                                          padding: EdgeInsets.only(
                                              left: mq.width * .025,
                                              top: mq.width * .0125),
                                          child: Text(
                                            "Ngày đặt: ${DateFormat('yMMMd').format(DateTime.fromMillisecondsSinceEpoch(order.orderedAt))}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
