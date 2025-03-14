import 'package:equatable/equatable.dart';
import 'package:frontend/core/common/entities/user.dart';
import 'package:frontend/core/usecase/usecase.dart';
import 'package:frontend/core/utils/typedefs.dart';
import 'package:frontend/src/user/domain/repos/user_repo.dart';

class UpdateUser extends UsecaseWithParams<User, UpdateUserParams> {
  const UpdateUser(this._repo);

  final UserRepo _repo;

  @override
  ResultFuture<User> call(UpdateUserParams params) =>
      _repo.updateUser(userId: params.userId, updateData: params.updateData);
}

class UpdateUserParams extends Equatable {
  const UpdateUserParams({required this.userId, required this.updateData});

  final String userId;
  final DataMap updateData;
  @override
  List<Object?> get props => [userId, updateData];
}
