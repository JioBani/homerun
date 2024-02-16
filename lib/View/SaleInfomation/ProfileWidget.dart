import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:homerun/Controller/PresaleInfomationPage/SaleInformationPageController.dart';
import 'package:homerun/Model/PreSaleData.dart';
import 'package:homerun/Service/FirebaseStorageCacheService.dart';
import 'package:homerun/View/SaleInfomation/PresaleInfo/PresaleInfoPage.dart';

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
        margin: EdgeInsets.fromLTRB(0, 8.h, 0, 18.h),
        width: 120.w,
      );
    }
    else{
      return InkWell(
        onTap: (){
          if(preSaleData != null){
            Get.to(PresaleInfoPage(preSaleData: preSaleData!,));
          }
          else{
            Fluttertoast.showToast(
                msg: "분양 정보를 불러 올 수  없습니다.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.sp
            );
          }
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 10.h, 0, 18.h),
          width: 120.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 36.sp,
                  child: Text(
                    preSaleData!.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700
                    ),
                  )
              ),
              SizedBox(height: 10.h,),
              FutureBuilder(
                  future: FirebaseStorageCacheService.getImage("images/home_temp.jpg"),
                  builder: (context , snapshot){
                    if(snapshot.hasData){
                      if(snapshot.data == null){
                        return Text("Error");
                      }
                      else{
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child : Image(
                            image : snapshot.data!,
                          ),
                        );
                      }
                    }
                    else if(snapshot.hasError){
                      return Text("Error");
                    }
                    else{
                      return CupertinoActivityIndicator();
                    }
                  }
              ),
              SizedBox(height: 10.h,),
              Text(preSaleData!.getDateString()),
              Text(preSaleData!.category),
            ],
          ),
        ),
      );
    }
  }
}
