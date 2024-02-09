import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:group_button/group_button.dart';
import 'package:homerun/Controller/AssessmentController.dart';
import 'package:homerun/Style/ShadowPalette.dart';

import 'AssessmentQuestion.dart';

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
    assessment = widget.assessmentController.questions[widget.index];
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
          widget.assessmentController.setAnswer(widget.assessmentController.questions[i], null);
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
          padding: EdgeInsets.fromLTRB(0.w, 10.h, 0.w, 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: Colors.white,
            boxShadow: [
              ShadowPalette.defaultShadowLight
            ]
          ),
         child: Column(
           children: [
             Text(
               assessment.question,
               style: TextStyle(
                 fontSize: 17.sp,
                 fontWeight: FontWeight.w900
               ),
             ),
             GetBuilder<AssessmentController>(
               builder: (controller) {
                 int? checked = widget.assessmentController.findSelected(widget.index);
                 if(checked != null){
                   _checkboxesController.selectIndex(checked);
                 }
                 return GroupButton(
                   controller: _checkboxesController,
                   isRadio: true,
                   options: const GroupButtonOptions(groupingType: GroupingType.column),
                   buttons: assessment.answers,
                   buttonIndexedBuilder: (selected, index, context) {
                     return CheckBoxTile(
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
        ElevatedButton(
            onPressed: moveFront,
            child: Text("다음")
        ),
        ElevatedButton(
            onPressed: moveBack,
            child: Text("이전")
        ),
      ],
    );
  }
}

class CheckBoxTile extends StatelessWidget {
  const CheckBoxTile({
    Key? key,
    required this.selected,
    required this.onTap,
    required this.title,
  }) : super(key: key);

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
      leading: Transform.scale(
        scale: 1.2,
        child: Checkbox(
          value: selected,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.w)
          ),
          activeColor: Colors.blueGrey,
          onChanged: (bool? value) {
            onTap();
          },
        ),
      ),
    );
  }
}