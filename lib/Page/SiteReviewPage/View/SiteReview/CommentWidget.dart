import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Comment/CommentDto.dart';
import 'package:homerun/Common/TimeFormatter.dart';
import 'package:homerun/Service/Auth/AuthService.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:homerun/Style/TestImages.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget({super.key, required this.commentDto});
  final CommentDto commentDto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.w),
              child: Image.asset(
                TestImages.irelia_6,
                width: 30.w,
                height: 30.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 8.w,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "내집은언제",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Palette.brightMode.mediumText,
                        fontSize: 14.sp
                      ),
                    ),
                    SizedBox(width: 5.w,),
                    Text(
                      TimeFormatter.formatTimeDifference(commentDto.date.toDate()),
                      style: TextStyle(
                          color: Palette.brightMode.mediumText,
                          fontSize: 12.sp
                      ),
                    ),
                    const Spacer(),
                    Builder(builder: (context){
                      if(Get.find<AuthService>().tryGetUser()?.uid == commentDto.uid){
                        return TextButton(
                            onPressed: (){

                            },
                            child: const Text("삭제")
                        );
                      }
                      else{
                        return const SizedBox();
                      }
                    })
                  ],
                ),
                Text(
                  commentDto.content,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Palette.brightMode.darkText
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
