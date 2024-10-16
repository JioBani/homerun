import '../Value/ApplyHomeDtoFields.dart';
import 'AptBasicInfo.dart';
import 'AptDetailsInfo.dart';
import '../Value/SupplyMethod.dart';

/// ApplyHomeDto 클래스는 청약 정보와 그에 따른 세부 정보를 포함합니다.
class ApplyHomeDto{
  /// 기본 청약 정보 (AptBasicInfo)
  AptBasicInfo? aptBasicInfo;

  /// 청약 상세 정보 목록 (AptDetailsInfo) - null 가능
  List<AptDetailsInfo?>? detailsList;

  /// 특별 공급 전체 세대수 (특별 공급이 없는 경우 -1, 데이터 오류 시 null)
  int? totalSpecialSupplyHouseholds;

  /// 일반 공급 전체 세대수 (일반 공급이 없는 경우 -1, 데이터 오류 시 null)
  int? totalGeneralSupplyHouseholds;

  /// 최대 공급 금액 (단위: 만원)
  int? maxSupplyPrice;

  /// 최소 공급 금액 (단위: 만원)
  int? minSupplyPrice;

  /// 공급 규모 오류 여부 (공시되지 않은 정보가 있거나, 합계 오류 시 true)
  bool hasSupplyHouseholdsCountError;

  /// 생성자
  ApplyHomeDto({
    required this.aptBasicInfo,
    this.detailsList,
    this.totalSpecialSupplyHouseholds,
    this.totalGeneralSupplyHouseholds,
    this.maxSupplyPrice,
    this.minSupplyPrice,
    required this.hasSupplyHouseholdsCountError,
  });

  /// 주어진 객체로부터 ApplyHomeDto 객체를 생성합니다.
  /// @param map 객체로부터 데이터를 읽어와서 ApplyHomeDto 인스턴스를 생성합니다.
  /// @returns ApplyHomeDto 인스턴스
  factory ApplyHomeDto.fromMap(Map<String, dynamic> map , SupplyMethod supplyMethod) {
    return ApplyHomeDto(
      aptBasicInfo: AptBasicInfo.fromMap(map[ApplyHomeDtoFields.basicInfo]),
      detailsList: (map[ApplyHomeDtoFields.detailsList] as List<dynamic>?)!.map((e) => AptDetailsInfo.fromMap(e)).toList(),
      totalSpecialSupplyHouseholds: map[ApplyHomeDtoFields.totalSpecialSupplyHouseholds] as int?,
      totalGeneralSupplyHouseholds: map[ApplyHomeDtoFields.totalGeneralSupplyHouseholds] as int?,
      maxSupplyPrice: map[ApplyHomeDtoFields.maxSupplyPrice] as int?,
      minSupplyPrice: map[ApplyHomeDtoFields.minSupplyPrice] as int?,
      hasSupplyHouseholdsCountError: map[ApplyHomeDtoFields.hasSupplyHouseholdsCountError] as bool,
    );
  }
}