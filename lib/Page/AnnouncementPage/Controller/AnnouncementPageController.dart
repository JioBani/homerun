import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Page/AnnouncementPage/Model/Announcement.dart';
import 'package:homerun/Page/AnnouncementPage/Value/AnnouncementDtoFields.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class AnnouncementPageController{
  
  CollectionReference announcementCollection = FirebaseFirestore.instance.collection('announcement');

  /// 한번에 불러올 공지사항 수
  final int loadingNumber = 10;

  /// 공지사항 리스트
  List<Announcement> announcementList = [];
  
  /// 페이지 컨트롤러
  final PagingController<int, Announcement> pagingController = PagingController(firstPageKey: 0);

  AnnouncementPageController(){
    pagingController.addPageRequestListener((pageKey) {
      loadAnnouncements(pageKey);
    });
  }

  /// 공지사항 불러오기
  Future<void> loadAnnouncements(int pageKey) async {
    
    //#. 날짜순
    Query query = announcementCollection.orderBy(AnnouncementDtoFields.date ,descending: true);

    //#. 불러 온 공지사항이 있으면, 그 공지사항 이후로
    if(announcementList.isNotEmpty){
      query = query.startAfterDocument(announcementList.last.documentSnapshot);
    }

    //#. 불러올 개수 설정
    query = query.limit(loadingNumber);

    try{
      List<Announcement> newList = Announcement.makeList(await query.get());

      if(newList.length != loadingNumber){
        //#. 요청 한 것 보다 적게 왔으면 noMoreData
        pagingController.appendLastPage(newList);
      }
      else{
        pagingController.appendPage(newList, pageKey + newList.length);
      }
      announcementList.addAll(newList);

    }catch(e,s){
      StaticLogger.logger.e("$e\n$s");
      pagingController.error = e;
    }
  }
}