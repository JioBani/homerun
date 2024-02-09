import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:homerun/Model/TestData.dart';
import 'package:logger/logger.dart';

class   GuidePageController extends GetxController{
  RxList<ProductData> productDatas = <ProductData>[].obs;
  var productsCount = 0;
  final CollectionReference _collectionReference = FirebaseFirestore.instance.collection('items');
  final RxString imageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  Future<void> getData() async {
    final snapshot = await _collectionReference.get();
    final dataList = snapshot.docs
        .map((document) => ProductData.fromMap(document.data() as Map<String, dynamic>))
        .toList();
    productDatas.assignAll(dataList);
  }

  Future<String> getImageUrl(ProductData data) async {
    try {
      final images =  FirebaseStorage.instance.ref().child("images");
      final imageUrl = await images.child("Ahri_7.jpg").getDownloadURL();
      Logger().log(Level.info, imageUrl);
      return imageUrl;
    } catch (e) {
      print('Error getting image URL: $e');
      return "";
    }
  }
}