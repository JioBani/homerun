import 'package:flutter/material.dart';
import 'package:homerun/Page/HousingSaleNoticesPage/View/NoticeProfileWidget.dart';

class NoticesTabPage extends StatelessWidget {
  const NoticesTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        NoticeProfileWidget(),
        NoticeProfileWidget(),
        NoticeProfileWidget(),
        NoticeProfileWidget(),
        NoticeProfileWidget(),
        NoticeProfileWidget(),
      ],
    );
  }
}
