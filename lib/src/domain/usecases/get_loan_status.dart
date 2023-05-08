import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:klump_checkout/klump_checkout.dart';

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
      stanbicRepository.getLoanStatus(
          id: params.id, publicKey: params.publicKey);
}

class GetLoanStatusUsecaseParams extends Equatable {
  const GetLoanStatusUsecaseParams({
    required this.id,
    required this.publicKey,
  });

  final String id;
  final String publicKey;

  @override
  List<Object?> get props => [id, publicKey];
}
