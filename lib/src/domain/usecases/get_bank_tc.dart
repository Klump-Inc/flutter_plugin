import 'package:dartz/dartz.dart';
import 'package:klump_checkout/src/checkout.dart';

class GetBankTCUsecase extends KCUsecase<TermsAndCondition, NoParams> {
  GetBankTCUsecase({
    required this.stanbicRepository,
  });

  final StanbicRepository stanbicRepository;

  @override
  Future<Either<KCException, TermsAndCondition>> call(
    NoParams params,
  ) =>
      stanbicRepository.getBankTC();
}
