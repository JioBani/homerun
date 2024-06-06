/// Naver Map Geocoding API의 응답
class NaverMapGeocode {
  /// 검색 결과 상태 코드
  final String status;

  /// 검색 메타 데이터
  final Meta? meta;

  /// 주소 검색 결과 목록
  final List<Address>? addresses;

  /// 예외 발생 시 메시지
  final String? errorMessage;

  NaverMapGeocode({
    required this.status,
    this.meta,
    this.addresses,
    this.errorMessage,
  });

  factory NaverMapGeocode.fromMap(Map<String, dynamic> map) {
    return NaverMapGeocode(
      status: map['status'],
      meta: map['meta'] != null ? Meta.fromMap(map['meta']) : null,
      addresses: map['addresses'] != null
          ? List<Address>.from(map['addresses'].map((x) => Address.fromMap(x)))
          : null,
      errorMessage: map['errorMessage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'meta': meta?.toMap(),
      'addresses': addresses?.map((x) => x.toMap()).toList(),
      'errorMessage': errorMessage,
    };
  }
}

/// 검색 결과에 대한 메타 데이터
class Meta {
  /// 검색 결과 수
  final int? totalCount;

  /// 현재 페이지 번호
  final int? page;

  /// 페이지 내 결과 개수
  final int? count;

  Meta({
    this.totalCount,
    this.page,
    this.count,
  });

  factory Meta.fromMap(Map<String, dynamic> map) {
    return Meta(
      totalCount: map['totalCount'],
      page: map['page'],
      count: map['count'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalCount': totalCount,
      'page': page,
      'count': count,
    };
  }
}

/// 주소 검색 결과
class Address {
  /// 도로명 주소
  final String? roadAddress;

  /// 지번 주소
  final String? jibunAddress;

  /// 영어 주소
  final String? englishAddress;

  /// x 좌표(경도)
  final String? x;

  /// y 좌표(위도)
  final String? y;

  /// 검색 중심 좌표로부터의 거리(단위: 미터)
  final double? distance;

  /// 주소 요소
  final List<AddressElement>? addressElements;

  Address({
    this.roadAddress,
    this.jibunAddress,
    this.englishAddress,
    this.x,
    this.y,
    this.distance,
    this.addressElements,
  });

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      roadAddress: map['roadAddress'],
      jibunAddress: map['jibunAddress'],
      englishAddress: map['englishAddress'],
      x: map['x'],
      y: map['y'],
      distance: map['distance'],
      addressElements: map['addressElements'] != null
          ? List<AddressElement>.from(map['addressElements'].map((x) => AddressElement.fromMap(x)))
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'roadAddress': roadAddress,
      'jibunAddress': jibunAddress,
      'englishAddress': englishAddress,
      'x': x,
      'y': y,
      'distance': distance,
      'addressElements': addressElements?.map((x) => x.toMap()).toList(),
    };
  }
}

/// 주소의 요소
class AddressElement {
  /// 요소 유형 목록
  final List<String>? types;

  /// 전체 이름
  final String? longName;

  /// 축약 이름
  final String? shortName;

  /// 코드
  final String? code;

  AddressElement({
    this.types,
    this.longName,
    this.shortName,
    this.code,
  });

  factory AddressElement.fromMap(Map<String, dynamic> map) {
    return AddressElement(
      types: List<String>.from(map['types']),
      longName: map['longName'],
      shortName: map['shortName'],
      code: map['code'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'types': types,
      'longName': longName,
      'shortName': shortName,
      'code': code,
    };
  }
}
