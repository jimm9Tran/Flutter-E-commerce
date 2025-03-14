import 'package:equatable/equatable.dart';
import 'package:frontend/core/usecase/usecase.dart';
import 'package:frontend/core/utils/typedefs.dart';
import 'package:frontend/src/auth/domain/repositories/auth_repository.dart';

class ResetPassword extends UsecaseWithParams<void, ResetPasswordParams> {
  const ResetPassword(this._repo);
  final AuthRepository _repo;

  @override
  ResultFuture<void> call(ResetPasswordParams params) =>
      _repo.resetPassword(email: params.email, newPassword: params.newPassword);
}

class ResetPasswordParams extends Equatable {
  const ResetPasswordParams({required this.email, required this.newPassword});

  final String email;
  final String newPassword;

  @override
  List<dynamic> get props => [email, newPassword];
}
