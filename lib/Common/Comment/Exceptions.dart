abstract class CommentServiceException implements Exception{
  final String? message;

  CommentServiceException(this.message);

  @override
  String toString() {
    return "$message";
  }
}

class InvalidOrderTypeException extends CommentServiceException implements Exception {
  InvalidOrderTypeException(Object? order) : super('Unexpected OrderType: $order');

  @override
  String toString() {
    return "InvalidOrderTypeException: $message";
  }
}

class NotOwnerException extends CommentServiceException {
  NotOwnerException() : super('User is not the owner of this comment');

  @override
  String toString() {
    return "NotOwnerException: $message";
  }
}