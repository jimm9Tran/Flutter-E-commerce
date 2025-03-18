import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import thư viện intl
import 'package:provider/provider.dart';

class CartSubtotal extends StatelessWidget {
  const CartSubtotal({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    num sum = 0;

    // Tính tổng giá trị đơn hàng
    user.cart
        .map((e) => sum += e['quantity'] * e['product']['price'] as num)
        .toList();

    // Định dạng tiền Việt Nam
    final currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

    return Container(
      margin: EdgeInsets.all(mq.width * .025),
      child: Row(
        children: [
          Text(
            "Tổng: ",
            style: TextStyle(fontSize: 18),
          ),
          Text(
            "${currencyFormat.format(sum)}", // Định dạng số thành tiền Việt Nam
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
