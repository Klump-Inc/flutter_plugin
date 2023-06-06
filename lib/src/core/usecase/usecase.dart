import 'package:equatable/equatable.dart';

abstract class KCUsecase<Type, Params> {
  dynamic call(Params params);
}

class KCNoParams extends Equatable {
  @override
  List<Object> get props => [];
}
