import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class FirebaseAuthRemoteDataSource {
  final String url = "http://10.0.2.2:5000";

  Future<String> createCustomToken(Map<String, dynamic> user) async {
    final customTokenResponse = await http
        .post(Uri.parse(url), body: user).timeout(const Duration(seconds: 2));

    Logger().i(customTokenResponse.body);

    return customTokenResponse.body;
  }

  Future<String> tokenTest(Map<String, dynamic> user) async {
    try{
      final customTokenResponse = await http
          .post(Uri.parse(url), body: user).timeout(const Duration(seconds: 2));
      return customTokenResponse.body;
    }
    on TimeoutException catch(e){
      Logger().e(e);
      return "false";
    }
  }
}