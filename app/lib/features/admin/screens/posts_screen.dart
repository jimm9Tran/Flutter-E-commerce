import 'package:ecommerce_major_project/common/widgets/loader.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/constants/utils.dart';
import 'package:ecommerce_major_project/features/account/widgets/single_product.dart';
import 'package:ecommerce_major_project/features/admin/screens/add_product_screen.dart';
import 'package:ecommerce_major_project/features/admin/services/admin_services.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/models/product.dart';
import 'package:flutter/material.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<Product>? products = [];
  final AdminServices adminServices = AdminServices();

  // Goto add product screen
  void navigateToAddProduct() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  // Fetch all products
  fetchAllProducts() async {
    products = await adminServices.fetchAllProducts(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Nếu products là null thì hiển thị loader
    if (products == null) {
      return const Loader();
    }

    return Scaffold(
      appBar: GlobalVariables.getAdminAppBar(
        context: context,
        title: "Posts Screen",
      ),
      body: products!.isEmpty
          ? const Center(
              child: Text(
                "Add some products to sell",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            )
          : GridView.builder(
              padding: EdgeInsets.all(mq.width * .025),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: mq.width * .025,
                crossAxisCount: 2,
              ),
              itemCount: products!.length,
              itemBuilder: (context, index) {
                final productData = products![index];
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 140,
                      child: SingleProduct(
                        image: productData.images[0],
                      ),
                    ),
                    // Bọc Row trong Flexible để giới hạn không gian và tránh overflow
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Text(
                              productData.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              adminServices.deleteProduct(
                                context: context,
                                product: productData,
                                onSuccess: () {
                                  showSnackBar(
                                    context: context,
                                    text: "Item deleted successfully",
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.delete_outline),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(right: mq.width * .0125),
        child: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          onPressed: navigateToAddProduct,
          tooltip: "Add a product",
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
