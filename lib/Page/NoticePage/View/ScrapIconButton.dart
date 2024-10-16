//#. 스크랩 버튼
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/Widget/LoadableIcon.dart';
import 'package:homerun/Common/Widget/Snackbar.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/ScapPage/Service/ScrapService.dart';
import 'package:homerun/Service/Auth/AuthService.dart';

class ScrapIconButton extends StatelessWidget {
  const ScrapIconButton({super.key, required this.noticeId});

  final String noticeId;

  @override
  Widget build(BuildContext context) {
    return LoadableIcon<bool>(
      iconBuilder: (value , loadingState){
        if(loadingState == LoadingState.loading || loadingState == LoadingState.loading){
          return SizedBox(
              width: 22.sp,
              height: 22.sp,
              child: const CupertinoActivityIndicator()
          );
        }
        else if(value == null || !value){
          return Icon(
            Icons.bookmark_border_outlined,
            size: 22.sp,
          );
        }
        else{
          return Icon(
            Icons.bookmark ,
            color: Theme.of(context).primaryColor,
            size: 22.sp,
          );
        }
      },
      load: (currentValue) async{
        //#. 스크랩 확인
        Result<bool> result = await ScrapService.instance.isNoticeScraped(noticeId);
        if(result.isSuccess){
          return (result.content , LoadingState.success);
        }
        else{
          return (null , LoadingState.fail);
        }
      },
      onTap: (currentValue , loadingState) async {
        //#. 스크랩 로딩 성공시
        if(currentValue != null){
          //#. 로그인 체크
          if(Get.find<AuthService>().tryGetUser() == null){
            CustomSnackbar.show("오류" , "로그인이 필요합니다.");
            return (null , LoadingState.fail);
          }

          if(currentValue){ //#. 스크랩 취소
            Result result = await ScrapService.instance.deleteNoticeScrap(noticeId);
            if(!result.isSuccess){
              CustomSnackbar.show("오류" , "스크랩 삭제에 실패했습니다.");
              return (true , LoadingState.fail);
            }
            else{
              CustomSnackbar.show("알림", "스크랩을 삭제 했습니다.");
              return (false , LoadingState.success);
            }
          }
          else{ //#. 스크랩
            Result result = await ScrapService.instance.scrapNotification(noticeId);
            if(!result.isSuccess){
              CustomSnackbar.show("오류" , "스크랩에 실패했습니다.");
              return (false , LoadingState.fail);
            }
            else{
              CustomSnackbar.show("알림", "스크랩했습니다.");
              return (true, LoadingState.success);
            }
          }
        }
        else{
          CustomSnackbar.show("오류" , "스크랩을 할 수 없습니다.");
          return (false, LoadingState.success);
        }
      },

    );
  }
}