class InvalidAuthException implements Exception {
  final String message;

  InvalidAuthException(this.message);
}