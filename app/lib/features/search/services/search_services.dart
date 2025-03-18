import 'dart:convert';

import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/constants/utils.dart';
import 'package:ecommerce_major_project/models/product.dart';
import 'package:ecommerce_major_project/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SearchServices {
  Future<List<Product>> fetchSearchedProduct(
      {required BuildContext context, required String searchQuery}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http.get(
        Uri.parse("$uri/api/products/search/$searchQuery"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      // print('Response status: ${res.statusCode}');
      // print('Response body: ${res.body}');

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        if (data is List) {
          for (Map<String, dynamic> item in data) {
            productList.add(Product.fromJson(item));
          }
        } else {
          showSnackBar(
            context: context,
            text: "Dữ liệu trả về không đúng định dạng.",
          );
        }
      } else {
        showSnackBar(
          context: context,
          text: "Lỗi trong việc lấy dữ liệu: ${res.statusCode}",
        );
      }
    } catch (e) {
      showSnackBar(
        context: context,
        text: "Lỗi khi tìm kiếm sản phẩm: ${e.toString()}",
      );
    }
    return productList;
  }
}
