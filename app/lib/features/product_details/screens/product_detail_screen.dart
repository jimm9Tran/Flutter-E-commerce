// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/constants/utils.dart';
import 'package:ecommerce_major_project/features/product_details/services/product_detail_services.dart';
import 'package:ecommerce_major_project/features/search/screens/search_screen.dart';
import 'package:ecommerce_major_project/features/search_delegate/my_search_screen.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/models/product.dart';
import 'package:ecommerce_major_project/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-details';
  final Product product;

  const ProductDetailScreen({Key? key, required this.product})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductDetailServices productDetailServices = ProductDetailServices();

  num myRating = 0.0;
  double avgRating = 0.0;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    double totalRating = 0.0;

    for (int i = 0; i < widget.product.rating!.length; i++) {
      totalRating += widget.product.rating![i].rating;
      // hiển thị đánh giá của chúng ta trên trang chi tiết sản phẩm
      if (widget.product.rating![i].userId ==
          Provider.of<UserProvider>(context, listen: false).user.id) {
        myRating = widget.product.rating![i].rating;
      }
    }
    if (totalRating != 0) {
      avgRating = totalRating / widget.product.rating!.length;
    }
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  void addToCart() {
    print("Thêm vào giỏ hàng <====");
    print("Sản phẩm là: ${widget.product.name}");
    productDetailServices.addToCart(context: context, product: widget.product);
    print("Hoàn tất thêm vào giỏ hàng <====");
  }

  @override
  Widget build(BuildContext context) {
    bool isProductAvailable = widget.product.quantity == 0;
    return Scaffold(
      appBar: GlobalVariables.getAppBar(
          context: context, onClickSearchNavigateTo: MySearchScreen()),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width * .03)
              .copyWith(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: mq.height * .3,
                        child: PageView.builder(
                            physics: BouncingScrollPhysics(),
                            onPageChanged: (value) {
                              setState(() {
                                currentIndex = value;
                              });
                            },
                            itemCount: widget.product.images.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Builder(
                                builder: (context) => Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: mq.height * .05),
                                  child: Image.network(
                                      widget.product.images[index],
                                      fit: BoxFit.contain,
                                      height: mq.width * .3),
                                ),
                              );
                            }),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.product.images.length,
                          (index) => buildDot(index: index),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      showSnackBar(
                          context: context,
                          text:
                              "Chức năng chia sẻ chưa được triển khai sử dụng deep links");
                    },
                    icon: const Icon(Icons.share),
                  )
                ],
              ),
              SizedBox(height: mq.height * .02),
              Text(
                widget.product.name,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w200),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: mq.height * .01),
              Text(widget.product.description,
                  style: TextStyle(color: Colors.grey.shade500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("${avgRating.toStringAsFixed(2)} ",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Icon(Icons.star, color: Colors.yellow.shade600),
                      Text(
                        "(1.8K Đánh giá)",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.grey.shade100,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: Text("Đánh giá sản phẩm",
                          style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return rateProductDialog();
                            });
                      }),
                ],
              ),
              isProductAvailable
                  ? const Text(
                      "Hết hàng",
                      style: TextStyle(
                          color: Colors.redAccent, fontWeight: FontWeight.w600),
                    )
                  : const Text("Còn hàng",
                      style: TextStyle(color: Colors.teal)),
              SizedBox(height: mq.height * .01),
              SizedBox(height: mq.width * .025),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: Text(
                      "${NumberFormat("#,###").format(widget.product.price)}₫ ",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(width: mq.width * .05),
                  ElevatedButton(
                    onPressed: isProductAvailable
                        ? () {
                            showSnackBar(
                                context: context, text: "Sản phẩm hết hàng");
                          }
                        : () {
                            showSnackBar(
                                context: context, text: "Đã thêm vào giỏ hàng");
                            addToCart();
                          },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade800,
                        minimumSize: Size(mq.width * .45, mq.height * .06),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22))),
                    child: const Text("Thêm vào giỏ hàng"),
                  ),
                ],
              ),
              SizedBox(height: mq.width * .03),
            ],
          ),
        ),
      ),
    );
  }

  AlertDialog rateProductDialog() {
    return AlertDialog(
      title: const Text(
        "Kéo ngón tay của bạn để đánh giá",
        style: TextStyle(fontSize: 12, fontStyle: FontStyle.normal),
      ),
      content: RatingBar.builder(
        itemSize: 30,
        glow: true,
        glowColor: Colors.yellow.shade900,
        initialRating: double.parse(myRating.toString()),
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemPadding: EdgeInsets.symmetric(horizontal: mq.width * .0125),
        itemCount: 5,
        itemBuilder: (context, _) {
          return const Icon(Icons.star, color: GlobalVariables.secondaryColor);
        },
        onRatingUpdate: (rating) {
          productDetailServices.rateProduct(
            context: context,
            product: widget.product,
            rating: rating,
          );
        },
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Đánh giá",
              style: TextStyle(color: Colors.black),
            ))
      ],
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: currentIndex == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentIndex == index
            ? const Color(0xFFFF7643)
            : const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
