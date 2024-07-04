import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Page/SiteReviewPage/Model/CommentDto.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:homerun/Style/TestImages.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget({super.key, required this.commentDto});
  final CommentDto commentDto;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
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
            child: Container(
              decoration: BoxDecoration(
              ),
              child: Column(
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
                        "2024.04.16",
                        style: TextStyle(
                            color: Palette.brightMode.mediumText,
                            fontSize: 12.sp
                        ),
                      )
                    ],
                  ),
                  Text("청년특공 어떻게 될까요? 부모님과 함께 살고 있는데도 가능할까요? 부린이라 모르는게 너무 많아요....ㅠ_ㅠ청년특공 어떻게 될까요? 부모님과 함께 살고 있는데도 가능할까요? 부린이라 모르는게 너무 많아요....ㅠ_ㅠ청년특공 어떻게 될까요? 부모님과 함께 살고 있는데도 가능할까요? 부린이라 모르는게 너무 많아요....ㅠ_ㅠ")
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
