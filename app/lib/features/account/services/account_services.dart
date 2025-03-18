import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:ecommerce_major_project/constants/error_handling.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/constants/utils.dart';
import 'package:ecommerce_major_project/features/auth/screens/auth_screen.dart';
import 'package:ecommerce_major_project/models/order.dart';
import 'package:ecommerce_major_project/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountServices {
  // Lấy tất cả các đơn hàng của người dùng
  getAllOrders({required BuildContext context}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    http.Response res = await http.get(
      Uri.parse("$uri/api/order"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token
      },
    );

    var data = jsonDecode(res.body);

    if (context.mounted) {
      httpErrorHandle(response: res, context: context, onSuccess: () {});
    }
  }

  // Thêm ảnh đại diện người dùng
  void addProfilePicture(
      {required BuildContext context, required File imagePicked}) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    try {
      final cloudinary = CloudinaryPublic('dyqymg02u', 'ktdtolon');

      String imageUrl = "";
      CloudinaryResponse cloudinaryResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(imagePicked.path,
            folder: "User_Profile_Pictures/${user.email}/${user.name}"),
      );
      imageUrl = cloudinaryResponse.secureUrl;

      http.Response res = await http.post(
        Uri.parse('$uri/api/add-profile-picture'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token,
        },
        body: jsonEncode({'imageUrl': imageUrl}),
      );

      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(
                context: context, text: 'Cập nhật ảnh đại diện thành công!');
          },
        );
      }
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
  }

  // Lấy danh sách đơn hàng của người dùng
  Future<List<Order>?> fetchMyOrders({required BuildContext context}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order>? orderList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/orders/me'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              orderList.add(
                Order.fromJson(
                  jsonEncode(
                    jsonDecode(res.body)[i],
                  ),
                ),
              );
            }
          },
        );
      }
    } catch (e) {
      showSnackBar(
          context: context, text: "Có lỗi khi lấy thông tin đơn hàng: $e");
    }
    return orderList;
  }

  // Đăng xuất người dùng
  void logOut(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('x-auth-token', '');
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, AuthScreen.routeName, (route) => false);
      }
    } catch (e) {
      showSnackBar(context: context, text: "Lỗi khi đăng xuất: $e");
    }
  }
}
