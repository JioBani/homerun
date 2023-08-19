import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class MainPageController{
  final CollectionReference _collectionReference = FirebaseFirestore.instance.collection('items');
  //final RxString notificationImageUrl = ''.obs;

  String? notificationImageUrl;

  Future<String> getNotificationImage() async {
    try {
      if(notificationImageUrl != null){
        return notificationImageUrl!;
      }
      else{
        final images =  FirebaseStorage.instance.ref().child("images");
        final imageUrl = await images.child("Ahri_7.jpg").getDownloadURL();
        notificationImageUrl = imageUrl;
        return imageUrl;
      }
    } catch (e) {
      print('Error getting image URL: $e');
      return "";
    }
  }

  Future<String> getAdsImage() async {
    try {
      final images =  FirebaseStorage.instance.ref().child("images");
      final imageUrl = await images.child("Ashe_43.jpg").getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error getting image URL: $e');
      return "";
    }
  }

}