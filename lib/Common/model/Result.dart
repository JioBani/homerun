import 'package:homerun/Common/StaticLogger.dart';

class Result<T>{
  bool isSuccess;
  T? content;
  Object? exception;
  StackTrace? stackTrace;

  Result({required this.isSuccess, this.content , this.exception, this.stackTrace});

  factory Result.fromSuccess({T? content}){
    return Result(isSuccess: true,content: content);
  }

  factory Result.fromFailure(Object? exception, StackTrace? stackTrace){
    return Result(isSuccess: false,exception: exception,stackTrace:stackTrace);
  }

  static Future<Result<T>> handle<T>({
    required T Function() action,
  }) async {
    try {
      return Result<T>.fromSuccess(content: action());

    } catch (e , s) {
      StaticLogger.logger.e('[ApiResponse.handleExceptions()] $e\n$s');
      return Result<T>.fromFailure(e, s);
    }
  }

  static Future<Result<T>> handleFuture<T>({
    required Future<T> Function() action,
    Function(Object , StackTrace)? onError,
    Duration timeout = const Duration(minutes: 1), //TODO 적절한 시간으로 수정
  }) async {
    try {
      return Result<T>.fromSuccess(content: await action().timeout(timeout));

    } catch (e , s) {
      StaticLogger.logger.e('[Result.handleFuture()] $e\n$s');
      if(onError != null){
        onError(e , s);
      }
      return Result<T>.fromFailure(e, s);
    }
  }
}