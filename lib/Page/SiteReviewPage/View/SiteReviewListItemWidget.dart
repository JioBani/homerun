import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/FirebaseStorageImage.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/model/Result.dart';
import 'package:homerun/Page/SiteReviewPage/Model/SiteReview.dart';
import 'package:homerun/Page/SiteReviewPage/View/SiteReview/SiteReviewPage.dart';
import 'package:homerun/Service/Auth/UserDto.dart';
import 'package:homerun/Service/FirebaseFirestoreService.dart';
import 'package:homerun/Style/Images.dart';
import 'package:homerun/Style/TestImages.dart';
import 'package:shimmer/shimmer.dart';

class SiteReviewListItemWidget extends StatefulWidget {
  const SiteReviewListItemWidget({super.key, required this.siteReview});
  final SiteReview siteReview;

  @override
  State<SiteReviewListItemWidget> createState() => _SiteReviewListItemWidgetState();
}

class _SiteReviewListItemWidgetState extends State<SiteReviewListItemWidget> {

  UserDto? userDto;
  LoadingState loadingState = LoadingState.before;

  Future<void> getUser()async {
    loadingState = LoadingState.loading;
    setState(() {});
    Result<UserDto> result = await FirebaseFirestoreService.instance.getUser(widget.siteReview.writer);
    if(result.isSuccess){
      userDto = result.content;
      loadingState = LoadingState.success;
    }
    else{
      loadingState = LoadingState.fail;
    }
    setState(() {});
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(loadingState == LoadingState.success){
          if(userDto == null){
            Get.snackbar('오류', '글 정보를 가져 올 수 없습니다.');
          }
          else{
            Get.to(SiteReviewPage(siteReview: widget.siteReview,userDto: userDto!,));
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 145.w,
            height: 180.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.r),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.r),
                        color: Colors.black12
                      ),
                    ),
                    FireStorageImage(
                      path: widget.siteReview.thumbnailRefPath,
                      fit: BoxFit.fitHeight,
                      width: 145.w,
                      height: 180.w,
                      onlySaveMemory: true,
                    ),
                  ],
                )
            ),
          ),
          SizedBox(height: 11.w,),
          Builder(
              builder: (context){
                if(loadingState == LoadingState.success){
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30.w),
                        child: Image.asset(
                          TestImages.ashe_43,
                          width: 30.w,
                          height: 30.w,
                        ),
                      ),
                      SizedBox(width: 7.w,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userDto?.displayName ?? '알 수 없음',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 11.sp
                            ),
                          ),
                          Row(
                            children: [
                              Image.asset(
                                  NoticePageImages.star
                              ),
                              SizedBox(width: 3.w,),
                              Text(
                                "조회수 ${widget.siteReview.view}",
                                style: TextStyle(
                                    fontSize: 8.sp,
                                    color: Color(0xff767676)
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  );
                }
                else{
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.w),
                            color: Colors.grey,
                          ),
                          width: 30.w,
                          height: 30.w,
                        ),
                        SizedBox(width: 7.w,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1.r),
                                color: Colors.grey,
                              ),
                              width: 50.w,
                              height: 11.sp,
                            ),
                            SizedBox(height: 3.w,),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1.r),
                                color: Colors.grey,
                              ),
                              width: 70.w,
                              height: 8.sp,
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                }
              }
          ),
        ],
      ),
    );
  }
}
