import 'dart:convert';

import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Service/APTAnnouncementApiService/APTAnnouncement.dart';
import 'package:homerun/Service/APTAnnouncementApiService/Security/ServiceKey.dart';
import 'package:http/http.dart' as http;

/**
 * 한국부동산원 '청약홈'에서 제공하는 분양정보 조회 서비스중 아파트 분양정보 상세조회 API를 관리하는 서비스
 */
class APTAnnouncementApiService{


  Future<List<APTAnnouncement>> getApi() async {
    final response = await http.get(
      Uri.parse(
          "https://api.odcloud.kr/api/ApplyhomeInfoDetailSvc/v1/getAPTLttotPblancDetail?page=1&perPage=10&serviceKey=$serviceKey"
      )
    );

    (jsonDecode(response.body)['data'] as List<dynamic>).forEach((element) {
      StaticLogger.logger.i(element);
      StaticLogger.logger.i(APTAnnouncement.fromMap(element).toMap());
    });

    return (jsonDecode(response.body)['data'] as List<dynamic>).map(
            (e) => APTAnnouncement.fromMap(e)
    ).toList();
  }

  Future<List<APTAnnouncement>> getAPT(int page, int perPage) async {
    final response = await http.get(
        Uri.parse(
            "https://api.odcloud.kr/api/ApplyhomeInfoDetailSvc/v1/getAPTLttotPblancDetail?page=$page&perPage=$perPage&cond%5BRCRIT_PBLANC_DE%3A%3AGTE%5D=2022-01-01&&serviceKey=$serviceKey"
        )
    );

    return (jsonDecode(response.body)['data'] as List<dynamic>).map(
            (e) => APTAnnouncement.fromMap(e)
    ).toList();
  }

}