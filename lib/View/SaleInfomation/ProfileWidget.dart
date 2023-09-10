import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Controller/SaleInformationPageController.dart';
import 'package:homerun/Model/PreSaleData.dart';

class ProfileRowWidget extends StatelessWidget {
  const ProfileRowWidget({super.key, required this.region, this.data0, this.data1});
  final String region;
  final PreSaleData? data0;
  final PreSaleData? data1;


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ProfileWidget(preSaleData: data0, region: region),
        ProfileWidget(preSaleData: data1, region: region),
      ],
    );
  }
}

class ProfileWidget extends StatelessWidget {
  ProfileWidget({super.key, required this.region, this.preSaleData});

  final SaleInformationPageController controller = Get.find<SaleInformationPageController>();
  final String region;
  final PreSaleData? preSaleData;

  @override
  Widget build(BuildContext context) {
    if(preSaleData  == null){
      return Container(
        margin: EdgeInsets.fromLTRB(0, 20.h, 0, 50.h),
        width: 300.w,
      );
    }
    else{
      return Container(
        margin: EdgeInsets.fromLTRB(0, 20.h, 0, 50.h),
        width: 300.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(preSaleData!.name),
            SizedBox(height: 10.h,),
            ClipRRect(
              borderRadius: BorderRadius.circular(15.r),
              child: Image.asset(
                preSaleData!.imageUrl,
              ),
            ),
            SizedBox(height: 10.h,),
            Text(preSaleData!.getDateString()),
            Text(preSaleData!.category),
          ],
        ),
      );
    }
  }
}
