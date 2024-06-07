import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:homerun/Model/NaverMap/NaverMapGeoCode.dart';

class NaverGeocodeService {
  late String? _clientId;
  late String? _clientSecret;

  NaverGeocodeService._();

  static NaverGeocodeService? _instance;

  static NaverGeocodeService get instance {
    _instance ??= NaverGeocodeService._();
    return _instance!;
  }

  static NaverGeocodeService getInstanceWithInit(String clientId, String clientSecret){
    _instance ??= NaverGeocodeService._();
    _instance!.init(clientId, clientSecret);
    return _instance!;
  }

  NaverGeocodeService init(String clientId, String clientSecret){
    _clientId = clientId;
    _clientSecret = clientSecret;
    return this;
  }

  Future<NaverMapGeocode> fetchGeocode(String query, {String? coordinate}) async {

    if(_clientId == null){
      throw Exception('client id is not initialized');
    }

    if(_clientSecret == null){
      throw Exception('client id is not initialized');
    }

    final uri = Uri.https('naveropenapi.apigw.ntruss.com', '/map-geocode/v2/geocode', {
      'query': query,
      if (coordinate != null) 'coordinate': coordinate,
    });

    final response = await http.get(
      uri,
      headers: {
        'X-NCP-APIGW-API-KEY-ID': _clientId!,
        'X-NCP-APIGW-API-KEY': _clientSecret!,
      },
    );

    if (response.statusCode == 200) {
      return NaverMapGeocode.fromMap(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch geocode data');
    }
  }
}
