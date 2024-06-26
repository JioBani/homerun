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
}