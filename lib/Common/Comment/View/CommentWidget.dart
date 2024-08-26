import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:homerun/Common/FirebaseStorageImage.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Common/TimeFormatter.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/FirebaseReferences/UserInfoReferences.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:homerun/Service/Auth/HttpError.dart';
import 'package:homerun/Service/Auth/UserDto.dart';
import 'package:homerun/Service/FirebaseFirestoreService.dart';
import 'package:homerun/Style/Images.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:shimmer/shimmer.dart';

import '../Service/CommentService.dart';
import '../Controller/CommentListController.dart';
import '../Model/Comment.dart';
import '../Model/LikeState.dart';
import 'CommentInputWidget.dart';
import 'CommentPopupMenuButtonWidget.dart';
import 'CommentSnackBar.dart';
import 'ReplyCommentListWidget.dart';

//TODO 댓글 디자인 전체적으로 수정

class CommentWidget extends StatefulWidget {
  const CommentWidget({
    super.key,
    required this.comment,
    this.replyTarget,
    required this.commentController,
  });

  final Comment comment;
  final Comment? replyTarget;
  final CommentListController commentController;

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  static const cooldownDuration = Duration(seconds: 2);

  late int likeState;
  late int likes;
  late int dislikes;
  UserDto? userDto;

  bool isReplyOpen = false;
  bool isModifyOpen = false;

  DateTime? lastClickTime;
  LoadingState loadingState = LoadingState.before;
  LoadingState likeLoadingState = LoadingState.success;
  LoadingState unlikeLoadingState = LoadingState.success;

  @override
  void initState() {
    initData();
    userDto = null;
    getUser();
    super.initState();
  }

  //#. 위젯 재사용 때문에 데이터 초기화 필요
  @override
  void didUpdateWidget(CommentWidget oldWidget) {
    if (oldWidget.comment != widget.comment) {
      initData();
      userDto = null;
      getUser();
    }

    super.didUpdateWidget(oldWidget);
  }

  void initData() {
    likeState = widget.comment.likeState ?? 0;
    likes = widget.comment.commentDto.likes ?? 0;
    dislikes = widget.comment.commentDto.dislikes ?? 0;
    isReplyOpen = false;
    loadingState = LoadingState.before;
  }

  Future<void> getUser() async {
    loadingState = LoadingState.loading;
    setState(() {});
    Result<UserDto> userResult = await FirebaseFirestoreService.instance.getUser(widget.comment.commentDto.uid);
    if (userResult.isSuccess) {
      userDto = userResult.content!;
      loadingState = LoadingState.success;
    } else {
      loadingState = LoadingState.fail;
    }
    setState(() {});
  }

