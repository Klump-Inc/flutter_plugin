import 'package:dartz/dartz.dart';
import 'package:klump_checkout/src/checkout.dart';

class GetBankTCUsecase extends KCUsecase<String, NoParams> {
  GetBankTCUsecase({
    required this.stanbicRepository,
  });

  final StanbicRepository stanbicRepository;

  @override
  Future<Either<KCException, String>> call(
    NoParams params,
  ) =>
      stanbicRepository.getBankTC();
}
