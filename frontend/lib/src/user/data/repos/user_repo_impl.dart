import 'package:dartz/dartz.dart';
import 'package:frontend/core/common/entities/user.dart';
import 'package:frontend/core/errors/exception.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/core/utils/typedefs.dart';
import 'package:frontend/src/user/data/datasources/user_remote_data_src.dart';
import 'package:frontend/src/user/domain/repos/user_repo.dart';

class UserRepoImpl implements UserRepo {
  const UserRepoImpl(this._remoteDataSrc);

  final UserRemoteDataSrc _remoteDataSrc;

  @override
  ResultFuture<User> getUser(String userId) async {
    try {
      final result = await _remoteDataSrc.getUser(userId);
      return result;
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<String> getUserPaymentProfile(String userId) async {
    try {
      final result = await _remoteDataSrc.getUserPaymentProfile(userId);
      return result;
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<User> updateUser(
      {required String userId, required DataMap updateData}) async {
    try {
      final result = await _remoteDataSrc.updateUser(
        userId: userId,
        updateData: updateData,
      );
      return result;
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
