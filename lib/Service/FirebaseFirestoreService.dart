import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Common/FirebaseFireStoreCache.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Model/AssessmentQuestion.dart';
import 'package:homerun/Model/NewsData.dart';
import 'package:homerun/Model/NotificationData.dart';

class FirebaseFirestoreService{

  final CollectionReference _notificationCollection = FirebaseFirestore.instance.collection('notification');

  final CollectionReference preSaleCollection = FirebaseFirestore.instance.collection('pre_sale');
  final CollectionReference assessmentCollection = FirebaseFirestore.instance.collection('assessment');
  final CollectionReference _newsCollection = FirebaseFirestore.instance.collection('news');

  static FirebaseFirestoreService? _instance;

  FirebaseFirestoreService._();

  static FirebaseFirestoreService get instance {
    // 이미 인스턴스가 생성된 경우, 해당 인스턴스를 반환합니다.
    _instance ??= FirebaseFirestoreService._();
    return _instance!;
  }

  Future<List<NotificationData>> getNotificationData() async {
    try{
      final snapshot = await _notificationCollection.get();

      List<NotificationData> dataList = [];


      for (var element in snapshot.docs) {
        dataList.add(NotificationData.fromMap(element.data() as Map<String, dynamic>));
      }

      return dataList;

    }catch(e){
      StaticLogger.logger.e(e);
      return [];
    }
  }

  Future<void> addPreSaleData() async {
    // 업로드할 데이터를 맵 형식으로 생성합니다.
    Map<String, dynamic> data = {
      'generate': Timestamp.now(),
      'name': Timestamp.now().toString(),
    };

    var list = generateTestData();

    list.forEach((element) async {
      await preSaleCollection.add(element)
          .then((value) => StaticLogger.logger.i("Data added to Firestore"))
          .catchError((error) => StaticLogger.logger.e("Error adding data: $error"));
    });

    // Firestore에 데이터를 추가합니다.

  }

  String getRandomRegion() {
    final List<String> regions = [
      '서울',
      '경기',
      '인천',
      '부산',
      '대전',
      '대구',
      '울산',
      '세종',
      '광주',
      '강원',
      '충북',
      '충남',
      '경북',
      '경남',
      '전북',
      '전남',
      '제주',
      // 필요한 만큼 시 이름을 추가하세요.
    ];
    final Random random = Random();
    return regions[random.nextInt(regions.length)];
  }

  String getRandomApartName(){
    final List<String> aptNames = [
      '래미안퍼스티지',
      '아이파크 서울',
      '파크리오 아파트',
      '아크로리버뷰',
      '더샵포레스트',
      '롯데캐슬 아름아파트',
      '갤러리아포레스트',
      '푸르지오 아파트',
      '아크로스리버파크',
      '래미안 오투웨이',
      '그랜드 밀레니움',
      '퍼스트하우스',
      '팰리스 어메니티',
      '퍼스트팰리스',
      '골든빌라',
      '에비뉴 서울',
      '그랜드 메트로',
      '메이저 리젠트',
      '로얄팰리스',
      '프라임 리버뷰',
      '하이어스 아파트',
      '코지움 빌라',
      '대림로즈빌',
      '프리미어팰리스',
      '클래식빌라',
      '그린빌라',
      '힐빌라',
      '메이저 하우스',
      '그린팰리스',
      '리버뷰 트윈',
      '한강뷰 자이',
      '래미안 하이리버',
      '메트로빌',
      '이스트빌라',
      '한남더힐',
      '리버그린',
      '드림하우스',
      '아이파크 서래',
      '로얄맨션',
      '하이펙스',
      '브라운스톤',
      '그린캐슬',
      '타워팰리스',
      '압구정더블유',
      '메이플하우스',
      '럭셔리포레스트',
      '마르세유',
      '센트럴플레이스',
      '라테라스',
    ];
    final Random random = Random();
    return aptNames[random.nextInt(aptNames.length)];
  }

  String getRandomCategory(){
    final List<String> categories = [
      '분양중',
      '분양예정',
      '분양완료'
    ];
    final Random random = Random();
    return categories[random.nextInt(categories.length)];
  }

  List<Map<String, dynamic>> generateTestData() {
    final List<Map<String, dynamic>> testData = [];


    final DateTime startDate = DateTime(2023, 1, 1);
    final DateTime endDate = DateTime(2023, 10, 31);

    DateTime announcementDate = startDate;
    int index = 0;

    while (announcementDate.isBefore(endDate) || announcementDate.isAtSameMomentAs(endDate)) {
      final String region = getRandomRegion(); // getRandomRegion() 함수는 필요에 따라 구현하십시오.
      final String aptName = getRandomApartName();
      final String category = getRandomCategory();
      final String fullName = '$region $aptName';

      final Map<String, dynamic> data = {
        'generate': DateTime.now(),
        'index': index,
        'name': fullName,
        'region': region,
        'category' : category,
        'announcement_date': announcementDate,
        'survey_list' : [
          {
            'question' : "성별은 무엇입니까?",
            'answers' : [
              {
                'answer' : '남자',
                'result' : 10
              },
              {
                'answer' : '여자',
                'result' : 20
              },
            ]
          },
          {
            'question' : "나이는 몇살입니까??",
            'answers' : [
              {
                'answer' : '18-40',
                'result' : 10
              },
              {
                'answer' : '40 이상',
                'result' : 20
              },
            ]
          },
          {
            'question' : "좋아하는 색깔은 무엇입니까?",
            'answers' : [
              {
                'answer' : '빨강',
                'result' : 10
              },
              {
                'answer' : '파랑',
                'result' : 20
              },
              {
                'answer' : '노랑',
                'result' : 20
              },
              {
                'answer' : '초록',
                'result' : 20
              },
            ]
          },
          {
            'question' : "현재 직업은 무엇입니까?",
            'answers' : [
              {
                'answer' : '학생',
                'result' : 10
              },
              {
                'answer' : '직장인',
                'result' : 20
              },
              {
                'answer' : '자영업',
                'result' : 20
              },
              {
                'answer' : '무직',
                'result' : 20
              },
            ]
          },
        ]
      };
      testData.add(data);

      announcementDate = announcementDate.add(Duration(days: 1)); // 다음 날짜로 이동
      index++;
    }

    return testData;
  }

