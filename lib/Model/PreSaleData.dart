
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:intl/intl.dart';

class PreSaleData{
  final String name;
  final String imageUrl;
  final String region;
  final String category;
  final Timestamp? announcementDateTimeStamp;
  late final DateTime? announcementDateDateTime;

  PreSaleData({
    required this.name,
    required this.announcementDateTimeStamp,
    required this.category,
    required this.region,
    required this.imageUrl,
  }
  ){

    if(announcementDateTimeStamp != null) {
      announcementDateDateTime = announcementDateTimeStamp!.toDate();
    }
    else{
      announcementDateDateTime = null;
    }
  }

  String getDateString(){
    if(announcementDateDateTime != null){
      return DateFormat('yyyy-MM-dd').format(announcementDateDateTime!);

    }
    else{
      return "정보없음";
    }
  }

  void Print(){
    StaticLogger.logger.i("$name , ${getDateString()}");
  }

  factory PreSaleData.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    String? name;
    Timestamp? announcementDate;
    String? region;
    String? category;

    try{
      name = documentSnapshot['name'];
      announcementDate = documentSnapshot['announcement_date'];
      region = documentSnapshot['region'];
      category = documentSnapshot['category'];

      return PreSaleData(
          name : name ?? "없음",
          announcementDateTimeStamp : announcementDate,
          category : category ?? "없음",
          region : region ?? "없음",
          imageUrl : "assets/images/Ahri_15.jpg"
      );
    }
    catch(e){
      return PreSaleData(
          name : name ?? "없음",
          announcementDateTimeStamp : announcementDate,
          category : category ?? "없음",
          region : region ?? "없음",
          imageUrl : "assets/images/Ahri_15.jpg"
      );
    }

  }

 /* static List<PreSaleData> getTestDataList(){
    return [
      PreSaleData(DateTime.now() , DateTime.now() , "assets/images/Ahri_15.jpg"),
      PreSaleData(DateTime.now() , DateTime.now() , "assets/images/Ahri_15.jpg"),
      PreSaleData(DateTime.now() , DateTime.now() , "assets/images/Ahri_15.jpg"),
      PreSaleData(DateTime.now() , DateTime.now() , "assets/images/Ahri_15.jpg"),
      PreSaleData(DateTime.now() , DateTime.now() , "assets/images/Ahri_15.jpg"),
      PreSaleData(DateTime.now() , DateTime.now() , "assets/images/Ahri_15.jpg"),
      PreSaleData(DateTime.now() , DateTime.now() , "assets/images/Ahri_15.jpg"),
      PreSaleData(DateTime.now() , DateTime.now() , "assets/images/Ahri_15.jpg"),
      PreSaleData(DateTime.now() , DateTime.now() , "assets/images/Ahri_15.jpg"),
      PreSaleData(DateTime.now() , DateTime.now() , "assets/images/Ahri_15.jpg"),
      PreSaleData(DateTime.now() , DateTime.now() , "assets/images/Ahri_15.jpg"),
      PreSaleData(DateTime.now() , DateTime.now() , "assets/images/Ahri_15.jpg"),
      PreSaleData(DateTime.now() , DateTime.now() , "assets/images/Ahri_15.jpg"),
      PreSaleData(DateTime.now() , DateTime.now() , "assets/images/Ahri_15.jpg"),
    ];
  }*/

  /*static PreSaleData getTestData(){
    return PreSaleData(DateTime.now() , DateTime.now() , "assets/images/Ahri_15.jpg");
  }*/
}