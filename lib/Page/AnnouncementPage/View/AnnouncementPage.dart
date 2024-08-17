import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Style/Fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../Controller/AnnouncementPageController.dart';
import '../Model/Announcement.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({super.key});

  @override
  State<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {

  AnnouncementPageController controller = AnnouncementPageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "공지사항",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            fontFamily: Fonts.BCCard,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: SafeArea(
        child: PagedListView<int, Announcement>(
          pagingController: controller.pagingController,
          builderDelegate: PagedChildBuilderDelegate<Announcement>(
            itemBuilder: (context, item, index) => ListTile(
              title: Text(item.announcementDto?.toMap().toString() ?? ""),
            ),
          ),
        ),
      ),
    );
  }
}
