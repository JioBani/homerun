
import 'package:homerun/Common/StaticLogger.dart';
import 'package:http/http.dart';

import 'ApiResponse.dart';

class ApiResult<T>{

  final ApiResponse<T>? apiResponse;

  ///서버에서 에러가 발생한 경우 errors는 null 입니다.
  final Object? error;

  final StackTrace? stackTrace;

  /// ApiResponse 제작중 파싱 에러가 발생하였는지
  final bool parsingFailed;

  /// 성공여부
  /// statusCode와 통신 에러에 따라서 결정
  final bool isSuccess;

  ApiResult({required this.isSuccess,this.apiResponse, this.error,this.stackTrace ,this.parsingFailed = false});

  ///HTTP Request를 실행하고 결과를 ApiResult로 반환하는 함수
  static Future<ApiResult<T>> handleRequest<T>(Future<Response> request , {Duration timeout = const Duration(minutes: 1)}) async {
    //#. request 수행
    Response response;
    try{
      response = await request.timeout(timeout);
    }catch(e,s){ //#. request 실패시 실패 반환
      StaticLogger.logger.e("$e,$s");
      return ApiResult<T>.fromFailure(e,s,true);
    }

    //#. ApiResponse 및 ApiResult 생성
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
    catch(e , s){ //#. ApiResponse 제작중 예외 발생
      return ApiResult(
          isSuccess: response.statusCode == 200 || response.statusCode == 300,
          apiResponse: null,
          error: e,
          stackTrace: s,
          parsingFailed: true
      );
    }
  }

  factory ApiResult.fromFailure(Object error , StackTrace stackTrace , bool parsingFailed) {
    return ApiResult(apiResponse: null, error: error, isSuccess: false,stackTrace: stackTrace, parsingFailed : parsingFailed);
  }

  Map<String,dynamic> toMap(){
    return {
      'apiResponse' : apiResponse?.toMap(),
      'error' : error,
      'stackTrace' : stackTrace,
      'isParsingError' : parsingFailed,
      'isSuccess' : isSuccess,
    };
  }
}
