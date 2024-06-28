import 'package:flutter/material.dart';
import 'package:homerun/Service/APTAnnouncementApiService/APTAnnouncement.dart';

class SiteReviewListPage extends StatelessWidget {
  const SiteReviewListPage({super.key, required this.announcement});
  final APTAnnouncement announcement;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("gd"),
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
