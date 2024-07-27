import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Service/Auth/ApiResponse.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:http/http.dart' as http;

class FirebaseFunctionsService{
  static Future<Result<T>> call<T>(
    String url,
    Map<String , dynamic> body,
   {
     bool needAuth = false,
     Duration? timeOut
   }
  ){
    return Result.handleFuture<T>(action: () async {

      late final http.Response response;

      if(needAuth){
        String? idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

        if(idToken == null){
          throw ApplicationUnauthorizedException();
        }

        response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $idToken',
          },
          body: jsonEncode(body),
        ).timeout(timeOut ?? const Duration(seconds: 30));
    }
      else{
        response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body),
        ).timeout(timeOut ?? const Duration(seconds: 30));
      }

      ApiResponse apiResponse = ApiResponse.fromMap(jsonDecode(response.body));

      StaticLogger.logger.i(response.body);

      if(apiResponse.status == 200 || apiResponse.status == 300){
        return apiResponse.data;
      }
      else{
        throw apiResponse.error!;
      }
    });
  }
}