  Future<List<DocumentSnapshot>> getNextNDocuments(DocumentSnapshot? current, int n) async {
    if(current == null){
      QuerySnapshot querySnapshot = await preSaleCollection
          .orderBy("generate")
          .limit(n)
          .getSavy();
      return querySnapshot.docs;

    }
    else{
      QuerySnapshot querySnapshot = await preSaleCollection
          .orderBy("generate")
          .startAfterDocument(current)
          .limit(n)
          .getSavy();
      return querySnapshot.docs;
    }
  }

  Future<QuerySnapshot?> getHousingData(String category,String regional,DocumentSnapshot? start ,int count)async{
    try{
      if(start == null){
        QuerySnapshot querySnapshot = await preSaleCollection
            .orderBy("announcement_date")
            .where("region" ,isEqualTo:regional )
            .limit(count)
            .getSavy();

        return querySnapshot;
      }
      else{
        QuerySnapshot querySnapshot = await preSaleCollection
            .orderBy("announcement_date")
            .where("region" ,isEqualTo:regional )
            .startAfterDocument(start)
            .limit(count)
            .getSavy();

        return querySnapshot;
      }
    }catch(e , s){
      StaticLogger.logger.e("[FirebaseFirestoreService.getHousingData()] $e\n$s");
      return null;
    }

  }

  Stream<QuerySnapshot> getDataStream() {
    return preSaleCollection.orderBy('announcement_date').snapshots();
  }

  Stream<QuerySnapshot> getSurveyData() {
    return preSaleCollection.orderBy('announcement_date').snapshots();
  }

  Future<void> uploadAssessment()async {
    try{
      await assessmentCollection.add(AssessmentDto(assessmentList: questions, version: "1.0").toMap());
      StaticLogger.logger.i("[uploadAssessment] 업로드 완료");
    }catch(e , s){
      StaticLogger.logger.e("[uploadAssessment] 업로드 실패 $e , $s");
    }
  }

  Future<AssessmentDto?> getAssessmentDto() async {
    try {
      QuerySnapshot querySnapshot = await assessmentCollection.get();
      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        return AssessmentDto.fromMap(data);
      } else {
        return null;
      }
    } catch (e, s) {
      StaticLogger.logger.e("[getAssessmentDto] 데이터 가져오기 실패 $e , $s");
      return null;
    }
  }

  Future<List<NewsData>?> getNewsList()async{
    try {
      QuerySnapshot querySnapshot = await _newsCollection.get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.map((doc) => NewsData.fromMap(doc.id , doc.data() as Map<String, dynamic>)).toList();
      } else {
        return null;
      }
    } catch (e, s) {
      StaticLogger.logger.e("[FirebaseFirestoreService.getNewsList()] 데이터 가져오기 실패 $e , $s");
      return null;
    }
  }
}

List<Assessment> questions = [
  Assessment( //#.0
      question: "현재 혼인 상태가 어떻게 되나요?",
      answers: [
        AssessmentAnswer(answer: "혼인 중이 아님(이혼 포함)" , index: 0),
        AssessmentAnswer(answer: "1년 이내에 혼인할 예정", index: 1),
        AssessmentAnswer(answer: "혼인 한지 7년 이내", index: 2),
        AssessmentAnswer(answer: "혼인 한지 7년 초과", index: 3),
      ]
  ),
  Assessment( //#.1
      question: "자녀가 있나요?",
      answers: [
        AssessmentAnswer(answer: "있음",index: 0),
        AssessmentAnswer(answer: "없음" , index: 1, goto: 4),
      ]
  ),
  Assessment( //#.2
      question: "19세 미만인 자녀가 3명 이상 인가요?",
      answers: [
        AssessmentAnswer(answer: "3명 이상임", index: 0),
        AssessmentAnswer(answer: "아님", index: 1),
      ]
  ),
  Assessment( //#.3
      question: "만 7세 미만인 자녀가 있나요?",
      answers: [
        AssessmentAnswer(answer: "있음", index: 0),
        AssessmentAnswer(answer: "없음", index: 1),
      ]
  ),
  Assessment( //#.4
      question: "테스트",
      answers: [
        AssessmentAnswer(answer: "있음", index: 0),
        AssessmentAnswer(answer: "없음", index: 1),
      ]
  ),
  Assessment( //#.4
      question: "테스트1",
      answers: [
        AssessmentAnswer(answer: "있음", index: 0),
        AssessmentAnswer(answer: "없음", index: 1),
      ]
  ),
  Assessment( //#.4
      question: "테스트2",
      answers: [
        AssessmentAnswer(answer: "있음", index: 0),
        AssessmentAnswer(answer: "없음", index: 1),
      ]
  ),
];