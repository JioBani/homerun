
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:intl/intl.dart';

import 'SurveyData.dart';

class PreSaleData{
  final String name;
  final String imageUrl;
  final String region;
  final String category;
  final Timestamp? announcementDateTimeStamp;
  late final DateTime? announcementDateDateTime;
  final SurveyData? surveyData;

  PreSaleData({
    required this.name,
    required this.announcementDateTimeStamp,
    required this.category,
    required this.region,
    required this.imageUrl,
    required this.surveyData
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
    SurveyData? surveyData;

    try{
      name = documentSnapshot['name'];
      announcementDate = documentSnapshot['announcement_date'];
      region = documentSnapshot['region'];
      category = documentSnapshot['category'];
      //surveyData = SurveyData.fromMap(List<Map<String ,dynamic>>.from(jsonDecode(documentSnapshot['survey_list'])));
      surveyData = SurveyData.fromMap(documentSnapshot['survey_list']);


      return PreSaleData(
        name : name ?? "없음",
        announcementDateTimeStamp : announcementDate,
        category : category ?? "없음",
        region : region ?? "없음",
        imageUrl : "https://firebasestorage.googleapis.com/v0/b/homerun-3e122.appspot.com/o/images%2Fhome_temp.jpg?alt=media&token=d5d48d69-8bc5-45d3-ada3-9ad685d95705",
        surveyData: surveyData
      );
    }
    catch(e){
      StaticLogger.logger.e(e);
      return PreSaleData(
          name : name ?? "없음",
          announcementDateTimeStamp : announcementDate,
          category : category ?? "없음",
          region : region ?? "없음",
          imageUrl : "assets/images/home_temp.jpg",
          surveyData: surveyData
      );
    }
  }
}