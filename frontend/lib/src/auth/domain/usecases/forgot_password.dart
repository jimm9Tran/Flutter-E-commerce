import 'package:frontend/core/usecase/usecase.dart';
import 'package:frontend/core/utils/typedefs.dart';
import 'package:frontend/src/auth/domain/repositories/auth_repository.dart';

class ForgotPassword extends UsecaseWithParams<void, String> {
  const ForgotPassword(this._repo);
  final AuthRepository _repo;

  @override
  ResultFuture<void> call(String params) => _repo.forgetPassword(params);
}
