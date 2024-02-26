import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Common/FirebaseStorageImage.dart';
import 'package:homerun/Model/GuidePostData.dart';
import 'package:homerun/Style/Images.dart';
import 'package:homerun/Style/Palette.dart';

class PostPreviewWidget extends StatelessWidget {
  PostPreviewWidget({super.key ,this.guidePostData ,this.width , this.height , this.imageWidth , this.imageHeight});
  GuidePostData? guidePostData;
  double? width;
  double? height;
  double? imageHeight;
  double? imageWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Builder(
        builder: (context) {
          if(guidePostData == null){
            return Text("데이터를 불러오지 못 했습니다.");
          }
          else{
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: FireStorageImage(
                        path:guidePostData!.thumbnailImagePath,
                        fit: BoxFit.fitHeight,
                      )
                  ),
                ),
                Text(
                  guidePostData!.title,
                  style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: Palette.defaultBlue
                  ),
                ),
                SizedBox(height: 2,),
                Text(
                  guidePostData!.subTitle,
                  style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                      color: Palette.font.grey
                  ),
                ),
              ],
            );
          }
        }
      ),
    );
  }
}
