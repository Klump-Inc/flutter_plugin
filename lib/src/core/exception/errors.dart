class NoInternetException implements Exception {}

class ServerException implements Exception {
  const ServerException({
    required this.message,
  });
  final String message;
}

class CacheException implements Exception {}

class NullException implements Exception {}

class NoDataException implements Exception {}

class TimoutException implements Exception {}
