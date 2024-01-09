import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:klump_checkout/klump_checkout.dart';

class GetLoanStatusUsecase
    extends KCUsecase<DisbursementStatusResponse, GetLoanStatusUsecaseParams> {
  GetLoanStatusUsecase({
    required this.partnerRepository,
  });

  final PartnerRepository partnerRepository;

  @override
  Future<Either<KCException, DisbursementStatusResponse>> call(
    GetLoanStatusUsecaseParams params,
  ) =>
      partnerRepository.getLoanStatus(
          url: params.url, publicKey: params.publicKey);
}

class GetLoanStatusUsecaseParams extends Equatable {
  const GetLoanStatusUsecaseParams({
    required this.url,
    required this.publicKey,
  });

  final String url;
  final String publicKey;

  @override
  List<Object?> get props => [url, publicKey];
}
