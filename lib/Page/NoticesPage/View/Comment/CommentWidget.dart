import 'dart:io';

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
import 'package:homerun/Page/NoticesPage/View/Comment/CommentDropdowmMenuWidget.dart';
import 'package:homerun/Page/NoticesPage/View/Comment/CommentInputWidget.dart';
import 'package:homerun/Page/NoticesPage/View/Comment/CommentSnackbar.dart';
import 'package:homerun/Page/NoticesPage/View/Comment/ReplyCommentListWidget.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:homerun/Service/Auth/HttpError.dart';
import 'package:homerun/Service/Auth/UserDto.dart';
import 'package:homerun/Service/FirebaseFirestoreService.dart';
import 'package:homerun/Style/Images.dart';
import 'package:homerun/Style/TestImages.dart';
import 'package:shimmer/shimmer.dart';

class CommentWidget extends StatefulWidget {
  const CommentWidget({super.key, required this.comment, required this.noticeId, this.replyTarget});

  final Comment comment;
  final String noticeId;
  final Comment? replyTarget;

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  late int likeState;
  late int likes;
  late int dislikes;
  bool isReplyOpen = false;
  bool isModifyOpen = false;
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
      CommentSnackbar.show(
        '오류',
        '잠시후 다시 시도해 주세요.'
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
      if(result.exception is SocketException){
        CommentSnackbar.show('오류', '인터넷에 연결 할 수 없습니다.');
      }
      else if(result.exception is ApplicationUnauthorizedException){
        CommentSnackbar.show('오류', '로그인이 필요합니다.');
      }
      else if(result.exception is UnauthorizedError){
        CommentSnackbar.show('오류', '사용자 정보를 확인 할 수 없습니다.');
      }
      else{
        CommentSnackbar.show('오류', '오류가 발생했습니다.');
      }
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
    return Padding(
      padding: EdgeInsets.only(top: 5.w,bottom: 15.w),
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
                          CommentPopupMenuButtonWidget(
                            noticeId: widget.noticeId,
                            comment: widget.comment,
                            onTapModify: (){
                              setState(() {
                                isModifyOpen = true;
                              });
                            },
                            replyTarget: widget.replyTarget,
                            isMine : widget.comment.commentDto.uid == FirebaseAuth.instance.currentUser?.uid
                          )
                        ],
                      ),
                      SizedBox(
                        height: 7.w,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2.w),
                        child: Builder(
                          builder: (context) {
                            if(isModifyOpen){
                              return Column(
                                children: [
                                  CommentInputWidget(
                                    noticeId: widget.noticeId,
                                    onFocus: (){},
                                    isModify : true,
                                    modifyTarget: widget.comment,
                                    startWithOpen: true,
                                    startString: widget.comment.commentDto.content,
                                    maintainButtons: true,
                                    onPressClosed: (){
                                      setState(() {
                                        isModifyOpen = false;
                                      });
                                    },
                                  ),
                                ],
                              );
                            }
                            else{
                              return Text(
                                widget.comment.commentDto.content,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.normal,
                                ),
                              );
                            }
                          }
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CommentIconButton(
                            imagePath: NoticePageImages.comment.good,
                            content: likes.toString(),
                            iconDistance: 2.w,
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
                            iconDistance: 2.w,
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
                          Builder(
                            builder: (context){
                              if(widget.replyTarget == null){
                                return CommentIconButton(
                                  imagePath: NoticePageImages.comment.reply,
                                  content: '대댓글 ${widget.comment.replyCount}',
                                  color: isReplyOpen ? Theme.of(context).primaryColor : null,
                                  iconDistance: 4.w,
                                  textTap: true,
                                  onTap: () {
                                    if(widget.replyTarget == null){
                                      setState(() {
                                        isReplyOpen = !isReplyOpen;
                                      });
                                    }
                                  },
                                );
                              }
                              else{
                                return SizedBox();
                              }
                            }
                          )

                        ],
                      ),
                      Builder(
                          builder: (context){
                            if(isReplyOpen && widget.replyTarget == null){
                              return Padding(
                                padding: EdgeInsets.only(top: 10.w),
                                child: ReplyCommentListWidget(noticeId: widget.noticeId,comment: widget.comment,),
                              );
                            }
                            else{
                              return const SizedBox();
                            }
                          }
                      ),
                    ],
                  ),
                ),
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

/// `CommentIconButton`
/// 댓글 위젯 아래의 아이콘 위젯입니다.
///
/// 필수 인자:
/// - `content`: 버튼에 표시될 텍스트.
/// - `onTap`: 버튼이 탭되었을 때 호출될 콜백 함수.
/// - `imagePath`: 아이콘 이미지의 경로.
///
/// 선택적 인자:
/// - `color`: 아이콘의 색상.
/// - `textTap = false` : 텍스트도 탭 가능하게 할지 여부.
/// - `iconDistance = 2`: 아이콘과 텍스트 사이의 거리.
class CommentIconButton extends StatelessWidget {
  const CommentIconButton({
    super.key,
    required this.content,
    required this.onTap,
    required this.imagePath,
    this.color,
    this.textTap = false,
    this.iconDistance = 2
  });

  final String content;
  final void Function() onTap;
  final String imagePath;
  final Color? color;
  final bool textTap;
  final double iconDistance;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45.w,
      child: Builder(
        builder: (context) {
          if (textTap) {
            return InkWell(
              onTap: onTap,
              child: Row(
                children: [
                  Image.asset(
                    imagePath,
                    width: 9.5.sp,
                    height: 9.5.sp,
                    color: color,
                  ),
                  SizedBox(
                    width: iconDistance,
                  ),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        content,
                        style: TextStyle(
                          fontSize: 9.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Row(
              children: [
                InkWell(
                  onTap: onTap,
                  child: Image.asset(
                    imagePath,
                    width: 9.5.sp,
                    height: 9.5.sp,
                    color: color,
                  ),
                ),
                SizedBox(
                  width: iconDistance,
                ),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      content,
                      style: TextStyle(
                        fontSize: 9.sp,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
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

