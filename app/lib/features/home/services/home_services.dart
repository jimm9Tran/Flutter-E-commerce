import 'dart:convert';

import 'package:ecommerce_major_project/constants/error_handling.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/constants/utils.dart';
import 'package:ecommerce_major_project/models/product.dart';
import 'package:ecommerce_major_project/models/user.dart';
import 'package:ecommerce_major_project/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomeServices {
  Future<List<Product>> fetchCategoryProducts(
      {required BuildContext context, required String category}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    String tokenValue = userProvider.user.token;

    try {
      http.Response res = await http
          .get(Uri.parse('$uri/api/products?category=$category'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': tokenValue,
      });

      var data = jsonDecode(res.body);
      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (Map<String, dynamic> item in data) {
              productList.add(Product.fromJson(item));
            }
          },
        );
      }
    } catch (e) {
      showSnackBar(
          context: context,
          text: "Lỗi khi lấy sản phẩm theo danh mục [home]: $e");
    }
    return productList;
  }

  Future<Product> fetchDealOfDay({required BuildContext context}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Product product = Product(
      name: '',
      description: '',
      brandName: '',
      images: [],
      quantity: 0,
      price: 0.0,
      category: '',
    );

    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/deal-of-day'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            product = Product.fromJson(jsonDecode(res.body));
          },
        );
      }
    } catch (e) {
      showSnackBar(
          context: context, text: "Lỗi khi lấy sản phẩm deal-of-the-day: $e");
    }
    return product;
  }

  Future<List<String>> fetchAllProductsNames(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<String> productNames = [];

    try {
      http.Response res = await http
          .get(Uri.parse('$uri/api/get-all-products-names'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      var data = jsonDecode(res.body);
      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (String item in data) {
              productNames.add(item);
            }
          },
        );
      }
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
    return productNames;
  }

  void addToHistory({
    required BuildContext context,
    required String searchQuery,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse("$uri/api/search-history"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({'searchQuery': searchQuery}),
      );

      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            List<String>? searchHistoryFromDB =
                (jsonDecode(res.body)['searchHistory'] as List)
                    .map((item) => item as String)
                    .toList();

            User user =
                userProvider.user.copyWith(searchHistory: searchHistoryFromDB);
            userProvider.setUserFromModel(user);
          },
        );
      }
    } catch (e) {
      showSnackBar(
          context: context,
          text: "Lỗi khi thêm vào lịch sử tìm kiếm: ${e.toString()}");
    }
  }

  void deleteSearchHistoryItem({
    required BuildContext context,
    required String deleteQuery,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse("$uri/api/delete-search-history-item"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({'deleteQuery': deleteQuery}),
      );

      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {},
        );
      }
    } catch (e) {
      showSnackBar(
          context: context,
          text: "Lỗi khi xóa mục lịch sử tìm kiếm: ${e.toString()}");
    }
  }

  Future<List<String>> fetchSearchHistory(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<String> searchHistoryList = [];

    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/get-search-history'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      var data = jsonDecode(res.body);
      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (String item in data) {
              searchHistoryList.add(item);
            }
          },
        );
      }
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
    return searchHistoryList;
  }

  void addToWishList({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/add-to-wishList'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({'id': product.id}),
      );

      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            User user = userProvider.user
                .copyWith(wishList: jsonDecode(res.body)['wishList']);
            userProvider.setUserFromModel(user);
          },
        );
      }
    } catch (e) {
      showSnackBar(
          context: context, text: "Lỗi khi thêm vào wishlist: ${e.toString()}");
    }
  }
}
