import 'package:equatable/equatable.dart';
import 'package:frontend/core/errors/exception.dart';

sealed class Failures extends Equatable {
  const Failures({required this.message, required this.statusCode});
  final String message;
  final int statusCode;

  String get errorMessage => '$statusCode Error : $message';

  @override
  List<Object?> get props => [statusCode, message];
}

class ServerFailure extends Failures {
  const ServerFailure({required super.message, required super.statusCode});

  ServerFailure.fromException(ServerException e)
      : this(message: e.message, statusCode: e.statusCode);
}

class CacheFailure extends Failures {
  const CacheFailure({required super.message}) : super(statusCode: 3);
  CacheFailure.fromException(CacheException e) : this(message: e.message);
}
