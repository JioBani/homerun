import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Page/NoticesPage/Controller/CommentViewWidgetController.dart';
import 'package:homerun/Page/NoticesPage/View/Comment/CommentTabChildWidget.dart';
import 'package:homerun/Style/Palette.dart';
import 'CommentInputWidget.dart';

class CommentViewWidget extends StatefulWidget {
  const CommentViewWidget({super.key, required this.noticeId});
  final String noticeId;

  @override
  State<CommentViewWidget> createState() => _CommentViewWidgetState();
}

class _CommentViewWidgetState extends State<CommentViewWidget> with TickerProviderStateMixin{

  late final CommentViewWidgetController commentViewWidgetController;
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    commentViewWidgetController = Get.put(
        tag:widget.noticeId,
        CommentViewWidgetController(noticeId: widget.noticeId,tabController: _tabController)
    );

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        children: [
          SizedBox(
            height: 28.w,
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              controller: _tabController,
              indicator: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(5.r)),
              ),
              labelStyle: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
              unselectedLabelStyle: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: Palette.brightMode.mediumText
              ),
              tabs: const [
                Tab(
                  text: '청약자격 댓글',
                ),

                Tab(
                  text: '자유 댓글',
                ),
              ],
            ),
          ),
          CommentInputWidget(noticeId: widget.noticeId),
          SizedBox(height: 20.w,),
          CommentTabChildWidget(noticeId: widget.noticeId,),
        ],
      ),
    );
  }
}