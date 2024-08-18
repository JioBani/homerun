import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Service/NaverGeocodeService/NaverGeocodeService.dart';
import 'package:homerun/Style/Palette.dart';

import '../Model/Notice.dart';

class LocationMap extends StatefulWidget {
  const LocationMap({super.key, required this.geocodeService, required this.notice});
  final Notice notice;

  final NaverGeocodeService geocodeService;

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  late final NaverMapController? naverMapController;

  Future<void> moveMapCameraToAddress(NaverMapController controller) async {
    try {
      if(widget.notice.hasError){
        return;
      }

      final geocodeData = await widget.geocodeService.fetchGeocode(widget.notice.noticeDto?.info?.supplyLocationAddress ?? '');
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
            text: widget.notice.noticeDto?.houseName ?? ''
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
    if(widget.notice.hasError){
      return SizedBox(
        height: 200.w,
        width: double.infinity,
        child: const CupertinoActivityIndicator(),
      );
    }
    else{
      return Stack(
        children: [
          NaverMap(
            forceGesture: true,
            onMapReady: (controller){
              naverMapController = controller;
              moveMapCameraToAddress(controller);
            },
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5.w, right: 5.w),
            child: Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: (){
                  if(naverMapController != null){
                    moveMapCameraToAddress(naverMapController!);
                  }
                },
                child: Container(
                  width: 32.sp,
                  height: 32.sp,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.r)
                  ),
                  child: Icon(
                    Icons.my_location,
                    size: 20.sp,
                    color: Palette.defaultSkyBlue,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
                iconSize: 25.sp,
                onPressed: (){
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => Dialog.fullscreen(
                          child:FullLocationMap(notice: widget.notice)
                      )
                  );
                },
                icon: const Icon(Icons.fullscreen_rounded)
            ),
          ),
        ],
      );
    }
  }
}

class FullLocationMap extends StatelessWidget {
   FullLocationMap({super.key, required this.notice});
  final Notice notice;
  NaverMapController? naverMapController;

  Future<void> moveMapCameraToAddress() async {
    try {
      if(naverMapController == null){
        return;
      }

      final geocodeData = await NaverGeocodeService.instance.fetchGeocode(notice.noticeDto?.info?.supplyLocationAddress  ?? '');

      if(geocodeData.addresses != null && geocodeData.addresses!.isNotEmpty){
        var position = NLatLng(
            double.parse(geocodeData.addresses![0].y ?? ''),
            double.parse(geocodeData.addresses![0].x ?? ''));

        final cameraUpdate = NCameraUpdate.withParams(
          target: position,
        );

        await naverMapController!.updateCamera(cameraUpdate);

        final infoWindow = NInfoWindow.onMap(
            id: "position",
            position: position,
            text: notice.noticeDto?.houseName ?? ''
        );

        naverMapController!.addOverlay(infoWindow);
      }
    } catch (e , s) {
      //TODO 사용자에게 알림 주기
      StaticLogger.logger.e("$e \n $s");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        NaverMap(
          onMapReady: (controller){
            naverMapController = controller;
            moveMapCameraToAddress();
          },
        ),
        IconButton(
            iconSize: 25.sp,
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_rounded)
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10.w, right: 10.w),
          child: Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: (){
                if(naverMapController != null){
                  moveMapCameraToAddress();
                }
              },
              child: Container(
                width: 40.sp,
                height: 40.sp,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.r)
                ),
                child: Icon(
                  Icons.my_location,
                  size: 30.sp,
                  color: Palette.defaultSkyBlue,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}




