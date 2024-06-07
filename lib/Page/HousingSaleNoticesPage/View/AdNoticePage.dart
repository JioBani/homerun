import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/Widget/FireStorageImageList.dart';
import 'package:homerun/Page/Common/Widget/LargetIconButton.dart';
import 'package:homerun/Page/Common/Widget/SmallIconButton.dart';
import 'package:homerun/Service/APTAnnouncementApiService/APTAnnouncement.dart';
import 'package:homerun/Service/NaverGeocodeService/NaverGeocodeService.dart';
import 'package:homerun/Service/NaverGeocodeService/ServiceKey.dart';
import 'package:homerun/Style/Images.dart';

class AdNoticePage extends StatefulWidget {
  const AdNoticePage({super.key, required this.announcement});
  final APTAnnouncement announcement;

  @override
  State<AdNoticePage> createState() => _AdNoticePageState();
}

class _AdNoticePageState extends State<AdNoticePage> {
  final Color typeColor = const Color(0xffFF4545);

  final NaverGeocodeService _geocodeService = NaverGeocodeService.getInstanceWithInit(
      clientId,
      clientSecret
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(height: 17.w,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 25.w,),
                InkWell(
                  onTap: ()=>Get.back(),
                  child: SizedBox(
                    width: 24.sp,
                    height: 24.sp,
                    child: Image.asset(
                      Images.backIcon,
                    ),
                  ),
                ),
                const Expanded(child: SizedBox.shrink()),
                LargeIconButton(iconPath: Images.partnershipAd, text: "제휴광고",onTap: (){},),
                SizedBox(width: 7.w,),
                LargeIconButton(iconPath: Images.adInquiry, text: "광고문의",onTap: (){},),
                SizedBox(width: 25.w,)
              ],
            ),
            SizedBox(height: 22.w,),
            Padding(
              padding: EdgeInsets.only(left: 25.w),
              child: Row(
                children: [
                  Text("서울"),
                  SizedBox(width: 4.w,),
                  Container(
                    padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 0),
                    decoration: BoxDecoration(
                      border: Border.all(color: typeColor),
                      borderRadius: BorderRadius.circular(3.r), // radius가 약하게 보여서 2인데 3으로 변경
                    ),
                    child: Text(
                      "민간분양",
                      style: TextStyle(
                        color: typeColor,
                        fontWeight: FontWeight.w700 //폰트 굵기가 미디움인데 작게 보여서 bold로 변경
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 6.w,),
            Padding(
              padding: EdgeInsets.only(left: 25.w),
              child: Row(
                children: [
                  SizedBox(
                    width: 12.sp,
                    height: 12.sp,
                    child: Image.asset(
                      HousingSaleNoticesPageImages.pinMap
                    ),
                  ),
                  SizedBox(width: 4.w,),
                  Text(
                    "서대문구 월드 메리앙",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.w,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SmallIconButton(iconPath: Images.heart, text: "좋아요", onTap: (){}),
                SizedBox(width: 4.w,),
                SmallIconButton(iconPath: Images.scrap, text: "스크랩", onTap: (){}),
                SizedBox(width: 4.w,),
                SmallIconButton(iconPath: Images.share, text: "공유", onTap: (){}),
                SizedBox(width: 17.w,)
              ],
            ),
            SizedBox(height: 6.w,),
            SizedBox(
              width: double.infinity,
              height: 174.w,
              child: Image.asset(
                "assets/images/Test/ad.png",
                fit: BoxFit.fitHeight,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(25.w, 30.w, 25.w, 0),
              child: const FireStorageImageColum(path: "housing_notices/2024000001",),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(25.w, 10.w, 25.w, 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "위치보기",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp
                    ),
                  ),
                  SizedBox(height: 5.w,),
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 150.w,
                        child: APTAddressNaverMap(announcement: widget.announcement,geocodeService: _geocodeService,)
                      ),
                      IconButton(
                        iconSize: 25.sp,
                          onPressed: (){},
                          icon: const Icon(Icons.fullscreen_rounded)
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class APTAddressNaverMap extends StatefulWidget {
  const APTAddressNaverMap({super.key, required this.announcement, required this.geocodeService});

  final APTAnnouncement announcement;
  final NaverGeocodeService geocodeService;

  @override
  State<APTAddressNaverMap> createState() => _APTAddressNaverMapState();
}

class _APTAddressNaverMapState extends State<APTAddressNaverMap> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  Future<void> moveMapCameraToAddress(NaverMapController controller) async {
    try {
      final geocodeData = await widget.geocodeService.fetchGeocode(widget.announcement.supplyLocationAddress ?? '');
      if(geocodeData.addresses != null && geocodeData.addresses!.isNotEmpty){
        var position = NLatLng(
            double.parse(geocodeData.addresses![0].y ?? ''),
            double.parse(geocodeData.addresses![0].x ?? ''));

        final cameraUpdate = NCameraUpdate.withParams(
          target: position,
        );

        await controller.updateCamera(cameraUpdate);

        final infoWindow = NInfoWindow.onMap(
            id: "position",
            position: position,
            text: widget.announcement.houseName ?? ''
        );

        controller.addOverlay(infoWindow);
      }
    } catch (e , s) {
      //TODO 사용자에게 알림 주기
      StaticLogger.logger.e("$e \n $s");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return  NaverMap(
      onMapReady: (controller){
        moveMapCameraToAddress(controller);
      },
    );
  }
}