  Future<void> updateLikeState(bool isLike,int newLikeState) async {
    final now = DateTime.now();
    if (lastClickTime != null && now.difference(lastClickTime!) < cooldownDuration) {
      CommentSnackbar.show('오류', '잠시후 다시 시도해 주세요.');
      return;
    }

    lastClickTime = now;

    if(isLike){
      likeLoadingState = LoadingState.loading;
    }
    else{
      unlikeLoadingState = LoadingState.loading;
    }
    setState(() {});

    Result<LikeState> result = await CommentService.instance.updateLikeState(widget.comment, newLikeState);

    if (result.isSuccess) {
      likeState = result.content!.likeState;
      likes += result.content!.likeChange;
      dislikes += result.content!.dislikeChange;
    } else {
      StaticLogger.logger.e('[CommentWidget.updateLikeState()] ${result.exception}');
      if (result.exception is SocketException) {
        CommentSnackbar.show('오류', '인터넷에 연결 할 수 없습니다.');
      } else if (result.exception is ApplicationUnauthorizedException) {
        CommentSnackbar.show('오류', '로그인이 필요합니다.');
      } else if (result.exception is UnauthorizedError) {
        CommentSnackbar.show('오류', '사용자 정보를 확인 할 수 없습니다.');
      } else {
        CommentSnackbar.show('오류', '오류가 발생했습니다.');
      }
    }

    if(isLike){
      likeLoadingState = LoadingState.success;
    }
    else{
      unlikeLoadingState = LoadingState.success;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.w, bottom: 15.w),
      child: Builder(builder: (context) {
        if (loadingState == LoadingState.success) {
          return Column(
            children: [
              //#. 댓글
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //#. 프로필 사진
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30.w),
                    child: Builder(
                      builder: (_) {
                        if(userDto == null){
                          return SizedBox(width: 30.w,height: 30.w);
                        }
                        else{
                          return FireStorageImage(
                            width: 30.w,
                            height: 30.w,
                            path: UserInfoReferences.getUserProfileImagePath(userDto!.uid),
                            fit: BoxFit.cover,
                          );
                        }
                      }
                    )
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
                            //#. 유저이름
                            Text(
                              loadingState == LoadingState.success ? userDto!.displayName! : "알 수 없음",
                              style: TextStyle(
                                  fontSize: 11.sp, fontWeight: FontWeight.w600, color: Palette.brightMode.mediumText,
                              )
                            ),
                            SizedBox(
                              width: 7.w,
                            ),
                            //#. 작성 시간
                            Text(
                              TimeFormatter.formatTimeDifference(widget.comment.commentDto.date.toDate()),
                              style: TextStyle(
                                  fontSize: 11.sp, fontWeight: FontWeight.normal, color: Palette.brightMode.mediumText,
                              ),
                            ),
                            const Spacer(),
                            //#. 팝업 메뉴
                            CommentPopupMenuButtonWidget(
                                comment: widget.comment,
                                commentListController: widget.commentController,
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
                        //#. 댓글 내용 or 댓글 수정 위젯
                        Padding(
                          padding: EdgeInsets.only(left: 2.w),
                          child: Builder(
                            builder: (context){
                              if(isModifyOpen){
                                return CommentInputWidget(
                                  //#. 취소 버튼 눌렀을때 isModifyOpen 변경
                                  onTapClosed: (context) {
                                    setState(() {
                                      isModifyOpen = false;
                                    });
                                  },
                                  //#. 성공하면 수정 위젯 닫기
                                  onTapSubmit:(context , content , focusNode , textController) async {
                                    Result? result = await widget.commentController.update(widget.comment, content);
                                    if(result != null && result.isSuccess){
                                      textController.clear();
                                      setState(() {
                                        isModifyOpen = false;
                                      });
                                    }
                                  },
                                  startString: widget.comment.commentDto.content,
                                  startWithOpen: true,
                                  maintainButtons: true,
                                  hasCloseButton: true,
                                );
                              }
                              else{
                                //#. 댓글 내용 위젯
                                return Text(
                                  widget.comment.commentDto.content,
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.normal,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        //#. 댓글 아래 아이콘들
                        SizedBox(
                          height: 12.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              //#. 좋아요 버튼
                              Builder(
                                builder: (context){
                                  if(widget.comment.commentDto.likes != null && widget.commentController.hasLikes){
                                    if(likeLoadingState == LoadingState.loading){
                                      return SizedBox(
                                          width : 45.w ,
                                          child: Row(
                                            children: [
                                              Center(
                                                  child: SizedBox(
                                                    width: 11.sp,
                                                    height: 11.sp,
                                                    child: CupertinoActivityIndicator(),
                                                  )
                                              ),
                                              Gap(2.w),
                                              Text(
                                                likes.toString(),
                                                style: TextStyle(
                                                  fontSize: 11.sp,
                                                ),
                                              )
                                            ],
                                          )
                                      );
                                    }
                                    else{
                                      return CommentIconButton(
                                        imagePath: NoticePageImages.comment.good,
                                        content: likes.toString(),
                                        iconDistance: 2.w,
                                        onTap: () async {
                                          if (likeState == 1) {
                                            updateLikeState(true,0);
                                          } else {
                                            updateLikeState(true,1);
                                          }
                                        },
                                        color: likeState == 1 ? Theme.of(context).primaryColor : null,
                                      );
                                    }
                                  }
                                  else{
                                    return SizedBox(
                                        width : 45.w ,
                                        child: Row(
                                          children: [
                                            const Center(child: CupertinoActivityIndicator()),
                                            Gap(2.w),
                                            Text(
                                              dislikes.toString(),
                                              style: TextStyle(
                                                fontSize: 11.sp,
                                              ),
                                            )
                                          ],
                                        )
                                    );
                                  }
                                }
                              ),
                              //#. 싫어요 버튼
                              Builder(
                                builder: (context){
                                  if(widget.comment.commentDto.likes != null && widget.commentController.hasLikes){
                                    if(unlikeLoadingState == LoadingState.loading){
                                      return SizedBox(
                                          width : 45.w ,
                                          child: Row(
                                            children: [
                                              Center(
                                                child: SizedBox(
                                                  width: 11.sp,
                                                  height: 11.sp,
                                                  child: CupertinoActivityIndicator(),
                                                )
                                              ),
                                              Gap(2.w),
                                              Text(dislikes.toString())
                                            ],
                                          )
                                      );
                                    }
                                    else{
                                      return CommentIconButton(
                                        imagePath: NoticePageImages.comment.bad,
                                        content: dislikes.toString(),
                                        iconDistance: 2.w,
                                        onTap: () async {
                                          if (likeState == -1) {
                                            updateLikeState(false,0);
                                          } else {
                                            updateLikeState(false,-1);
                                          }
                                        },
                                        color: likeState == -1 ? Theme.of(context).primaryColor : null,
                                      );
                                    }
                                  }
                                  else{
                                    return const SizedBox();
                                  }
                                }
                              ),
                              //#. 대댓글 버튼
                              Builder(builder: (context) {
                                if (widget.replyTarget == null && widget.commentController.hasReply) {
                                  return CommentIconButton(
                                    imagePath: NoticePageImages.comment.reply,
                                    content: '대댓글 ${widget.comment.replyCount}',
                                    color: isReplyOpen ? Theme.of(context).primaryColor : null,
                                    iconDistance: 4.w,
                                    textTap: true,
                                    onTap: () {
                                      if (widget.replyTarget == null) {
                                        setState(() {
                                          isReplyOpen = !isReplyOpen;
                                        });
                                      }
                                    },
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              })
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              //#. 대댓글 리스트
              Builder(builder: (context) {
                if (isReplyOpen && widget.replyTarget == null && widget.commentController.hasReply) {
                  return Padding(
                    padding: EdgeInsets.only(top: 10.w, left: 15.w),
                    child: ReplyCommentListWidget(
                      replyParentComment: widget.comment,
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              }),
            ],
          );
        } else {
          return const LoadingPlaceHolder();
        }
      }),
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
                    width: 11.sp,
                    height: 11.sp,
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
                          fontSize: 11.sp,
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
                    width: 11.sp,
                    height: 11.sp,
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
                        fontSize: 11.sp,
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
                  SizedBox(height: 5.w),
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

