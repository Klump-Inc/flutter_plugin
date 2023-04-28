import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:klump_checkout/src/checkout.dart';

class GetLoanStatusUsecase
    extends KCUsecase<StanbicStatusResponse, GetLoanStatusUsecaseParams> {
  GetLoanStatusUsecase({
    required this.stanbicRepository,
  });

  final StanbicRepository stanbicRepository;

  @override
  Future<Either<KCException, StanbicStatusResponse>> call(
    GetLoanStatusUsecaseParams params,
  ) =>
      stanbicRepository.getLoanStatus(id: params.id);
}

class GetLoanStatusUsecaseParams extends Equatable {
  const GetLoanStatusUsecaseParams({
    required this.id,
  });

  final String id;

  @override
  List<Object?> get props => [id];
}
