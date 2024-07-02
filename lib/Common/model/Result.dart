import 'package:homerun/Common/StaticLogger.dart';

class Result<T>{
  bool isSuccess;
  T? result;
  Object? exception;
  StackTrace? stackTrace;

  Result({required this.isSuccess, this.result , this.exception, this.stackTrace});

  factory Result.fromSuccess({T? result}){
    return Result(isSuccess: true,result: result);
  }

  factory Result.fromFailure(Object? exception, StackTrace? stackTrace){
    return Result(isSuccess: false,exception: exception,stackTrace:stackTrace);
  }

  static Future<Result<T>> handle<T>({
    required T Function() action,
  }) async {
    try {
      return Result<T>.fromSuccess(result: action());

    } catch (e , s) {
      StaticLogger.logger.e('[ApiResponse.handleExceptions()] $e\n$s');
      return Result<T>.fromFailure(e, s);
    }
  }

  static Future<Result<T>> handleFuture<T>({
    required Future<T> Function() action,
    Duration timeout = const Duration(seconds: 5), //TODO 적절한 시간으로 수정
  }) async {
    try {
      return Result<T>.fromSuccess(result: await action().timeout(timeout));

    } catch (e , s) {
      StaticLogger.logger.e('[ApiResponse.handleExceptions()] $e\n$s');
      return Result<T>.fromFailure(e, s);
    }
  }
}