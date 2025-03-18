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
import 'package:intl/intl.dart';

class TopCategories extends StatefulWidget {
  const TopCategories({super.key});

  @override
  State<TopCategories> createState() => _TopCategoriesState();
}

class _TopCategoriesState extends State<TopCategories>
    with TickerProviderStateMixin {
  int activeTabIndex = 0;
  late final TabController _tabController;
  final int _tabLength = 5;

  List<Product>? productList;
  final HomeServices homeServices = HomeServices();
  final ProductDetailServices productDetailServices = ProductDetailServices();

  bool favSelected = false;

  List<String> categoriesList = [
    "Điện thoại",
    "Thiết yếu",
    "Thiết bị gia dụng",
    "Sách",
    "Thời trang",
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
    productDetailServices.addToCart(context: context, product: product);
  }

  fetchCategoryProducts(String categoryName) async {
    productList = await homeServices.fetchCategoryProducts(
      context: context,
      category: categoryName,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Container(
      height: mq.height * .52,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ------------------ TAB BAR ------------------
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
                  if (productList == null) {
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
                              width: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
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
          // ------------------ NỘI DUNG TAB ------------------
          NotificationListener(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollEndNotification) {
                _onTabChanged();
              }
              return false;
            },
            child: Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade700, width: 0.4),
                  ),
                ),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    for (int i = 0; i < _tabLength; i++)
                      SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Nút "Xem tất cả"
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: mq.height * .008,
                              ).copyWith(
                                right: mq.height * .015,
                              ),
                              child: InkWell(
                                onTap: () {
                                  navigateToCategoryPage(
                                      context, categoriesList[activeTabIndex]);
                                },
                                child: Text(
                                  "Xem tất cả",
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            // Container chứa GridView
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      color: Colors.grey.shade200, width: 0.5),
                                  bottom: BorderSide(
                                      color: Colors.grey.shade700, width: 0.4),
                                ),
                              ),
                              // Tăng chiều cao => 0.45
                              height: mq.height * 0.45,
                              child: productList == null
                                  ? const ColorLoader2()
                                  : productList!.isEmpty
                                      ? const Center(
                                          child: Text("Không có sản phẩm"),
                                        )
                                      : GridView.builder(
                                          scrollDirection: Axis.vertical,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: mq.width * .04,
                                          ),
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            // Giảm tỉ lệ => item cao hơn
                                            childAspectRatio: 0.65,
                                            mainAxisSpacing: 15,
                                            crossAxisSpacing: 15,
                                          ),
                                          itemCount:
                                              min(productList!.length, 4),
                                          itemBuilder: (context, index) {
                                            final product = productList![index];
                                            final isProductAvailable =
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
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal:
                                                          mq.width * .025,
                                                      vertical: mq.width * .02,
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        // Ảnh sản phẩm => 0.13
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.pushNamed(
                                                              context,
                                                              ProductDetailScreen
                                                                  .routeName,
                                                              arguments:
                                                                  product,
                                                            );
                                                          },
                                                          child: Container(
                                                            height:
                                                                mq.height * .13,
                                                            width:
                                                                mq.width * .4,
                                                            child:
                                                                Image.network(
                                                              product.images[0],
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height: mq.height *
                                                                .005),
                                                        // Tên sản phẩm
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
                                                                TextAlign.start,
                                                          ),
                                                        ),
                                                        // Giá sản phẩm
                                                        SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                            "${NumberFormat("#,###").format(product.price)}₫",
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 8),
                                                        // Icon wishlist + giỏ hàng
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            IconButton(
                                                              icon: const Icon(
                                                                CupertinoIcons
                                                                    .heart,
                                                                size: 26,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              onPressed: () {
                                                                homeServices
                                                                    .addToWishList(
                                                                  context:
                                                                      context,
                                                                  product:
                                                                      product,
                                                                );
                                                                showSnackBar(
                                                                  context:
                                                                      context,
                                                                  text:
                                                                      "Đã thêm vào danh sách yêu thích",
                                                                  onTapFunction:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .push(GlobalVariables.createRoute(
                                                                            WishListScreen()));
                                                                  },
                                                                  actionLabel:
                                                                      "Xem",
                                                                );
                                                              },
                                                            ),
                                                            IconButton(
                                                              icon: const Icon(
                                                                CupertinoIcons
                                                                    .cart_badge_plus,
                                                                size: 28,
                                                                color: Colors
                                                                    .black87,
                                                              ),
                                                              onPressed: () {
                                                                if (isProductAvailable) {
                                                                  showSnackBar(
                                                                    context:
                                                                        context,
                                                                    text:
                                                                        "Sản phẩm hết hàng",
                                                                  );
                                                                } else {
                                                                  addToCart(
                                                                    product
                                                                        .name,
                                                                    product,
                                                                  );
                                                                  showSnackBar(
                                                                    context:
                                                                        context,
                                                                    text:
                                                                        "Đã thêm vào giỏ hàng",
                                                                  );
                                                                }
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
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
