import 'package:ecommerce_major_project/common/widgets/stars.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/models/product.dart';
import 'package:flutter/material.dart';

class SearchedProduct extends StatelessWidget {
  final Product product;
  const SearchedProduct({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    double totalRating = 0.0;

    for (int i = 0; i < product.rating!.length; i++) {
      totalRating += product.rating![i].rating;
    }

    double avgRating = 0.0;

    if (totalRating != 0) {
      avgRating = totalRating / product.rating!.length;
    }

    return Column(
      children: [
        Card(
          color: Colors.white,
          elevation: 1.5,
          child: Container(
            color: Colors.white,
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
                        style: const TextStyle(fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      width: mq.width * .57,
                      padding: EdgeInsets.only(
                          left: mq.width * .025, top: mq.width * .0125),
                      child: Stars(rating: avgRating),
                    ),
                    Container(
                      width: mq.width * .57,
                      padding: EdgeInsets.only(
                          left: mq.width * .025, top: mq.width * .0125),
                      child: Text(
                        "₫ ${product.price.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                        maxLines: 2,
                      ),
                    ),
                    Container(
                      width: mq.width * .57,
                      padding: EdgeInsets.only(left: mq.width * .025),
                      child: const Text(
                        "Miễn phí vận chuyển",
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    Container(
                      width: mq.width * .57,
                      padding: EdgeInsets.only(
                          left: mq.width * .025, top: mq.width * .0125),
                      child: product.quantity == 0
                          ? const Text(
                              "Hết hàng",
                              style: TextStyle(
                                  color: Colors.redAccent, fontSize: 11),
                              maxLines: 2,
                            )
                          : const Text("Còn hàng",
                              style:
                                  TextStyle(color: Colors.teal, fontSize: 11),
                              maxLines: 2),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
