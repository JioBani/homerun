import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Service/APTAnnouncementApiService/APTAnnouncement.dart';
import 'package:homerun/Style/Fonts.dart';
import 'package:homerun/Style/Palette.dart';

class SiteReviewListPage extends StatelessWidget {
  const SiteReviewListPage({super.key, required this.announcement});
  final APTAnnouncement announcement;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              announcement.houseName ?? '',
              style: TextStyle(
                fontSize:  16.sp,
                fontWeight: FontWeight.bold,
                fontFamily: Fonts.BCCard,
                color: Theme.of(context).primaryColor
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}
