import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:group_button/group_button.dart';
import 'package:homerun/Controller/AssessmentController.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:homerun/View/AssessmentPage/AnswerCheckBoxTileWidget.dart';

import '../../Model/Assessment/AssessmentQuestion.dart';

class QuestionWidget extends StatefulWidget {
  const QuestionWidget({
    super.key,
    required this.tabController,
    required this.assessmentController,
    required this.index,
    required this.selected,
  });

  final TabController tabController;
  final AssessmentController assessmentController;
  final int index;
  final int? selected;

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget>  with AutomaticKeepAliveClientMixin<QuestionWidget>{
  late GroupButtonController _checkboxesController;
  late Assessment assessment;

  @override
  void initState() {
    // TODO: implement initState
    _checkboxesController = GroupButtonController();
    assessment = widget.assessmentController.assessmentDto!.assessmentList[widget.index];
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  void moveBack(){
    int? pop = widget.assessmentController.popPageStack();
    if(pop == null){
      Fluttertoast.showToast(msg: "오류가 발생하였거나 마지막 페이지 입니다.");
    }
    else{
      widget.tabController.animateTo(pop);
    }
  }

  void moveFront(){
    if(_checkboxesController.selectedIndex != null){
      if(assessment.answers[_checkboxesController.selectedIndex!].goto != null){
        int goto = assessment.answers[_checkboxesController.selectedIndex!].goto!;

        widget.assessmentController.setAnswer(assessment, assessment.answers[_checkboxesController.selectedIndex!]);

        for(int i = widget.index + 1; i<goto; i++){
          widget.assessmentController.setAnswer(widget.assessmentController.assessmentDto!.assessmentList[i], null);
        }
        widget.assessmentController.setNextQuestion(goto);
        widget.assessmentController.pushPageStack(widget.tabController.index);
        widget.tabController.animateTo(goto);
      }
      else{
        widget.assessmentController.setAnswer(assessment, assessment.answers[_checkboxesController.selectedIndex!]);

        if (widget.tabController.index < widget.tabController.length - 1) {
          widget.assessmentController.setNextQuestion(widget.tabController.index + 1);
          widget.assessmentController.pushPageStack(widget.tabController.index);
          widget.tabController.animateTo(widget.tabController.index + 1);
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(7.w, 10.h, 7.w, 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            color: Palette.assessmentPage.questionWidgetBackground,
          ),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Row(
               children: [
                 Container(
                   width: 26.sp,
                   height: 26.sp,
                   alignment: Alignment.center,
                   padding: EdgeInsets.all(3.sp),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(26.sp),
                     color: Palette.assessmentPage.questionNumber
                   ),
                   child: FittedBox(
                     fit: BoxFit.scaleDown,
                     child: RichText(
                       overflow: TextOverflow.ellipsis,
                       text: TextSpan(
                         text: "Q${widget.index}",
                         style: TextStyle(
                           fontSize: 13.sp,
                           fontWeight: FontWeight.w700,
                           color: Colors.white
                         ),
                       ),
                     ),
                   ),
                 ),
                 SizedBox(width: 8.w,),
                 Flexible(
                   child: RichText(
                     maxLines: 3,
                     overflow: TextOverflow.ellipsis,
                     text: TextSpan(
                       text : assessment.question,
                       style: TextStyle(
                         fontSize: 15.sp,
                         fontWeight: FontWeight.w700,
                         color: Colors.black
                       ),
                     ),
                   ),
                 ),
               ],
             ),
             SizedBox(height: 12.h,),
             GetBuilder<AssessmentController>(
               builder: (controller) {
                 int? checked = widget.assessmentController.findSelected(widget.index);
                 if(checked != null){
                   _checkboxesController.selectIndex(checked);
                 }
                 return GroupButton(
                   controller: _checkboxesController,
                   isRadio: true,
                   options: const GroupButtonOptions(
                       groupingType: GroupingType.column,
                       //crossGroupAlignment: CrossGroupAlignment.start,
                   ),
                   buttons: assessment.answers,
                   buttonIndexedBuilder: (selected, index, context) {
                     return AnswerCheckBoxTile(
                       selected: _checkboxesController.selectedIndex == index,
                       onTap: () {
                         _checkboxesController.selectIndex(index);
                       },
                       title: assessment.answers[index].answer,
                     );
                   },
                 );
               }
             ),
           ],
         ),
        ),
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                    onPressed: moveBack,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.assessmentPage.questionWidgetBackground,
                      foregroundColor: Colors.black,
                      surfaceTintColor :  Palette.assessmentPage.questionWidgetBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.r), // 모서리 반경 설정
                      ),
                    ),
                    child: Text("이전")
                ),
              ),
              SizedBox(width: 3.w,),
              Expanded(
                child: ElevatedButton(
                    onPressed: moveFront,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.assessmentPage.questionWidgetBackground,
                      foregroundColor: Colors.black,
                      surfaceTintColor :  Palette.assessmentPage.questionWidgetBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.r), // 모서리 반경 설정
                      ),
                    ),
                    child: Text("다음")
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}


