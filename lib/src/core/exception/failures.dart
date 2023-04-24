import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();
  @override
  List<Object> get props => [];
}

class NoInternetFailure extends Failure {
  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {
  const ServerFailure({
    required this.message,
    required this.code,
  });

  final String message;
  final int code;
  @override
  List<Object> get props => [message, code];
}

class CacheFailure extends Failure {
  @override
  List<Object> get props => [];
}

class NoDataFailure extends Failure {
  @override
  List<Object> get props => [];
}

class NullFailure extends Failure {
  @override
  List<Object> get props => [];
}

class UnknownFailure extends Failure {
  @override
  List<Object> get props => [];
}

class TimeoutFailure extends Failure {
  @override
  List<Object> get props => [];
}

class FailureToMessage {
  static String mapFailureToMessage(Failure failure) {
    String message;
    if (failure is NoInternetFailure) {
      message = 'Please check your internet connection and try again!';
    } else if (failure is ServerFailure) {
      message = failure.message;
    } else if (failure is CacheFailure || failure is NoDataFailure) {
      message = 'Data not found, please login again!';
    } else if (failure is TimeoutFailure) {
      message = 'Connection timout, please try again!';
    } else {
      message = 'An Error occurred, please try again!';
    }
    return message;
  }
}
