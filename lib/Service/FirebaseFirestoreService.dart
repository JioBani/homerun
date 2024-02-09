
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Common/FirebaseFireStoreCache.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Model/NotificationData.dart';
import 'package:homerun/Model/TestData.dart';

class FirebaseFirestoreService{

  final CollectionReference _notificationCollection = FirebaseFirestore.instance.collection('notification');

  final CollectionReference preSaleCollection = FirebaseFirestore.instance.collection('pre_sale');

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
    // Firestore 인스턴스를 초기화합니다.

    // 지정한 컬렉션에서 문서를 가져옵니다.

    // 다음 n개의 문서를 가져오기 위해 쿼리를 생성합니다.

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



    // 쿼리 결과에서 다음 n개의 문서를 가져옵니다.
  }


  Stream<QuerySnapshot> getDataStream() {
    return preSaleCollection.orderBy('announcement_date').snapshots();
  }

  Stream<QuerySnapshot> getSurveyData() {
    return preSaleCollection.orderBy('announcement_date').snapshots();
  }



  void t(){
    preSaleCollection.snapshots().listen((event) {

    });
  }
}