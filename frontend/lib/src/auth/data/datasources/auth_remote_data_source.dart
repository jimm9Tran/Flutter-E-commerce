// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/common/app/cache_helper.dart';
import 'package:frontend/core/common/data/models/user_model.dart';
import 'package:frontend/core/common/entities/user.dart';
import 'package:frontend/core/common/singletons/cache.dart';
import 'package:frontend/core/errors/exception.dart';
import 'package:frontend/core/extensions/string_extensions.dart';
import 'package:frontend/core/services/injection_container.dart';
import 'package:frontend/core/utils/constants/network_constant.dart';
import 'package:frontend/core/utils/error_response.dart';
import 'package:frontend/core/utils/network_utils.dart';
import 'package:frontend/core/utils/typedefs.dart';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<void> register(
      {required String name,
      required String email,
      required String password,
      required String phone});

  ResultFuture<User> login({required String email, required String password});

  ResultFuture<void> forgotPassword({required String email});

  ResultFuture<void> verifyOTP({required String email, required String otp});

  ResultFuture<void> resetPassword(
      {required String email, required String newPassword});

  ResultFuture<bool> verifyToken();
}

const REGISTER_ENDPOINT = '/register';
const LOGIN_ENDPOINT = '/login';
const FORGOT_PASSWORD_ENDPOINT = '/forgot-password';
const VERIFY_OTP_ENDPOINT = '/verify-otp';
const RESET_PASSWORD_ENDPOINT = '/reset-password';
const VERIFY_TOKEN_ENDPOINT = '/verify-token';

class AuthRemoteDataSourceImplementation implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImplementation(this._client);
  final http.Client _client;
  @override
  ResultFuture<void> forgotPassword({required String email}) async {
    try {
      final uri =
          Uri.parse('${NetworkConstant.baseURL}$FORGOT_PASSWORD_ENDPOINT');

      final response = await _client.post(uri,
          body: jsonEncode({'email': email}), headers: NetworkConstant.header);
      if (response.statusCode != 200) {
        final payload = jsonDecode(response.body) as DataMap;
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
            message: errorResponse.errorMessage,
            statusCode: response.statusCode);
      } else {
        throw Exception('Failed to send forgot password email');
      }
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  ResultFuture<UserModel> login(
      {required String email, required String password}) async {
    try {
      final uri = Uri.parse('${NetworkConstant.baseURL}$LOGIN_ENDPOINT');
      final response = await _client.post(uri,
          body: jsonEncode({'email': email, 'password': password}),
          headers: NetworkConstant.header);

      final payload = jsonDecode(response.body) as DataMap;
      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
            message: errorResponse.errorMessage,
            statusCode: response.statusCode);
      }
      await sl<CacheHelper>().cacheSesstionToken(payload["accessToken"]);
      final user = UserModel.fromMap(payload);
      await sl<CacheHelper>().cacheUserId(user.id);
      return Right(user);
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<void> register(
      {required String name,
      required String email,
      required String password,
      required String phone}) async {
    try {
      final uri = Uri.parse('${NetworkConstant.baseURL}$REGISTER_ENDPOINT');

      final response = await _client.post(uri,
          body: jsonEncode({
            'name': name,
            'email': email,
            'password': password,
            'phone': phone
          }),
          headers: NetworkConstant.header);
      if (response.statusCode != 200 && response.statusCode != 201) {
        final payload = jsonDecode(response.body) as DataMap;
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
            message: errorResponse.errorMessage,
            statusCode: response.statusCode);
      } else {
        throw Exception('Failed to register user');
      }
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  ResultFuture<void> resetPassword(
      {required String email, required String newPassword}) async {
    try {
      final uri =
          Uri.parse('${NetworkConstant.baseURL}$RESET_PASSWORD_ENDPOINT');

      final response = await _client.post(uri,
          body: jsonEncode({'email': email, 'newPassword': newPassword}),
          headers: NetworkConstant.header);
      if (response.statusCode != 200 && response.statusCode != 201) {
        final payload = jsonDecode(response.body) as DataMap;
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
            message: errorResponse.errorMessage,
            statusCode: response.statusCode);
      } else {
        throw Exception('Failed to reset password');
      }
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  ResultFuture<void> verifyOTP(
      {required String email, required String otp}) async {
    try {
      final uri = Uri.parse('${NetworkConstant.baseURL}$VERIFY_OTP_ENDPOINT');

      final response = await _client.post(uri,
          body: jsonEncode({'email': email, 'otp': otp}),
          headers: Cache.instance.sessionToken!.toAuthHeaders);
      final payload = jsonDecode(response.body) as DataMap;
      if (response.statusCode != 200 && response.statusCode != 201) {
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
            message: errorResponse.errorMessage,
            statusCode: response.statusCode);
      } else {
        throw Exception('Failed to verify otp');
      }
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  ResultFuture<bool> verifyToken() async {
    try {
      final uri = Uri.parse('${NetworkConstant.baseURL}$VERIFY_TOKEN_ENDPOINT');

      final response = await _client.get(uri,
          headers: Cache.instance.sessionToken!.toAuthHeaders);
      final payload = jsonDecode(response.body);
      await NetworkUtils.renewToken(response);
      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
            message: errorResponse.errorMessage,
            statusCode: response.statusCode);
      }

      return Right(payload);
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }
}
