import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Common/Firebase/FirestorePagination.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Model/Assessment/AssessmentQuestion.dart';
import 'package:homerun/Model/Assessment/Condition.dart';
import 'package:homerun/Model/Assessment/Conditioninfo.dart';
import 'package:homerun/Model/NewsData.dart';
import 'package:homerun/Model/NotificationData.dart';
import 'package:homerun/Service/Auth/UserDto.dart';
import 'package:homerun/Vocabulary/VocabularyList.dart';

//TODO
// 에러처리 일원화
// 주석달기

class FirebaseFirestoreService{

  static String cacheField = "updateAt";

  //#. 공지사항
  final FirestorePagination _notificationPagination = FirestorePagination(
      collectionReference: FirebaseFirestore.instance.collection('notification'),
      query: FirebaseFirestore.instance.collection('notification'),
      pagingInterval: Duration(days: 5),
      start: DateTime(2100,1,1,0),
      pagingField: 'time',
      descending: true
  );

  //#. 청약길잡이
  final CollectionReference _guidePostCollection = FirebaseFirestore.instance.collection('guide');
  final Map<String , FirestorePagination> _guidePaginationWithType = Map();


  //#. 분양공고
  final CollectionReference _housingDataCollection = FirebaseFirestore.instance.collection('pre_sale');
  final Map<String , Map<String , FirestorePagination>> _housingPagination = Map();


  //#. 청약뉴스
  final CollectionReference _newsCollection = FirebaseFirestore.instance.collection('news');

  //#. 청약기본자격
  final CollectionReference _assessmentCollection =
    FirebaseFirestore.instance.collection('assessment').doc('assessments').collection('data');
  final CollectionReference _conditionCollection =
    FirebaseFirestore.instance.collection('assessment').doc('conditions').collection('data');

  //#. 유저
  final CollectionReference _userCollection = FirebaseFirestore.instance.collection('users');


  static FirebaseFirestoreService? _instance;

  static FirebaseFirestoreService get instance {
    _instance ??= FirebaseFirestoreService._();
    
    return _instance!;
  }

  FirebaseFirestoreService._(){

    //#. 청약길잡이
    for (var type in Vocabulary.specialType) {
      _guidePaginationWithType[type] = FirestorePagination(
          collectionReference: FirebaseFirestore.instance.collection('guide'),
          query: FirebaseFirestore.instance.collection('guide').where('category' , isEqualTo: type),
          pagingInterval: Duration(days: 5),
          start: DateTime(2100,1,1,0),
          pagingField: 'updateAt',
          descending: true
      );
    }


    //#. 분양공고
    for(var state in Vocabulary.housingState){
      Map<String , FirestorePagination> map = Map();
      for(var region in Vocabulary.regions){
        map[region] = FirestorePagination(
            collectionReference: FirebaseFirestore.instance.collection('pre_sale'),
            query: FirebaseFirestore.instance.collection('pre_sale')
                  .where('category' , isEqualTo: state)
                  .where('region' , isEqualTo: region),
            pagingInterval: Duration(days: 5),
            start: DateTime(2100,1,1,0),
            pagingField: 'announcement_date',
            descending: true
        );
      }
      _housingPagination[state] = map;
    }


    //#. 청약뉴스


    //#. 청약뉴스

  }

  static void init(){
    _instance ??= FirebaseFirestoreService._();
  }

  //#. 유저
  Future<Result<UserDto>> getUser(String uid) async {
    try{
      DocumentSnapshot documentSnapshot = await _userCollection.doc(uid).get();

      if(documentSnapshot.data() == null){
        throw Exception('유저가 존재하지 않음 : $uid');
      }
      return Result<UserDto>.fromSuccess(result: UserDto.fromMap(documentSnapshot.data() as Map<String , dynamic>));
    }catch(e , s){
      StaticLogger.logger.e('[FirebaseFirestoreService.getUser()] $e\n$s');
      return Result.fromFailure(e, s);
    }
  }


  //#. 일반
  Future<List<NotificationData>?> getNotificationData(int n) async {
    try{
      final snapshots = await _notificationPagination.get(5);

      return snapshots!.map((element) => NotificationData.fromMap(element.data() as Map<String, dynamic>)).toList();

    }catch(e){
      StaticLogger.logger.e(e);
      return null;
    }
  }


  //#. 청약길잡이
  Future<List<DocumentSnapshot>?> getGuidePostData(String category,DocumentSnapshot? start ,int count)async{
    try{
      return _guidePaginationWithType[category]?.get(count);
    }catch(e , s){
      StaticLogger.logger.e("[FirebaseFirestoreService.getGuidePostData()] $e\n$s");
      return null;
    }
  }

  //#. 청약자격진단
  Future<AssessmentDto?> getAssessmentDto() async {
    // 컬렉션의 크기가 크지 않기 떄문에 get으로 가져오는것으로 설정
    try {
      QuerySnapshot querySnapshot = await _assessmentCollection.get();
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

  Future<List<ConditionInfo>?> getConditionInfoList() async {
    // 컬렉션의 크기가 크지 않기 떄문에 get으로 가져오는것으로 설정
    try {
      QuerySnapshot querySnapshot = await _conditionCollection.get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.map((doc) => ConditionInfo.fromMap(doc.data() as Map<String , dynamic>)).toList();
      } else {
        return null;
      }
    } catch (e, s) {
      StaticLogger.logger.e("[getAssessmentDto] 데이터 가져오기 실패 $e , $s");
      return null;
    }
  }


  //#. 분양정보
  Future<List<DocumentSnapshot>?> getHousingData(String category,String regional,DocumentSnapshot? start ,int count)async{
    try{
      if(!_housingPagination.containsKey(category)){
        throw Exception('$category가 데이터에 없음');
      }

      if(start == null){
        return _housingPagination[category]![regional]!.get(count);
      }
      else{
        return _housingPagination[category]![regional]!.getAfter(count , start);
      }
    }catch(e , s){
      StaticLogger.logger.e("[FirebaseFirestoreService.getHousingData()] $e\n$s");
      return null;
    }
  }

  //#. 청약뉴스
  Future<List<NewsData>?> getNewsList()async{
    //TODO 청약 뉴스 페이지 만들면서 페이지내이션을 사용해서 가져오도록 변경하기

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



  /*Future<void> addPreSaleData() async {
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

  }*/

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
}