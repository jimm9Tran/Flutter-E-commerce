import 'package:equatable/equatable.dart';
import 'package:frontend/core/common/entities/user.dart';
import 'package:frontend/core/usecase/usecase.dart';
import 'package:frontend/core/utils/typedefs.dart';
import 'package:frontend/src/auth/domain/repositories/auth_repository.dart';

class Login extends UsecaseWithParams<User, LoginParams> {
  const Login(this._repo);
  final AuthRepository _repo;

  @override
  ResultFuture<User> call(LoginParams params) =>
      _repo.login(email: params.email, password: params.password);
}

class LoginParams extends Equatable {
  const LoginParams({required this.email, required this.password});

  final String email;
  final String password;

  const LoginParams.empty()
      : email = 'Test String',
        password = 'Test String';

  @override
  List<Object> get props => [email, password];
}
