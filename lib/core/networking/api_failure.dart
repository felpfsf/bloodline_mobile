enum ApiFailureType {
  connection,
  timeout,
  unauthorized,
  forbidden,
  notFound,
  validation,
  conflict,
  rateLimited,
  server,
  cancelled,
  unexpected,
}

final class ApiFailure {
  const ApiFailure({
    required this.type,
    this.statusCode,
  });

  final ApiFailureType type;
  final int? statusCode;
}
