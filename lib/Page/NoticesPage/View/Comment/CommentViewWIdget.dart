import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Page/NoticesPage/Controller/CommentViewWidgetController.dart';

import 'CommentInputWidget.dart';
import 'CommentWidget.dart';

class CommentViewWidget extends StatefulWidget {
  const CommentViewWidget({super.key, required this.noticeId});
  final String noticeId;

  @override
  State<CommentViewWidget> createState() => _CommentViewWidgetState();
}

class _CommentViewWidgetState extends State<CommentViewWidget> {

  @override
  void initState() {
    Get.put(
        tag:widget.noticeId,
        CommentViewWidgetController(noticeId: widget.noticeId)
    ).resendLoader.load();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        children: [
          CommentInputWidget(noticeId: widget.noticeId),
          SizedBox(height: 20.w,),
          GetBuilder<CommentViewWidgetController>(
              tag: widget.noticeId,
              builder: (controller){
                if(controller.resendLoader.loadingState == LoadingState.success){
                  return Column(
                    children: controller.resendLoader.comments.map(
                            (comment) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.w),
                            child: CommentWidget(comment: comment, noticeId: widget.noticeId,)
                        )
                    ).toList(),
                  );
                }
                else{
                  return const CupertinoActivityIndicator();
                }
              }
          )
        ],
      ),
    );
  }
}