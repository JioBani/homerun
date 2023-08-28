import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:homerun/Controller/AssessmentSurveyPageController.dart';
import 'package:homerun/Style/ShadowPalette.dart';
import 'package:homerun/View/AssessmentServeyPage/ProgressBoxWidget.dart';
import 'package:homerun/View/AssessmentServeyPage/SurveyWidget/SurveyWidget.dart';


import 'CategoryButtonTableWidget/CategoryButtonTableWidget.dart';

class AssessmentSurveyPage extends StatefulWidget {
  const AssessmentSurveyPage({super.key});

  @override
  State<AssessmentSurveyPage> createState() => _AssessmentSurveyPageState();
}

class _AssessmentSurveyPageState extends State<AssessmentSurveyPage> {

  final ScrollController _scrollController = ScrollController();
  AssessmentSurveyPageController controller = Get.put(AssessmentSurveyPageController());
  bool isChecked = false;
  var listViewKey = GlobalKey();
  bool _open = false;

  _AssessmentSurveyPageState(){
    controller.setScrollController(_scrollController);
    controller.setListViewKey(listViewKey);
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('국민주택',
            style: TextStyle(
            fontSize: 40.w,
            fontWeight: FontWeight.w600
          ),
        ), // 화면 제목
        centerTitle: true, // 제목을 가운데로 정렬
        actions: <Widget>[
          // 오른쪽 끝에 아이콘 버튼 추가
          IconButton(
            icon: Icon(Icons.import_export),
            onPressed: () {
              controller.loadData();
            },
            iconSize: 60.w,
          ),
        ],
      ),
      body: SafeArea(
          child: ListView(
            key : listViewKey,
            controller: _scrollController,
            children: [
              Container(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("특별공급",
                        style: TextStyle(
                            fontSize: 30.w,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      CategoryButtonTableWidget(),
                      SizedBox(height: 20.w,),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ProgressBoxWidget(content: "기본질문서"),
                  ProgressBoxWidget(content: "추가질문서",),
                  ProgressBoxWidget(content: "자격진단결과",),
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
                padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.w),
                  boxShadow: [ShadowPalette.defaultShadowLight],
                  color: Colors.white
                ),
                child: Text(
                  "기본자격  질문서입니다.\n"
                      "각 문항별 해당하는 부분에 체크해주세요\n"
                      "가급적 세부내용 확인후 체크하시면 정확하게 진단이 가능합니다.",
                  style: TextStyle(
                      fontSize: 30.w,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),
              SurveyListWidget(questionDatas: controller.getQuestionData()),
            ],
          )
      ),
    );
  }

  void _scrollToSelectedContent(bool isExpanded, double previousOffset, int index, GlobalKey myKey) {
    final keyContext = myKey.currentContext;

    if (keyContext != null) {
      // make sure that your widget is visible
      final box = keyContext.findRenderObject() as RenderBox;
      if(isExpanded){
        _scrollController.animateTo(isExpanded ? (box.size.height * index) : previousOffset,
            duration: Duration(milliseconds: 500), curve: Curves.linear);
      }

    }
  }

  List<Widget> _buildExpansionTileChildren() => [
    FlutterLogo(
      size: 50.0,
    ),
    Text(
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse vulputate arcu interdum lacus pulvinar aliquam. Donec ut nunc eleifend, volutpat tellus vel, volutpat libero. Vestibulum et eros lorem. Nam ut lacus sagittis, varius risus faucibus, lobortis arcu. Nullam tempor vehicula nibh et ornare. Etiam interdum tellus ut metus faucibus semper. Aliquam quis ullamcorper urna, non semper purus. Mauris luctus quam enim, ut ornare magna vestibulum vel. Donec consectetur, quam a mattis tincidunt, augue nisi bibendum est, quis viverra risus odio ac ligula. Nullam vitae urna malesuada magna imperdiet faucibus non et nunc. Integer magna nisi, dictum a tempus in, bibendum quis nisi. Aliquam imperdiet metus id metus rutrum scelerisque. Morbi at nisi nec risus accumsan tempus. Curabitur non sem sit amet tellus eleifend tincidunt. Pellentesque sed lacus orci.',
      textAlign: TextAlign.justify,
    ),
  ];

  ExpansionTile _buildExpansionTile(int index) {
    final GlobalKey expansionTileKey = GlobalKey();
    double previousOffset = 0;

    return ExpansionTile(
      key: expansionTileKey,
      onExpansionChanged: (isExpanded) {
        if (isExpanded) previousOffset = _scrollController.offset;
        _scrollToSelectedContent(isExpanded, previousOffset, index, expansionTileKey);
      },
      title: Text('My expansion tile $index'),
      children: _buildExpansionTileChildren(),
    );
  }
}
