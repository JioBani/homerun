import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' as get_x;
import 'package:homerun/Common/FirebaseStorageImage.dart';
import 'package:homerun/Controller/AssessmentController.dart';
import 'package:homerun/Model/Assessment/Condition.dart';
import 'package:homerun/Model/Assessment/Conditioninfo.dart';
import 'package:homerun/Style/FirebaseStorageImages.dart';
import 'package:homerun/Style/ShadowPalette.dart';

class ResultTabViewPage extends StatelessWidget {
  const ResultTabViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    AssessmentController assessmentController = get_x.Get.find<AssessmentController>();

    if(assessmentController.conditionInfoList == null){
      return Text('오류가 발생했습니다.');
    }
    else{
      List<ConditionInfo> trueConditionInfos =
        assessmentController.conditionInfoList!.where((element) => element.condition.isTrue() == true).toList();

      //trueConditions = assessmentController.conditionList!; //테스트용
      
      return SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "청약자격진단이 완료되었습니다.",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500
              ),
            ),
            SizedBox(height: 10.h,),
            Wrap(
              children: trueConditionInfos.map((e) =>
                  ResultWidget(
                    id: e.condition.questionId,
                    result: e.condition.isTrue(),
                  )
              ).toList(),
            ),
          ],
        ),
      );
    }
  }
}

class ResultWidget extends StatelessWidget {
  const ResultWidget({
    super.key,
    required this.id,
    this.result
  });

  final String id;
  final bool? result;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.w,
      height: 150.w,
      margin: EdgeInsets.all(10.w),
      padding: EdgeInsets.fromLTRB(20.w, 5.h, 20.w, 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [ShadowPalette.defaultShadowLight]
      ),
      child: Column(
        children: [
          Text(
              id,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13.sp
            ),
          ),
          Expanded(
            child: FireStorageImage(
              path: FirebaseStorageImages.typeImages.family,
              fit: BoxFit.fitWidth,
            ),
          ),
        ],
      ),
    );
  }
}

