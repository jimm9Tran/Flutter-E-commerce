import 'package:ecommerce_major_project/features/cart/services/cart_services.dart';
import 'package:ecommerce_major_project/features/product_details/services/product_detail_services.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/models/product.dart';
import 'package:ecommerce_major_project/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import thư viện intl
import 'package:provider/provider.dart';

class CartProduct extends StatefulWidget {
  final int index;
  const CartProduct({required this.index, super.key});

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
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
    final productCart = context.watch<UserProvider>().user.cart[widget.index];
    final product = Product.fromJson(productCart['product']);
    final quantity = productCart['quantity'];

    // Định dạng giá tiền Việt Nam
    final currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: mq.width * .025),
          child: Row(
            children: [
              // Hình ảnh sản phẩm
              Image.network(
                product.images[0],
                fit: BoxFit.contain,
                height: mq.width * .25,
                width: mq.width * .25,
              ),
              SizedBox(width: mq.width * .01),
              // Mô tả sản phẩm
              Column(
                children: [
                  Container(
                    width: mq.width * .57,
                    padding: EdgeInsets.only(
                        left: mq.width * .025, top: mq.width * .0125),
                    child: Text(
                      product.name,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 13),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    width: mq.width * .57,
                    padding: EdgeInsets.only(
                        left: mq.width * .025, top: mq.width * .0125),
                    child: Text(
                      "${currencyFormat.format(product.price)}", // Hiển thị giá với định dạng tiền Việt Nam
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    width: mq.width * .57,
                    padding: EdgeInsets.only(left: mq.width * .025),
                    child: product.price < 500
                        ? const Text(
                            "Có thể áp dụng phí vận chuyển",
                            style: TextStyle(fontSize: 13),
                          )
                        : const Text(
                            "Đủ điều kiện miễn phí vận chuyển",
                            style: TextStyle(fontSize: 13),
                          ),
                  ),
                  Container(
                    width: mq.width * .57,
                    padding: EdgeInsets.only(left: mq.width * .025),
                    child: product.quantity == 0
                        ? const Text(
                            "Hết hàng",
                            style: TextStyle(
                                color: Colors.redAccent, fontSize: 11),
                            maxLines: 2,
                          )
                        : const Text(
                            "Còn hàng",
                            style: TextStyle(color: Colors.teal, fontSize: 11),
                            maxLines: 2,
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: mq.width * .05, bottom: mq.width * .02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12, width: 1.5),
                  borderRadius: BorderRadius.circular(mq.width * .0125),
                  color: Colors.black12,
                ),
                child: Row(children: [
                  InkWell(
                    onTap: () => decreaseQuantity(product),
                    child: Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      child: const Icon(Icons.remove),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 1.5),
                        color: Colors.white,
                        borderRadius: BorderRadius.zero),
                    child: Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      child: Text("$quantity"),
                    ),
                  ),
                  InkWell(
                    onTap: () => increaseQuantity(product),
                    child: Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      child: const Icon(Icons.add),
                    ),
                  ),
                ]),
              )
            ],
          ),
        ),
      ],
    );
  }
}
