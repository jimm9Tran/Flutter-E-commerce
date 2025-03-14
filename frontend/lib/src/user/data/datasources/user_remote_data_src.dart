import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import 'package:frontend/core/common/data/models/user_model.dart';
import 'package:frontend/core/common/entities/user.dart';
import 'package:frontend/core/common/singletons/cache.dart';
import 'package:frontend/core/errors/exception.dart';
import 'package:frontend/core/extensions/string_extensions.dart';
import 'package:frontend/core/utils/constants/network_constant.dart';
import 'package:frontend/core/utils/error_response.dart';
import 'package:frontend/core/utils/network_utils.dart';
import 'package:frontend/core/utils/typedefs.dart';
import 'package:http/http.dart' as http;

abstract class UserRemoteDataSrc {
  ResultFuture<User> getUser(String userId);
  ResultFuture<User> updateUser(
      {required String userId, required DataMap updateData});

  ResultFuture<String> getUserPaymentProfile(String userId);
}

// ignore: constant_identifier_names
const USER_ENDPOINT = 'users';

class UserRemoteDataSrcImpl implements UserRemoteDataSrc {
  const UserRemoteDataSrcImpl(this._client);
  final http.Client _client;
  @override
  ResultFuture<UserModel> getUser(String userId) async {
    try {
      final uri = Uri.parse('${NetworkConstant.baseURL}$USER_ENDPOINT/$userId');
      final response = await _client.get(uri,
          headers: Cache.instance.sessionToken!.toAuthHeaders);

      final payload = jsonDecode(response.body) as DataMap;

      await NetworkUtils.renewToken(response);

      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }

      return Right(UserModel.fromMap(payload));
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw const ServerException(
          message: "ERROR OCCURRED: It is not your fault, it is ours",
          statusCode: 500);
    }
  }

  @override
  ResultFuture<String> getUserPaymentProfile(String userId) async {
    try {
      final uri = Uri.parse(
          '${NetworkConstant.baseURL}$USER_ENDPOINT/$userId/paymentProfile');
      final response = await _client.get(uri,
          headers: Cache.instance.sessionToken!.toAuthHeaders);

      final payload = jsonDecode(response.body) as DataMap;

      await NetworkUtils.renewToken(response);

      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
      return payload['url'];
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw const ServerException(
          message: "ERROR OCCURRED: It is not your fault, it is ours",
          statusCode: 500);
    }
  }

  @override
  ResultFuture<UserModel> updateUser(
      {required String userId, required DataMap updateData}) async {
    try {
      final uri = Uri.parse('${NetworkConstant.baseURL}$USER_ENDPOINT/$userId');
      final response = await _client.put(uri,
          body: jsonEncode(updateData),
          headers: Cache.instance.sessionToken!.toAuthHeaders);

      final payload = jsonDecode(response.body) as DataMap;

      await NetworkUtils.renewToken(response);

      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
      return Right(UserModel.fromMap(payload));
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw const ServerException(
          message: "ERROR OCCURRED: It is not your fault, it is ours",
          statusCode: 500);
    }
  }
}
