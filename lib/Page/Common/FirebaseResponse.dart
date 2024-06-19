import 'package:homerun/Common/StaticLogger.dart';

class FirebaseResponse<T>{
  T? response;

  Object? exception;
  StackTrace? stackTrace;
  bool isSuccess;

  FirebaseResponse({required this.isSuccess, this.exception, this.response , this.stackTrace});

  static Future<FirebaseResponse<T>> handleRequest<T>({
    required Future<T> Function() action,
    void Function(Object , StackTrace)? onError,
  }) async {
    try {
      return FirebaseResponse(
        response: await action(),
        isSuccess: true,
      );

    } catch (e , stacktrace) {
      StaticLogger.logger.e('[ApiResponse.handleExceptions()] $e\n$stacktrace');
      if(onError != null){
        onError(e , stacktrace);
      }
      return FirebaseResponse(
          isSuccess: false,
          exception : e,
          stackTrace: stacktrace
      );
    }
  }
}
