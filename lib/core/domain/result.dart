import 'package:equatable/equatable.dart';

import 'app_error.dart';

sealed class Result<T> extends Equatable {
  const Result();

  @override
  List<Object?> get props => const [];
}

final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;

  @override
  List<Object?> get props => [data];
}

final class Failure<T> extends Result<T> {
  const Failure(this.error);

  final AppError error;

  @override
  List<Object?> get props => [error];
}
