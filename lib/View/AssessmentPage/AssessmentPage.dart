import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Controller/AssessmentController.dart';
import 'package:homerun/Model/AssessmentQuestion.dart';
import 'package:homerun/Service/AssessmentDataService.dart';
import 'package:homerun/Service/FirebaseFirestoreService.dart';
import 'package:homerun/View/buttom_nav.dart';
import 'QuestionWidget.dart';

class AssessmentPage extends StatefulWidget{
  const AssessmentPage({super.key});

  @override
  State<AssessmentPage> createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> with TickerProviderStateMixin{

  late AssessmentController assessmentController;

  @override
  void initState() {
    assessmentController = AssessmentController();
    Get.put(assessmentController);
    assessmentController.fetchAssessmentData();
    super.initState();
  }

  void loadAnswers(TabController tabController){
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
                  tabController.animateTo(assessmentController.nextQuestion);
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder(
          future: assessmentController.fetchAssessmentData(),
          builder: (context , snapshot) {
            if(snapshot.hasData){
              if(snapshot.data!){
                TabController _tabController =
                TabController(length: assessmentController.assessmentDto!.assessmentList.length + 1, vsync: this);
                return Column(
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
                              loadAnswers(_tabController);
                            },
                            icon: Icon(Icons.cloud_download_rounded)
                        ),
                        /*IconButton(
                            onPressed: (){
                              FirebaseFirestoreService.instance.uploadAssessment();
                            },
                            icon: Icon(Icons.add)
                        ),
                        IconButton(
                            onPressed: () async {
                              AssessmentDto? assessmentDto = await FirebaseFirestoreService.instance.getAssessmentDto();
                              if(assessmentDto != null){
                                StaticLogger.logger.i(assessmentDto.toJson());
                              }
                            },
                            icon: Icon(Icons.download_done)
                        ),*/
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(
                            assessmentController.assessmentDto!.assessmentList.length + 1,
                                (index){
                              if(index == assessmentController.assessmentDto!.assessmentList.length ){
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
                                    padding: EdgeInsets.only(left: 25.w , right: 25.w),
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
                );
              }
              else{
                return Center(
                  child: Text("데이터를 불러오지 못했습니다."),
                );
              }
            }
            else if(snapshot.hasError){
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            else{
              return Center(
                child: Text("로딩중"),
              );
            }

          }
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}