import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Page/AnnouncementPage/Model/Announcement.dart';
import 'package:homerun/Page/AnnouncementPage/Value/AnnouncementDtoFields.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class AnnouncementPageController{
  
  CollectionReference announcementCollection = FirebaseFirestore.instance.collection('announcement');
  final int loadingNumber = 2;

  List<Announcement> announcementList = [];
  final PagingController<int, Announcement> pagingController = PagingController(firstPageKey: 0);

  AnnouncementPageController(){
    pagingController.addPageRequestListener((pageKey) {
      loadAnnouncements(pageKey);
    });
  }

  Future<void> loadAnnouncements(int pageKey) async {
    Query query = announcementCollection.orderBy(AnnouncementDtoFields.date ,descending: true);

    if(announcementList.isNotEmpty){
      query = query.startAfterDocument(announcementList.first.documentSnapshot);
    }

    query = query.limit(loadingNumber);

    try{
      List<Announcement> newList = Announcement.makeList(await query.get());

      if(newList.length != loadingNumber){
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