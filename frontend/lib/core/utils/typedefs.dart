import 'package:dartz/dartz.dart';
import 'package:frontend/core/errors/failures.dart';

typedef DataMap = Map<String, dynamic>;
typedef ResultFuture<T> = Future<Either<Failures, T>>;
