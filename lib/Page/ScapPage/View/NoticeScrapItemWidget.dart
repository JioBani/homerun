import 'package:flutter/material.dart';
import 'package:homerun/Page/ScapPage/Model/NoticeScrap.dart';
import 'package:homerun/Style/TestImages.dart';

class NoticeScrapItemWidget extends StatelessWidget {
  const NoticeScrapItemWidget({super.key, required this.noticeScrap});
  final NoticeScrap noticeScrap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(TestImages.irelia_6),
      ],
    );
  }
}
