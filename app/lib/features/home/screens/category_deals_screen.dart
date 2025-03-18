import 'package:ecommerce_major_project/common/widgets/color_loader_2.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/features/home/providers/filter_provider.dart';
import 'package:ecommerce_major_project/features/home/screens/filters_screen.dart';
import 'package:ecommerce_major_project/features/home/services/home_services.dart';
import 'package:ecommerce_major_project/features/product_details/screens/product_detail_screen.dart';
import 'package:ecommerce_major_project/features/search/widgets/searched_product.dart';
import 'package:ecommerce_major_project/features/search_delegate/my_search_screen.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/models/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryDealsScreen extends StatefulWidget {
  static const String routeName = '/category-deals';
  final String category;
  const CategoryDealsScreen({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  State<CategoryDealsScreen> createState() => _CategoryDealsScreenState();
}

class _CategoryDealsScreenState extends State<CategoryDealsScreen> {
  List<Product>? productList;
  final HomeServices homeServices = HomeServices();

  @override
  void initState() {
    super.initState();
    fetchCategoryProducts();
  }

  fetchCategoryProducts() async {
    productList = await homeServices.fetchCategoryProducts(
      context: context,
      category: widget.category,
    );
    setState(() {});
  }

  bool light1 = true;

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );
  final MaterialStateProperty<Color?> thumbColor =
      MaterialStateProperty.resolveWith<Color?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return Colors.white;
      }
      return const Color.fromARGB(255, 77, 24, 24);
    },
  );

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<FilterProvider>(context);

    return Scaffold(
      appBar: GlobalVariables.getAppBar(
          context: context,
          wantBackNavigation: true,
          title: "Tất cả kết quả trong ${widget.category}",
          onClickSearchNavigateTo: MySearchScreen()),
      body: productList == null
          ? const ColorLoader2()
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(GlobalVariables.createRoute(FilterScreen()));
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text("Bộ lọc (1)"),
                          Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(color: Colors.grey, thickness: mq.height * .001),
                filterProvider.filterNumber == 1
                    ? getFilterNameList(filterProvider)
                    : filterProvider.filterNumber == 2
                        ? getFilterpriceLtoH(filterProvider)
                        : filterProvider.filterNumber == 3
                            ? getFilterpriceHtoL(filterProvider)
                            : Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: productList!.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  ProductDetailScreen.routeName,
                                                  arguments:
                                                      productList![index]);
                                            },
                                            child: SearchedProduct(
                                                product: productList![index])),
                                      ],
                                    );
                                  },
                                ),
                              )
              ],
            ),
    );
  }

  Widget getFilterNameList(FilterProvider filterProvider) {
    List<Product>? filterOneList = productList;
    filterOneList!.sort((a, b) => a.brandName.compareTo(b.brandName));

    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        itemCount: filterOneList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Text("Bộ lọc: ${filterProvider.getFilterNumber}"),
              GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ProductDetailScreen.routeName,
                        arguments: filterOneList[index]);
                  },
                  child: SearchedProduct(product: filterOneList[index])),
            ],
          );
        },
      ),
    );
  }

  Widget getFilterpriceLtoH(FilterProvider filterProvider) {
    List<Product>? filterOneList = productList;
    filterOneList!.sort((a, b) => a.price.compareTo(b.price));

    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        itemCount: filterOneList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Text("Bộ lọc: ${filterProvider.getFilterNumber}"),
              GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ProductDetailScreen.routeName,
                        arguments: filterOneList[index]);
                  },
                  child: SearchedProduct(product: filterOneList[index])),
            ],
          );
        },
      ),
    );
  }

  Widget getFilterpriceHtoL(FilterProvider filterProvider) {
    List<Product>? filterOneList = productList;
    filterOneList!.sort((a, b) => a.price.compareTo(b.price));

    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        itemCount: filterOneList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ProductDetailScreen.routeName,
                        arguments: filterOneList[index]);
                  },
                  child: SearchedProduct(
                      product: filterOneList.reversed.toList()[index])),
            ],
          );
        },
      ),
    );
  }
}
