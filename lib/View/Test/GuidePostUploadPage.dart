import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Model/GuidePostData.dart';

class GuidePostUploadPage extends StatelessWidget {
  GuidePostUploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: (){
                    uploadTestData();
                  },
                  child: Text("데이터 업로드 하기")
              )
            ],
          ),
        ),
      ),
    );
  }

  final CollectionReference _guidePostCollection = FirebaseFirestore.instance.collection('guide');

  Future<void> uploadGuidePostData(GuidePostData data) async {
    try {
      await _guidePostCollection.add(data.toMap());
      StaticLogger.logger.i("[FirebaseFirestoreService.uploadGuidePostData()] 데이터 업로드 성공");
    } catch (e, s) {
      StaticLogger.logger.e("[FirebaseFirestoreService.uploadGuidePostData()] 데이터 업로드 실패: $e\n$s");
    }
  }

  GuidePostData createTestGuidePostData(String category , int index) {
    final Map<String, List<String>> titles = {
      '신혼부부': [
        '신혼부부 특별공급 신청자격은?',
        '신혼부부를 위한 주택정책 총정리',
        '신혼부부 주거 지원 프로그램 안내',
        '신혼부부가 알아야 할 주택 혜택',
        '신혼집 마련을 위한 가이드'
      ],
      '청년': [
        '청년 맞춤형 임대주택 신청 방법',
        '청년을 위한 주거 지원 서비스 전체보기',
        '청년의 첫 주택 구매 가이드',
        '청년 주거 문제, 해결 방안은?',
        '청년을 위한 주택 혜택 총정리'
      ],
      '다자녀': [
        '다자녀 가정의 주택 혜택 안내',
        '우리 가족에게 맞는 주택 혜택 찾기',
        '다자녀 가정을 위한 정부 지원 프로그램',
        '다자녀 가정의 주거 안정 지원',
        '다자녀 가정 주택 구입 팁'
      ],
      '노부모': [
        '노부모 부양 가구를 위한 주택 지원 프로그램',
        '노부모와 함께 사는 가구를 위한 정부 지원',
        '노부모 돌봄 가구의 주택 혜택',
        '노부모를 모시고 사는 가정의 주거 해결책',
        '노부모와 함께하는 가정의 주택 가이드'
      ],
      '생애최초': [
        '생애 최초 주택 구입자를 위한 가이드',
        '첫 주택 구매자를 위한 준비 사항',
        '생애최초 주택 구매자의 혜택',
        '생애 첫 주택 구입, 무엇을 준비해야 하나',
        '생애최초 구매자를 위한 주택 구입 팁'
      ],
      '기관추천': [
        '기관 추천을 통한 특별 주택 공급 정보',
        '기관 추천 받기 위한 필수 조건',
        '기관 추천 주택 프로그램의 이해',
        '특별공급 주택, 기관 추천이란?',
        '기관 추천으로 내 집 마련하기'
      ]
    };

    final Map<String, List<String>> subTitles = {
      '신혼부부': [
        '5가지 기본자격을 확인해보세요.',
        '신혼부부를 위한 정부 지원 사업',
        '신혼부부 주거 안정화 방안',
        '신혼부부가 받을 수 있는 주택 혜택',
        '신혼집 마련, 어떻게 시작해야 할까?'
      ],
      // 각 카테고리에 대한 부제목도 동일하게 설정합니다.
      // 청년, 다자녀, 노부모, 생애최초, 기관추천에 대한 부제목을 여기에 추가하세요.
      '청년': [
        '청년 주거 안정을 위한 첫걸음',
        '청년들의 주거 문제, 어떻게 해결할까?',
        '청년을 위한 주택 구매 가이드',
        '청년이 알아야 할 주택 혜택 모음',
        '청년의 주거 고민을 해결해주는 팁'
      ],
      // 다른 카테고리들에 대한 부제목들을 이와 같은 방식으로 추가합니다.
      // 해당 예시에서는 간결함을 위해 '청년' 카테고리의 부제목만 추가하였습니다.
    };


    // 주어진 카테고리에 해당하는 제목과 부제목을 랜덤으로 선택합니다.

    return GuidePostData(
      category: category,
      title: titles[category]![index],
      subTitle: titles[category]![index],
      thumbnailImagePath: 'guide/${index + 1}.jpg',
      postPdfPath: 'guide/${index + 1 + 1}.pdf',
    );
  }

  Future<void> uploadTestData()async{
    List<GuidePostData> datas = [];

    List<String> category = [
      "청년",
      "신혼부부",
      "기관추천",
      "생애최초",
      "노부모",
      "다자녀",
    ];

    for (var value in category) {
      for(int i = 0; i< 4; i++){
        datas.add(createTestGuidePostData(value , i));
      }
    }
    
    await Future.wait(datas.map((e) => uploadGuidePostData(e)));

    StaticLogger.logger.i("업로드 완료");
  }

}

