import 'package:ecommerce_major_project/features/cart/services/cart_services.dart';
import 'package:ecommerce_major_project/features/product_details/services/product_detail_services.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/models/product.dart';
import 'package:ecommerce_major_project/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DeliveryProduct extends StatefulWidget {
  final int index;
  const DeliveryProduct({required this.index, super.key});

  @override
  State<DeliveryProduct> createState() => _DeliveryProductState();
}

class _DeliveryProductState extends State<DeliveryProduct> {
  final ProductDetailServices productDetailServices = ProductDetailServices();
  final CartServices cartServices = CartServices();

  void increaseQuantity(Product product) {
    productDetailServices.addToCart(context: context, product: product);
  }

  void decreaseQuantity(Product product) {
    cartServices.removeFromCart(context: context, product: product);
  }

  @override
  Widget build(BuildContext context) {
    // Lấy sản phẩm cụ thể từ giỏ hàng
    final productCart = context.watch<UserProvider>().user.cart[widget.index];
    final product = Product.fromJson(productCart['product']);
    final quantity = productCart['quantity'];

    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Hình ảnh sản phẩm
        Image.network(
          product.images[0],
          fit: BoxFit.contain,
          height: mq.width * .25,
          width: mq.width * .25,
        ),
        // Mô tả sản phẩm
        Column(
          children: [
            Container(
              width: mq.width * .57,
              padding:
                  EdgeInsets.only(left: mq.width * .025, top: mq.width * .0125),
              child: Text(
                product.name,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15),
                maxLines: 1,
              ),
            ),
            Container(
              width: mq.width * .57,
              padding: EdgeInsets.only(left: mq.width * .025),
              child: Text(
                currencyFormat.format(product.price),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                maxLines: 2,
              ),
            ),
            Container(
              width: mq.width * .57,
              padding: EdgeInsets.only(left: mq.width * .025),
              child: Text(
                product.price < 500000
                    ? "Có thể áp dụng phí vận chuyển"
                    : "Miễn phí vận chuyển",
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
