import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/NoticesPage/Controller/CommentViewWidgetController.dart';
import 'package:homerun/Page/NoticesPage/Model/Comment.dart';
import 'package:homerun/Page/NoticesPage/Service/CommentService.dart';
import 'package:homerun/Page/NoticesPage/View/Comment/ReplyCommentListWidget.dart';
import 'package:homerun/Style/Images.dart';
import 'package:homerun/Style/TestImages.dart';
import 'package:intl/intl.dart';

class CommentWidget extends StatefulWidget {
  const CommentWidget({super.key, required this.comment, required this.noticeId, this.replyTarget});

  final Comment comment;
  final String noticeId;
  final String? replyTarget;

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final CommentService commentService = CommentService();
  late int likeState;
  late int like;
  late int dislike;
  bool isReplyOpen = false;

  DateTime? lastClickTime;
  static const cooldownDuration = Duration(seconds: 2); // 2 seconds cooldown

  late final CommentViewWidgetController commentViewWidgetController;

  @override
  void initState() {
    // TODO: implement initState
    likeState = widget.comment.likeState;
    like = widget.comment.commentDto.like;
    dislike = widget.comment.commentDto.dislike;
    commentViewWidgetController = Get.find<CommentViewWidgetController>(tag: widget.noticeId);
    super.initState();
  }

  Future<void> updateLikeState(int newLikeState) async {
    final now = DateTime.now();
    if (lastClickTime != null && now.difference(lastClickTime!) < cooldownDuration) {
      Get.snackbar(
        'Warning',
        '잠시후 다시 시도해 주세요.',
        duration: const Duration(milliseconds: 2000),
        //backgroundColor: Theme.of(context).primaryColor
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
        snackPosition: SnackPosition.TOP
      );
      return;
    }

    lastClickTime = now;

    int previousLikeState = likeState;
    int likeChange = 0;
    int dislikeChange = 0;

    Result result = await commentService.updateLikeStatus(widget.noticeId, widget.comment.commentId, newLikeState);

    if (result.isSuccess) {
      if (newLikeState == 1) {
        likeChange = 1;
        if (previousLikeState == 1) return;
        if (previousLikeState == -1) dislikeChange = -1;
      } else if (newLikeState == -1) {
        dislikeChange = 1;
        if (previousLikeState == 1) likeChange = -1;
        if (previousLikeState == -1) return;
      } else {
        if (previousLikeState == 1) likeChange = -1;
        if (previousLikeState == -1) dislikeChange = -1;
      }

      likeState = newLikeState;
      like += likeChange;
      dislike += dislikeChange;
      setState(() {});
    } else {
      StaticLogger.logger.e('[CommentWidget.updateLikeState()] ${result.exception}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: (){
            Get.find<CommentViewWidgetController>(tag: widget.noticeId).setReplyMode(widget.comment.commentId);
          },
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30.w),
                child: Image.asset(
                  TestImages.ashe_43,
                  width: 30.w,
                  height: 30.w,
                ),
              ),
              SizedBox(
                width: 6.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.comment.commentDto.displayName,
                    style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: const Color(0xff767676)),
                  ),
                  Text(
                    DateFormat('yyyy.MM.dd').format(widget.comment.commentDto.date.toDate()),
                    style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.normal, color: const Color(0xff767676)),
                  )
                ],
              ),
              const Expanded(child: SizedBox()),
              Builder(
                  builder: (context){
                    if(FirebaseAuth.instance.currentUser != null &&
                       FirebaseAuth.instance.currentUser!.uid == widget.comment.commentDto.uid
                    ){
                      return TextButton(
                          onPressed: () {
                            commentViewWidgetController.deleteComment(widget.comment.commentId , widget.replyTarget);
                          },
                          child: const Text('삭제')
                      );
                    }
                    else{
                      return const SizedBox();
                    }
                  }
              )
            ],
          ),
        ),
        SizedBox(
          height: 7.w,
        ),
        Padding(
          padding: EdgeInsets.only(left: 2.w),
          child: Text(
            //comment.commentDto.content,
            widget.comment.toMap().toString(),
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CommentIconButton(
              imagePath: NoticePageImages.comment.good,
              content: like.toString(),
              onTap: () async {
                if(likeState == 1){
                  updateLikeState(0);
                }
                else{
                  updateLikeState(1);
                }
              },
              color: likeState == 1 ? Theme.of(context).primaryColor : null,
            ),
            CommentIconButton(
              imagePath: NoticePageImages.comment.bad,
              content: dislike.toString(),
              onTap: () async {
                if(likeState == -1){
                  updateLikeState(0);
                }
                else{
                  updateLikeState(-1);
                }
              },
              color: likeState == -1 ? Theme.of(context).primaryColor : null,
            ),
            CommentIconButton(
              imagePath: NoticePageImages.comment.reply,
              content: '댓글 3',
              color: isReplyOpen ? Theme.of(context).primaryColor : null,
              onTap: () {
                isReplyOpen = !isReplyOpen;
                setState(() {

                });
              },
            ),

          ],
        ),
        Builder(
            builder: (context){
              if(isReplyOpen && widget.replyTarget == null){
                return Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: ReplyCommentListWidget(noticeId: widget.noticeId,comment: widget.comment,),
                );
              }
              else{
                return const SizedBox();
              }
            }
        )
      ],
    );
  }
}

class CommentIconButton extends StatelessWidget {
  const CommentIconButton({super.key, required this.content, required this.onTap, required this.imagePath, this.color});

  final String content;
  final Function onTap;
  final String imagePath;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45.w,
      child: Row(
        children: [
          InkWell(
            onTap: (){onTap();},
            child: Image.asset(
              imagePath,
              width: 9.5.sp,
              height: 9.5.sp,
              color: color,
            ),
          ),
          SizedBox(
            width: 2.w,
          ),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                content, // Example text
                style: TextStyle(
                  fontSize: 9.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}