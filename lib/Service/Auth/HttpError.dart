class HttpError implements Exception{
  final int status;
  final int code;
  final String message;

  HttpError({
    required this.status,
    required this.code,
    required this.message,
  });

  factory HttpError.fromMap(Map<String, dynamic> map) {
    return HttpError(
      status: map['status'],
      code: map['code'],
      message: map['message'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'code': code,
      'message': message,
    };
  }
}

class BadRequestError extends HttpError {
  BadRequestError({
    int code = 40000,
    String message = 'Bad Request',
  }) : super(status: 400, code: code, message: message);
}

class UnauthorizedError extends HttpError {
  UnauthorizedError({
    int code = 40100,
    String message = 'Unauthorized',
  }) : super(status: 401, code: code, message: message);
}

class ForbiddenError extends HttpError {
  ForbiddenError({
    int code = 40300,
    String message = 'Forbidden',
  }) : super(status: 403, code: code, message: message);
}

class NotFoundError extends HttpError {
  NotFoundError({
    int code = 40400,
    String message = 'Not Found',
  }) : super(status: 404, code: code, message: message);
}

class InternalServerError extends HttpError {
  InternalServerError({
    int code = 50000,
    String message = 'Internal Server Error',
  }) : super(status: 500, code: code, message: message);
}

class ServerErrorCodes{
  static int userNotFoundError = 40104;
}
