import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:ecommerce_major_project/common/widgets/custom_button.dart';
import 'package:ecommerce_major_project/common/widgets/custom_textfield.dart';
import 'package:ecommerce_major_project/common/widgets/loader.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/constants/utils.dart';
import 'package:ecommerce_major_project/features/admin/services/admin_services.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});
  static const String routeName = '/add-product';

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController brandNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  final AdminServices adminServices = AdminServices();

  String category = "Điện thoại";
  List<File> images = [];
  final _addProductFormKey = GlobalKey<FormState>();
  bool showLoader = false;

  List<String> productCategories = [
    "Điện thoại",
    "Hàng tiêu dùng",
    "Thiết bị điện tử",
    "Sách",
    "Thời trang"
  ];

  void sellProduct() {
    if (_addProductFormKey.currentState!.validate() && images.isNotEmpty) {
      setState(() {
        showLoader = true;
      });

      adminServices.sellProduct(
        context: context,
        name: productNameController.text,
        description: descriptionController.text,
        brandName: brandNameController.text,
        price: num.parse(priceController.text) + 0.0,
        quantity: int.parse(quantityController.text),
        category: category,
        images: images,
      );
    }
  }

  void selectImages() async {
    var result = await pickImages();
    setState(() {
      images = result;
    });
  }

  @override
  void dispose() {
    productNameController.dispose();
    descriptionController.dispose();
    brandNameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalVariables.getAdminAppBar(
          context: context, title: "Thêm sản phẩm"),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: _addProductFormKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: mq.width * .03),
                child: Column(
                  children: [
                    SizedBox(height: mq.height * .02),
                    images.isNotEmpty
                        ?
                        // Hình ảnh đã chọn không null
                        CarouselSlider(
                            items: images.map((i) {
                              return Builder(
                                builder: (context) => Image.file(i,
                                    fit: BoxFit.cover, height: mq.width * .48),
                              );
                            }).toList(),
                            options: CarouselOptions(
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 2),
                              viewportFraction: 1,
                              height: mq.width * .48,
                            ),
                          )
                        :
                        // Nếu chưa chọn hình ảnh
                        GestureDetector(
                            onTap: selectImages,
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: Radius.circular(mq.width * .025),
                              dashPattern: const [10, 4.5],
                              strokeCap: StrokeCap.round,
                              child: Container(
                                width: double.infinity,
                                height: mq.height * .18,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.folder_open, size: 40),
                                    SizedBox(height: mq.height * .02),
                                    const Text("Chọn hình ảnh sản phẩm",
                                        style:
                                            TextStyle(color: Colors.black26)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    SizedBox(height: mq.height * .03),
                    CustomTextField(
                        controller: productNameController,
                        hintText: "Tên sản phẩm"),
                    SizedBox(height: mq.height * .01),
                    CustomTextField(
                        controller: descriptionController,
                        hintText: "Mô tả",
                        maxLines: 7),
                    SizedBox(height: mq.height * .01),
                    CustomTextField(
                        controller: brandNameController,
                        hintText: "Tên thương hiệu"),
                    SizedBox(height: mq.height * .01),
                    CustomTextField(
                        controller: priceController, hintText: "Giá"),
                    SizedBox(height: mq.height * .01),
                    CustomTextField(
                        controller: quantityController, hintText: "Số lượng"),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: mq.width * .14)
                                .copyWith(bottom: 0),
                        child: DropdownButton(
                          focusColor: Colors.pinkAccent,
                          alignment: Alignment.centerLeft,
                          dropdownColor: Color.fromARGB(255, 202, 183, 255),
                          borderRadius: BorderRadius.circular(10),
                          value: category,
                          onChanged: (String? newVal) {
                            setState(() {
                              category = newVal!;
                            });
                          },
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          items: productCategories.map((String item) {
                            return DropdownMenuItem(
                                value: item, child: Text(item));
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: mq.height * .01),
                    CustomButton(
                      text: "Bán sản phẩm",
                      onTap: sellProduct,
                    ),
                  ],
                ),
              ),
            ),
          ),
          showLoader ? const Loader() : const SizedBox.shrink()
        ],
      ),
    );
  }
}
