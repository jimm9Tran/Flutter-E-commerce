import 'package:frontend/core/common/entities/user.dart';
import 'package:frontend/core/usecase/usecase.dart';
import 'package:frontend/core/utils/typedefs.dart';
import 'package:frontend/src/user/domain/repos/user_repo.dart';

class GetUser extends UsecaseWithParams<User, String> {
  const GetUser(this._repo);
  final UserRepo _repo;

  @override
  ResultFuture<User> call(String params) => _repo.getUser(params);
}
