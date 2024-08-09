
import 'package:homerun/Common/StaticLogger.dart';
import 'package:http/http.dart';

import 'ApiResponse.dart';

class ApiResult<T>{
  final ApiResponse<T>? apiResponse;
  ///서버에서 에러가 발생한 경우 errors는 null 입니다.
  final Object? error;
  final StackTrace? stackTrace;
  final bool isParsingError;
  final bool isSuccess;

  ApiResult({required this.isSuccess,this.apiResponse, this.error,this.stackTrace ,this.isParsingError = false});

  static Future<ApiResult> handleRequest<T>(Future<Response> request) async {
    Response response;
    try{
      response = await request;
    }catch(e,s){
      StaticLogger.logger.e("$e,$s");
      return ApiResult<T>.fromFailure(e,s);
    }

    try{
      if(response.statusCode == 200 || response.statusCode == 300){
        return ApiResult<T>(
            isSuccess: true,
            apiResponse: ApiResponse<T>.fromResponse(response)
        );
      }
      else{
        return ApiResult<T>(
            isSuccess: false,
            apiResponse: ApiResponse<T>.fromResponse(response)
        );
      }
    }
    catch(e , s){
      if(response.statusCode == 200 || response.statusCode == 300){
        return ApiResult(
            isSuccess: true,
            apiResponse: null,
            error: e,
            stackTrace: s,
            isParsingError: true
        );
      }
      else{
        return ApiResult<T>(
            isSuccess: false,
            apiResponse: null,
            error: e,
            stackTrace: s,
            isParsingError: true
        );
      }
    }
  }

  factory ApiResult.fromFailure(Object error , StackTrace stackTrace) {
    return ApiResult(apiResponse: null, error: error, isSuccess: false,stackTrace: stackTrace);
  }

  Map<String,dynamic> toMap(){
    return {
      'apiResponse' : apiResponse?.toMap(),
      'error' : error,
      'stackTrace' : stackTrace,
      'isParsingError' : isParsingError,
      'isSuccess' : isSuccess,
    };
  }
}
