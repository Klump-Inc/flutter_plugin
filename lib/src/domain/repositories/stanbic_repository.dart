import 'package:dartz/dartz.dart';
import 'package:klump_checkout/src/checkout.dart';

class StanbicRepository {
  late StanbicRemoteDatasource stanbicRmoteDatasource;
  StanbicRepository() {
    stanbicRmoteDatasource = StanbicRemoteDataSourceImpl(
      KCHttpRequester(),
      KCInternetInfo(),
    );
  }

  Future<Either<KCException, void>> initiate({
    required double amount,
    required String currency,
    required String publicKey,
    required Map<String, dynamic> metaData,
  }) async {
    try {
      final response = await stanbicRmoteDatasource.initiate(
        amount: amount,
        currency: currency,
        publicKey: publicKey,
        metaData: metaData,
      );
      return Right(response);
    } catch (e) {
      return Left(
        KCExceptionHandler.networkError(e),
      );
    }
  }
}
