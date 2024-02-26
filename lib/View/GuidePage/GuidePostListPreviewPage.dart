import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Controller/GuidePage/GuidePageController.dart';
import 'package:homerun/Model/GuidePostData.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:homerun/View/GuidePage/PostPreviewWidget.dart';

class GuidePostListPreviewPage extends StatefulWidget {
  const GuidePostListPreviewPage({super.key, required this.type});
  final String type;

  @override
  State<GuidePostListPreviewPage> createState() => _GuidePostListPreviewPageState();
}

class _GuidePostListPreviewPageState extends State<GuidePostListPreviewPage> with AutomaticKeepAliveClientMixin{



  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;


  GuidePageController controller = Get.find<GuidePageController>();

  Future<int?> initData() async {
    if(!controller.isDataFetched(widget.type)){
      return await controller.getPost(widget.type, 4);
    }
    else{
      return controller.guidePostListMap[widget.type]!.length;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "#${widget.type} 길잡이",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20.sp,
              color: Palette.font.blue,
            ),
          ),
        ),
        SizedBox(height: 9,),
        FutureBuilder(
            future: initData(),
            builder: (context , snapshot){
              if(snapshot.hasData){
                int? data = snapshot.data;

                if(data == null){
                  return Text("데이터를 가져 올 수 없습니다.");
                }
                else if(data == 0){
                  return Text("데이터가 없습니다.");
                }
                else{
                  return Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              PostPreviewWidget(
                                width: 150.w,
                                guidePostData: controller.guidePostListMap[widget.type]![0],
                              ),
                              SizedBox(width: 5.w,),
                              PostPreviewWidget(
                                width: 150.w,
                                guidePostData: controller.guidePostListMap[widget.type]![1],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        Expanded(
                          child: Row(
                            children: [
                              PostPreviewWidget(
                                width: 150.w,
                                guidePostData: controller.guidePostListMap[widget.type]![2],
                              ),
                              SizedBox(width: 5.w,),
                              PostPreviewWidget(
                                width: 150.w,
                                guidePostData: controller.guidePostListMap[widget.type]![3],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                      ],
                    ),
                  );
                }
              }
              else if(snapshot.hasError){
                return Text("데이터를 가져 올 수 없습니다.");
              }else{
                return CupertinoActivityIndicator();
              }
            }
        ),
      ],
    );


  }
}
