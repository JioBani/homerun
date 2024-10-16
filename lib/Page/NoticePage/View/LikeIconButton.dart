import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/Widget/LoadableIcon.dart';
import 'package:homerun/Common/Widget/Snackbar.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Feature/Notice/NoticeService.dart';
import 'package:homerun/Service/Auth/AuthService.dart';

class LikeIconButton extends StatelessWidget {
  const LikeIconButton({super.key, required this.noticeId});

  final String noticeId;

  @override
  Widget build(BuildContext context) {
    return LoadableIcon<bool>(
      iconBuilder: (value , loadingState){
        if(loadingState == LoadingState.loading || loadingState == LoadingState.before){
          return SizedBox(
              width: 22.sp,
              height: 22.sp,
              child: const CupertinoActivityIndicator()
          );
        }
        else{
          if(value == true){
            return Icon(
              Icons.favorite ,
              color: Colors.redAccent,
              size: 22.w,
            );
          }
          else{
            return Icon(
              Icons.favorite_border ,
              size: 22.w,
            );
          }
        }
      },
      load: (currentValue)async{
        if(Get.find<AuthService>().tryGetUser() == null){
          return (null , LoadingState.fail);
        }
        else{
          Result<bool> result = await NoticeService.instance.getLikeState(noticeId);
          if(result.isSuccess){
            return (result.content! , LoadingState.success);
          }
          else{
            return (null , LoadingState.fail);
          }
        }
      },
      onTap: (currentValue, controller) async {
        if(Get.find<AuthService>().tryGetUser() == null){
          CustomSnackbar.show("오류" , "로그인이 필요합니다.");
          return (null, LoadingState.fail);
        }

        if(currentValue != null){
          Result<bool> result = await NoticeService.instance.like(noticeId ,!currentValue);
          if(!result.isSuccess){
            CustomSnackbar.show("오류" , "좋아요에 실패했습니다.");
            return (null, LoadingState.fail);
          }
          else{
            return (result.content!, LoadingState.success);
          }
        }
        else{
          CustomSnackbar.show("오류" , "좋아요를 할 수 없습니다.");
          return (null, LoadingState.fail);
        }
      },
    );
  }
}
