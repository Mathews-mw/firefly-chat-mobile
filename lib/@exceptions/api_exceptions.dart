class ApiExceptions implements Exception {
  final String code;
  final String message;
  final int? statusCode;

  ApiExceptions({required this.code, required this.message, this.statusCode});

  @override
  String toString() {
    return 'API Exceptions: $code - $message';
  }
}
