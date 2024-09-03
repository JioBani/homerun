import 'package:homerun/Common/TimeFormatter.dart';
import 'package:homerun/Value/Region.dart';
import 'package:korean_profanity_filter/korean_profanity_filter.dart';

class UserInfoValidator{
  final TimeFormatter timeFormatter = TimeFormatter();

  final double maxProfileMbSize = 3;
  final int koreanNameMin = 2;
  final int koreanNameMax = 12;
  final int englishNameMin = 4;
  final int englishNameMax = 16;
  final int regionSelectMax = 3;


  /// 닉네임 체크
  ///
  /// [returns] : 유효성 검증에 성공하면 null을 반환합니다.
  /// 실패하면 오류 메세지를 반환합니다.
  String? checkNickName(String displayName){

    //#. 닉네임 길이 체크
    String? text = checkNickNameLength(displayName);
    if(text != null){
      return text;
    }

    //#. 닉네임 단어 체크
    if(displayName.containsBadWords){
      return "사용할 수 없는 닉네임 입니다.";
    }

    return null;
  }

  /// 닉네임 길이 체크 함수
  ///
  /// [returns] : 사용할 수 있는 닉네임인 경우 null을 반환합니다.
  /// 사용할 수 없는 닉네임인 경우 경고 메세지를 반환합니다.
  String? checkNickNameLength(String nickname){

    //#. 비어있는 경우
    if(nickname.isEmpty){
      return "닉네임을 입력해주세요.";
    }

    // 한글 패턴
    final koreanPattern = RegExp(r'[가-힣]');
    // 영문 패턴
    final englishPattern = RegExp(r'[a-zA-Z]');
    // 숫자 패턴
    final numberPattern = RegExp(r'[0-9]');

    bool hasKorean = koreanPattern.hasMatch(nickname);
    bool hasEnglish = englishPattern.hasMatch(nickname);
    bool hasNumber = numberPattern.hasMatch(nickname);


    int length = nickname.length;

    //#. 한글,영문,숫자만 포함
    if(!(hasNumber || hasKorean || hasEnglish)){
      return "닉네임에는 한글,영문,숫자만 포함될 수 있습니다.";
    }

    if(hasKorean){ //#. 한글 포함
      if(length < koreanNameMin){
        return "한글 닉네임은 $koreanNameMin글자 이상이어야 합니다.";
      }
      else if(length > koreanNameMax){
        return "한글 닉네임은 $koreanNameMax글자 이하이어야 합니다.";
      }
      else{
        return null;
      }
    }
    else{ //#. 영문과 숫자만
      if(length < englishNameMin){
        return "영문 또는 숫자 닉네임은 $englishNameMin글자 이상이어야 합니다.";
      }
      else if(length > englishNameMax){
        return "영문 또는 숫자 닉네임은 $englishNameMax글자 이하이어야 합니다.";
      }
      else{
        return null;
      }
    }
  }


  /// 생년월일 체크
  bool checkBirthText(String dateString){
    try{
      timeFormatter.datStringToTime(dateString);
      return true;
    }catch(e){
      return false;
    }
  }

  /// 관심지역 체크
  ///
  /// 선택된 관심지역의 개수가 0 ~ [regionSelectMax]인지 확인합니다.
  String? checkRegion(List<Region> regions){
    //#. 관심지역 선택 확인
    if(regions.isEmpty){
      return "관심 지역을 하나 이상\n선택해주세요";
    }

    //#. 관심지역 선택 초과 확인
    if(regions.length > regionSelectMax ){
      return "관심 지역은 3개 이하로\n선택해주세요";
    }

    return null;
  }

}