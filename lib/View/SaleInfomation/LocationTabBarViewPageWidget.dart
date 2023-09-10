import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Model/PreSaleData.dart';
import 'package:homerun/Service/FirebaseFirestoreService.dart';

import 'PresaleListViewWidget.dart';
import '../../Controller/SaleInformationPageController.dart';

class LocationTabBarViewPageWidget extends StatelessWidget {

  LocationTabBarViewPageWidget({
    super.key,
    required this.region,
    required this.category
  });

  final SaleInformationPageController saleInformationController = Get.find<SaleInformationPageController>();
  final String region;
  final String category;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestoreService.instance.getDataStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              '데이터를 불러올 수 없습니다.',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 35.sp
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
        saleInformationController.refreshAllData(
            documents.map((document) => PreSaleData.fromDocumentSnapshot(document)).toList()
        );

        return PresaleListViewWidget(category: category , region: region,);
      },
    );
  }
}