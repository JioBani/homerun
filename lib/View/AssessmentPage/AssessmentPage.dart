import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Controller/AssessmentController.dart';
import 'package:homerun/Service/AssessmentDataService.dart';

import '../buttom_nav.dart';
import 'AssessmentQuestion.dart';
import 'QuestionWidget.dart';

class AssessmentPage extends StatefulWidget{
  const AssessmentPage({super.key});

  @override
  State<AssessmentPage> createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> with TickerProviderStateMixin{
  late TabController _tabController;
  late AssessmentController assessmentController;

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: Assessment.questions.length + 1, vsync: this);
    assessmentController = AssessmentController(questions: Assessment.questions);
    Get.put(assessmentController);
    super.initState();
  }

  void loadAnswers(){
    showDialog(
      context: context,
      barrierDismissible: true, //바깥 영역 터치시 닫을지 여부 결정
      builder: ((context) {
        return AlertDialog(
          title: Text(
            "진행상황을 불러올까요?",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18.sp,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); //창 닫기
              },
              child: Text("아니요"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); //창 닫기
                int? result = await assessmentController.loadAnswers();

                if(result != null){
                  _tabController.animateTo(assessmentController.nextQuestion);
                }
                else{
                  Fluttertoast.showToast(msg: "진행상황을 불러 올 수 없습니다.");
                }
              },
              child: Text("네"),
            ),
          ],
        );
      }),
    );
  }

  void saveAnswers(){
    showDialog(
      context: context,
      barrierDismissible: true, //바깥 영역 터치시 닫을지 여부 결정
      builder: ((context) {
        return AlertDialog(
          title: Text(
            "진행상황을 저장할까요?",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18.sp,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); //창 닫기
              },
              child: Text("아니요"),
            ),
            TextButton(
              onPressed: () async {
                assessmentController.saveAnswers().then((value) => Navigator.of(context).pop());
              },
              child: Text("네"),
            ),
          ],
        );
      }),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: (){
                      saveAnswers();
                    },
                    icon: Icon(Icons.upload)
                ),
                IconButton(
                    onPressed: (){
                      loadAnswers();
                    },
                    icon: Icon(Icons.cloud_download_rounded)
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: List.generate(
                    Assessment.questions.length + 1,
                      (index){
                        if(index == Assessment.questions.length ){
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    onPressed: (){
                                      StaticLogger.logger.i("[AssessmentPage] ${assessmentController.print()}");
                                    },
                                    child: Text("결과 출력")
                                ),
                                ElevatedButton(
                                    onPressed: (){
                                      AssessmentDataService.saveAnswer(
                                          assessmentController.getProgress()
                                      );
                                    },
                                    child: Text("결과 저장하기")
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      Get.find<AssessmentController>().loadAnswers();
                                    },
                                    child: Text("결과 불러오기")
                                ),
                                ElevatedButton(
                                    onPressed: (){
                                      StaticLogger.logger.i("[AssessmentPage] ${assessmentController.print()}");
                                    },
                                    child: Text("결과 삭제하기")
                                ),
                              ],
                            ),
                          );
                        }
                        else{
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.only(left: 10.w , right: 10.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GetBuilder<AssessmentController>(
                                    builder: (controller) {
                                      return QuestionWidget(
                                        tabController: _tabController,
                                        assessmentController: assessmentController,
                                        index: index,
                                        selected: controller.findSelected(index),
                                      );
                                    }
                                  ),
                                  SizedBox(height: 10.w,),
                                ],
                              ),
                            ),
                          );
                        }
                      }
                  ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}

class RadioTile extends StatelessWidget {
  const RadioTile({
    Key? key,
    required this.selected,
    required this.onTap,
    required this.index,
    required this.title,
  }) : super(key: key);

  final String title;
  final int index;
  final int? selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
      leading: Radio<int>(
        groupValue: selected,
        value: index,
        onChanged: (val) {
          onTap();
        },
      ),
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
              borderRadius: BorderRadius.circular(7.w)
          ),
          activeColor: Colors.blueGrey,
          onChanged: (bool? value) {
            onTap();
          },
        ),
      ),
      /*leading: Checkbox(
        value: selected,
        onChanged: (val) {
          onTap();
        },
      ),*/
    );
  }
}
