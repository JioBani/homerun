import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Widget/CustomDialog.dart';
import 'package:homerun/Common/Widget/LoadingDialog.dart';
import 'package:homerun/Common/Widget/Snackbar.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/NoticesPage/Controller/SiteReviewWidgetController.dart';
import 'package:homerun/Page/SiteReviewPage/Model/SiteReview.dart';
import 'package:homerun/Page/SiteReviewPage/Service/SiteReviewService.dart';

import '../../Controller/SiteReviewListPageController.dart';
import '../SiteReviewWritePage/SiteReviewWritePage.dart';

class AppbarPopupMenu extends StatelessWidget {
  const AppbarPopupMenu({super.key, required this.isMine, required this.siteReview});
  final bool isMine;
  final SiteReview siteReview;

  PopupMenuItem<String> buildMenuItem({
    required String value,
    required String name,
    required IconData icon,
    required Color color,
  }){
    return PopupMenuItem<String>(
      value: value,
      padding: EdgeInsets.zero,
      height: 32.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: color,
              weight: 0.1,
            ),
            Text(
              name,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                  color: color
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20.sp,
      width: 20.sp,
      child: PopupMenuButton<String>(
        surfaceTintColor: Colors.white,
        color: Colors.white,
        padding: EdgeInsets.zero,
        icon: Icon(
            Icons.more_vert,
            size: 20.sp,
            color: Colors.black
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.r))
        ),
        onSelected: (String result) async {
          if(result == "삭제"){
            var(Result result, bool isSucess) = await LoadingDialog.showLoadingDialogWithFuture<Result>(
                context,
                SiteReviewService.instance.delete(siteReview)
            );

            if(result.isSuccess){
              CustomDialog.defaultDialog(
                  context: context,
                  onTap: (dialogContext){
                    if(context.mounted){
                      Navigator.pop(context);
                    }
                  },
                  title: "삭제되었습니다.",
                  buttonText: "확인"
              );

              //#. 현장리뷰 리스트 페이지에서 제거
              if(Get.isRegistered<SiteReviewListPageController>(tag: siteReview.noticeId)){
                Get.find<SiteReviewListPageController>(tag: siteReview.noticeId).removeReview(siteReview);
              }

              //#. 공고 페이지의 현장리뷰 위젯에서 제거
              if(Get.isRegistered<SiteReviewWidgetController>()){
                Get.find<SiteReviewWidgetController>().removeReview(siteReview);
              }

            }
            else{
              CustomSnackbar.show("오류" , "삭제에 실패했습니다.");
            }
          }
          else if(result == "수정"){
            Get.to(
                SiteReviewWritePage(
                  noticeId: siteReview.noticeId,
                  updateTargetReview: siteReview,
                  isUpdateMode : true,
                )
            );
          }
        },
        itemBuilder: (BuildContext buildContext) {
          if(isMine){
            return [
              buildMenuItem(
                value: "수정",
                name: "수정하기",
                icon: Icons.mode_edit_outline_outlined,
                color: Colors.black,
              ),
              buildMenuItem(
                  value: "삭제",
                  name: "삭제하기",
                  icon: Icons.delete_outlined,
                  color: Colors.redAccent
              ),
            ];
          }
          else{
            return [
              buildMenuItem(
                value: "신고",
                name: "신고하기",
                icon: Icons.mode_edit_outline_outlined,
                color: Colors.black,
              )
            ];
          }
        },
        elevation: 4,
      ),
    );
  }
}
