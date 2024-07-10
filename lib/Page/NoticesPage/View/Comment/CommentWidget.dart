import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Comment/Comment.dart';
import 'package:homerun/Common/Comment/LikeState.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/TimeFormatter.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/NoticesPage/Controller/CommentViewWidgetController.dart';
import 'package:homerun/Page/NoticesPage/View/Comment/CommentSnackbar.dart';
import 'package:homerun/Page/NoticesPage/View/Comment/ReplyCommentListWidget.dart';
import 'package:homerun/Service/Auth/UserDto.dart';
import 'package:homerun/Service/FirebaseFirestoreService.dart';
import 'package:homerun/Style/Images.dart';
import 'package:homerun/Style/TestImages.dart';
import 'package:shimmer/shimmer.dart';

class CommentWidget extends StatefulWidget {
  const CommentWidget({super.key, required this.comment, required this.noticeId, this.replyTarget});

  final Comment comment;
  final String noticeId;
  final String? replyTarget;

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  late int likeState;
  late int likes;
  late int dislikes;
  bool isReplyOpen = false;
  UserDto? userDto;
  LoadingState loadingState = LoadingState.before;

  DateTime? lastClickTime;
  static const cooldownDuration = Duration(seconds: 2);

  late final CommentViewWidgetController commentViewWidgetController;

  @override
  void initState() {
    initData();
    userDto = null;
    getUser();
    commentViewWidgetController = Get.find<CommentViewWidgetController>(tag: widget.noticeId);
    super.initState();
  }

  //#. 위젯 재사용 때문에 데이터 초기화 필요
  @override
  void didUpdateWidget(CommentWidget oldWidget) {
    if(oldWidget.comment != widget.comment){
      initData();
      userDto = null;
      getUser();
    }

    super.didUpdateWidget(oldWidget);
  }

  Future<void> getUser() async {
    loadingState = LoadingState.loading;
    setState(() {});
    Result<UserDto> userResult = await FirebaseFirestoreService.instance.getUser(widget.comment.commentDto.uid);
    if(userResult.isSuccess){
      userDto = userResult.content!;
      loadingState = LoadingState.success;
    }
    else{
      loadingState = LoadingState.fail;
    }
    setState(() {});
  }

  Future<void> updateLikeState(int newLikeState) async {
    final now = DateTime.now();
    if (lastClickTime != null && now.difference(lastClickTime!) < cooldownDuration) {
      Get.snackbar(
        '오류',
        '잠시후 다시 시도해 주세요.',
        duration: const Duration(milliseconds: 2000),
        //backgroundColor: Theme.of(context).primaryColor
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
        snackPosition: SnackPosition.TOP
      );
      return;
    }

    lastClickTime = now;


    Result<LikeState> result = await commentViewWidgetController.updateLikeState(widget.comment, newLikeState);

    if (result.isSuccess) {
      likeState = result.content!.likeState;
      likes +=  result.content!.likeChange;
      dislikes +=  result.content!.dislikeChange;
      setState(() {});
    } else {
      StaticLogger.logger.e('[CommentWidget.updateLikeState()] ${result.exception}');
    }
  }

  void initData(){
    likeState = widget.comment.likeState ?? 0;
    likes = widget.comment.commentDto.likes ?? 0;
    dislikes = widget.comment.commentDto.dislikes ?? 0;
    isReplyOpen = false;
    loadingState = LoadingState.before;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.replyTarget == null ? Theme.of(context).colorScheme.background : Colors.grey.shade300,
      width: double.infinity,
      child: Builder(
        builder: (context) {
          if(loadingState == LoadingState.success){
            return Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loadingState == LoadingState.success ? userDto!.displayName! : "",
                            style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: const Color(0xff767676)),
                          ),
                          SizedBox(width: 7.w,),
                          Text(
                            TimeFormatter.formatTimeDifference(widget.comment.commentDto.date.toDate()),
                            style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.normal, color: const Color(0xff767676)),
                          ),
                          const Spacer(),
                          Builder(
                              builder: (context){
                                if(FirebaseAuth.instance.currentUser != null &&
                                    FirebaseAuth.instance.currentUser!.uid == widget.comment.commentDto.uid
                                ){
                                  return InkWell(
                                      onTap: () async {
                                        Result<void> result = await commentViewWidgetController.deleteComment(widget.comment);
                                        CommentSnackbar.show(
                                            result.isSuccess ? "알림" : "오류",
                                            result.isSuccess ? "댓글을 삭제했습니다." : "댓글 삭제에 실패했습니다."
                                        );
                                      },
                                      child: Text(
                                        '삭제',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 11.sp
                                        ),
                                      )
                                  );
                                }
                                else{
                                  return const SizedBox();
                                }
                              }
                          ),
                          SizedBox(width: 10.w,)
                        ],
                      ),
                      SizedBox(
                        height: 7.w,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2.w),
                        child: Text(
                          widget.comment.commentDto.content,
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
                            content: likes.toString(),
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
                            content: dislikes.toString(),
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
                              //Get.to(CommentListViewPage());
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
                  ),
                )
              ],
            );
          }
          else{
            return const LoadingPlaceHolder();
          }
        }
      ),
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

class LoadingPlaceHolder extends StatelessWidget {
  const LoadingPlaceHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(30.w),
                ),
              ),
              SizedBox(
                width: 6.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50.w,
                    height: 11.sp,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(1.r),
                    ),
                  ),
                  SizedBox(height:  5.w),
                  Container(
                    width: 70.w,
                    height: 10.sp,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(1.r),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 7.w,
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(right: 50.w),
            height: 10.sp,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(1.r),
            ),
          ),
          SizedBox(
            height: 7.w,
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(right: 20.w),
            height: 10.sp,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(1.r),
            ),
          ),
          SizedBox(
            height: 7.w,
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(right: 30.w),
            height: 10.sp,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(1.r),
            ),
          ),
        ],
      ),
    );
  }
}

