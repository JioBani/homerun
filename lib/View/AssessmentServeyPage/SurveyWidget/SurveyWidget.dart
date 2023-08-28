import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Widget/FoldableWidget.dart';
import 'package:homerun/Controller/AssessmentSurveyPageController.dart';
import 'package:homerun/Model/SurveyQuestionData.dart';
import 'package:homerun/Style/ShadowPalette.dart';
import 'package:homerun/View/AssessmentServeyPage/CheckBoxWidget/CheckBoxWidget.dart';

class SurveyListWidget extends StatefulWidget {

  SurveyListWidget({
    super.key,
    required this.questionDatas
  });

  final List<SurveyQuestionData> questionDatas;


  @override
  State<SurveyListWidget> createState() => _SurveyListWidgetState();
}

class _SurveyListWidgetState extends State<SurveyListWidget> {
  AssessmentSurveyPageController controller = Get.find<AssessmentSurveyPageController>();
  late List<FoldableWidget> widgetList;

  late List<GlobalKey> foldKey;

  late List<FoldableWidgetKey> foldWidgetKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setWidget();
  }

  //#. 수정시 핫 리로드를 위해 build에서 호출, 수정 완료시 initState에서 호출
  void setWidget(){
    foldKey = List.generate(widget.questionDatas.length, (index) => GlobalKey());
    foldWidgetKey =  List.generate(widget.questionDatas.length, (index) => FoldableWidgetKey());

    widgetList = List.generate(widget.questionDatas.length, (index) => FoldableWidget(
      foldableWidgetKey : foldWidgetKey[index],
      title: Text(
        widget.questionDatas[index].title,
        style: TextStyle(
            fontSize: 35.w,
            fontWeight: FontWeight.w700
        ),
      ),
      subTitle: GetX<AssessmentSurveyPageController>(
        builder: (context) {
          int select = controller.getCheck(index);
          return Text(
            controller.getContent(index, widget.questionDatas[index]),
            style: TextStyle(
                fontSize: 30.w,
                fontWeight: FontWeight.w500
            ),
          );
        }
      ),
      duration: const Duration(milliseconds: 350),
      onFoldStageChange: (value){
        if(value){
          for(int i = 0; i< foldWidgetKey.length; i++){
            if(i != index && foldWidgetKey[i].isOpen!()){
              foldWidgetKey[i].setClose!();
            }
          }
          /*controller.scrollController.animateTo(
              controller.getWidgetPositionY(foldKey[index], context) + controller.scrollController.offset,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOutQuad
          );*/
        }
      },
      margin: EdgeInsets.fromLTRB(15.w, 0, 15.w, 0),
      key: foldKey[index],
      child: IntrinsicHeight(
        child: Builder(
            builder: (context) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    width: 600.w,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.w),
                        boxShadow: [
                          ShadowPalette.defaultShadowLight
                        ]
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10.w),
                          child: Text(
                              widget.questionDatas[index].title,
                              style: TextStyle(
                                  fontSize: 35.w,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black
                              )
                          ),
                        ),
                        Builder(
                            builder: (context) {
                              List<CheckBoxWidget> checkBoxList = [];

                              for(int i =0; i< widget.questionDatas[index].questions.length; i++){
                                checkBoxList.add(CheckBoxWidget(
                                  description: widget.questionDatas[index].questions[i],
                                  index: i,
                                  surveyIndex: index,
                                ));
                              }

                              return Column(
                                children: checkBoxList,
                              );
                            }
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 195.w,
                    height: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.w),
                        boxShadow: [ShadowPalette.defaultShadowLight]
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.search,
                            size: 100.w,
                          ),
                          onPressed: (){},
                        ),
                        SizedBox(height: 20.h,),
                        Text(
                          "세부내용\n알아보기",
                          style: TextStyle(
                            fontSize: 30.w,
                            fontWeight: FontWeight.w600
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            }
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    setWidget();

    return Column(
      children: widgetList
    );
  }
}
