import 'dart:math';

import 'package:ecommerce_major_project/common/widgets/color_loader_2.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/constants/utils.dart';
import 'package:ecommerce_major_project/features/home/screens/category_deals_screen.dart';
import 'package:ecommerce_major_project/features/home/screens/wish_list_screen.dart';
import 'package:ecommerce_major_project/features/home/services/home_services.dart';
import 'package:ecommerce_major_project/features/product_details/screens/product_detail_screen.dart';
import 'package:ecommerce_major_project/features/product_details/services/product_detail_services.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TopCategories extends StatefulWidget {
  const TopCategories({super.key});

  @override
  State<TopCategories> createState() => _TopCategoriesState();
}

class _TopCategoriesState extends State<TopCategories>
    with TickerProviderStateMixin {
  // Tabbar variables
  int activeTabIndex = 0;
  late final TabController _tabController;
  final int _tabLength = 5;

  // Products
  List<Product>? productList;
  final HomeServices homeServices = HomeServices();
  final ProductDetailServices productDetailServices = ProductDetailServices();

  bool favSelected = false;

  List<String> categoriesList = [
    "Mobiles",
    "Essentials",
    "Appliances",
    "Books",
    "Fashion",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabLength, vsync: this);
    fetchCategoryProducts(categoriesList[activeTabIndex]);
  }

  void navigateToCategoryPage(BuildContext context, String category) {
    Navigator.pushNamed(context, CategoryDealsScreen.routeName,
        arguments: category);
  }

  void addToCart(String productName, Product product) {
    print("Triggered add to cart <====");
    print("Product is  : $productName");
    productDetailServices.addToCart(context: context, product: product);
    print("Execution finished add to cart <====");
  }

  fetchCategoryProducts(String categoryName) async {
    productList = await homeServices.fetchCategoryProducts(
      context: context,
      category: categoryName,
    );
    setState(() {});
    if (productList != null && productList!.isNotEmpty) {
      print(
          "\n\n =======> Product List is :  =======> ${productList![0].name}");
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Container(
      height: mq.height * .52,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DefaultTabController(
            length: _tabLength,
            child: Container(
              height: mq.height * .07,
              width: double.infinity,
              child: TabBar(
                controller: _tabController,
                onTap: (index) {
                  setState(() {
                    activeTabIndex = index;
                  });
                  if (productList == null || productList!.isEmpty) {
                    fetchCategoryProducts(categoriesList[activeTabIndex]);
                  }
                },
                physics: const BouncingScrollPhysics(),
                splashBorderRadius: BorderRadius.circular(15),
                indicatorWeight: 1,
                indicatorColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorPadding: EdgeInsets.zero,
                isScrollable: true,
                tabs: [
                  for (int index = 0; index < _tabLength; index++)
                    Tab(
                      child: SizedBox(
                        height: mq.height * .06,
                        child: Card(
                          margin: EdgeInsets.symmetric(
                            horizontal: mq.width * .01,
                          ),
                          color: activeTabIndex == index
                              ? Colors.black87
                              : Colors.grey.shade50,
                          elevation: .8,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: GlobalVariables.primaryGreyTextColor,
                                  width: 0.1),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  GlobalVariables.categoryImages[index]
                                      ['image']!,
                                  height: 30,
                                  color: activeTabIndex == index
                                      ? Colors.white
                                      : Colors.grey.shade700,
                                ),
                                SizedBox(width: mq.width * .015),
                                Text(
                                  GlobalVariables.categoryImages[index]
                                      ['title']!,
                                  style: TextStyle(
                                    color: activeTabIndex == index
                                        ? Colors.white
                                        : Colors.grey.shade700,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          NotificationListener(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollEndNotification) {
                _onTabChanged();
              }
              return false;
            },
            child: Container(
              height: mq.height * 0.45,
              child: TabBarView(
                controller: _tabController,
                children: [
                  for (int i = 0; i < _tabLength; i++)
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                              color: Colors.grey.shade700, width: 0.4),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // "See All" button
                          Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: mq.height * .008)
                                    .copyWith(right: mq.height * .015),
                            child: InkWell(
                              onTap: () {
                                navigateToCategoryPage(
                                    context, categoriesList[activeTabIndex]);
                              },
                              child: Text("See All",
                                  style: TextStyle(
                                      color: Colors.grey.shade800,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                          // GridView chứa danh sách sản phẩm
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      color: Colors.grey.shade200, width: 0.5),
                                  bottom: BorderSide(
                                      color: Colors.grey.shade700, width: 0.4),
                                ),
                              ),
                              child: productList == null
                                  ? const ColorLoader2()
                                  : productList!.isEmpty
                                      ? const Center(
                                          child: Text("No item to fetch"))
                                      : GridView.builder(
                                          scrollDirection: Axis.vertical,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: mq.width * .04,
                                          ),
                                          // Giảm childAspectRatio để giảm chiều cao của card
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 0.70,
                                            mainAxisSpacing: 15,
                                            crossAxisSpacing: 15,
                                          ),
                                          itemCount:
                                              min(productList!.length, 4),
                                          itemBuilder: (context, index) {
                                            Product product =
                                                productList![index];
                                            bool isProductAvailable =
                                                product.quantity == 0;
                                            return Stack(
                                              alignment:
                                                  AlignmentDirectional.topEnd,
                                              children: [
                                                Card(
                                                  color: const Color.fromARGB(
                                                      255, 254, 252, 255),
                                                  elevation: 2.5,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal:
                                                            mq.width * .025,
                                                        vertical: mq.width *
                                                            .015), // giảm padding dọc
                                                    child: ClipRect(
                                                      // ClipRect giúp cắt bớt phần tràn
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator
                                                                  .pushNamed(
                                                                context,
                                                                ProductDetailScreen
                                                                    .routeName,
                                                                arguments:
                                                                    product,
                                                              );
                                                            },
                                                            child: Container(
                                                              height:
                                                                  mq.height *
                                                                      .15,
                                                              width:
                                                                  mq.width * .4,
                                                              child:
                                                                  Image.network(
                                                                product
                                                                    .images[0],
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              height:
                                                                  mq.height *
                                                                      .005),
                                                          SizedBox(
                                                            width:
                                                                double.infinity,
                                                            child: Text(
                                                              product.name,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                double.infinity,
                                                            child: Text(
                                                              // Chuyển giá sang VNĐ, không hiển thị thập phân
                                                              "₫ ${product.price.toStringAsFixed(0)}",
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              TextButton.icon(
                                                                style: TextButton.styleFrom(
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10)),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .grey
                                                                            .shade200),
                                                                onPressed: () {
                                                                  homeServices.addToWishList(
                                                                      context:
                                                                          context,
                                                                      product:
                                                                          product);
                                                                  showSnackBar(
                                                                      context:
                                                                          context,
                                                                      text:
                                                                          "Added to WishList",
                                                                      onTapFunction:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .push(GlobalVariables.createRoute(WishListScreen()));
                                                                      },
                                                                      actionLabel:
                                                                          "View");
                                                                },
                                                                icon: const Icon(
                                                                    CupertinoIcons
                                                                        .add,
                                                                    size: 18,
                                                                    color: Colors
                                                                        .black87),
                                                                label: const Text(
                                                                    "WishList",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black87)),
                                                              ),
                                                              InkWell(
                                                                onTap:
                                                                    isProductAvailable
                                                                        ? () {
                                                                            showSnackBar(
                                                                                context: context,
                                                                                text: "Product out of stock");
                                                                          }
                                                                        : () {
                                                                            addToCart(product.name,
                                                                                product);
                                                                            showSnackBar(
                                                                                context: context,
                                                                                text: "Added to cart");
                                                                          },
                                                                child: const Icon(
                                                                    CupertinoIcons
                                                                        .cart_badge_plus,
                                                                    size: 35),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      // Có thể set trạng thái favorite nếu cần
                                                    });
                                                  },
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 10, right: 10),
                                                    padding:
                                                        const EdgeInsets.all(3),
                                                    decoration:
                                                        const BoxDecoration(
                                                            color: Colors.black,
                                                            shape: BoxShape
                                                                .circle),
                                                    child: Icon(Icons.favorite,
                                                        color: favSelected
                                                            ? Colors.red
                                                            : Colors.white,
                                                        size: 17),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onTabChanged() {
    switch (_tabController.index) {
      case 0:
        activeTabIndex = 0;
        fetchCategoryProducts(categoriesList[activeTabIndex]);
        break;
      case 1:
        activeTabIndex = 1;
        fetchCategoryProducts(categoriesList[activeTabIndex]);
        break;
      case 2:
        activeTabIndex = 2;
        fetchCategoryProducts(categoriesList[activeTabIndex]);
        break;
      case 3:
        activeTabIndex = 3;
        fetchCategoryProducts(categoriesList[activeTabIndex]);
        break;
      case 4:
        activeTabIndex = 4;
        fetchCategoryProducts(categoriesList[activeTabIndex]);
        break;
    }
  }
}
