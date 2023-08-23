import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:homerun/Controller/AssessmentSurveyPageController.dart';
import 'package:homerun/Style/ShadowPalette.dart';

class CheckBoxWidget extends StatefulWidget {
  CheckBoxWidget({super.key , required this.description , required this.index});

  final String description;
  final int index;

  @override
  State<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {

  //AssessmentSurveyPageController controller = Get.find<AssessmentSurveyPageController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.w),
      padding: EdgeInsets.fromLTRB(15.w, 5.w, 5.w, 5.w),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(7.w),
          boxShadow: [
            ShadowPalette.defaultShadowLight
          ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.description,
            style: TextStyle(
                fontSize: 32.w,
                fontWeight: FontWeight.w600,
                color: Colors.black
            ),
          ),
          GetX<AssessmentSurveyPageController>(
            builder: (controller) {
              return SizedBox(
                height: 50.w,
                width: 50.w,
                child: Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    value: controller.selectedValue.value == widget.index,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.w)
                    ),
                    onChanged: (bool? value) {
                      controller.select(widget.index);
                    },
                  ),
                ),
              );
            }
          ),
        ],
      ),
    );
  }
}
