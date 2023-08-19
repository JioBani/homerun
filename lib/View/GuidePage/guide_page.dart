

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:homerun/Controller/guide_page_controller.dart';
import 'package:homerun/View/GuidePage/item_box_widget.dart';
import 'package:logger/logger.dart';

import '../../Palette.dart';

class GuidePage extends StatefulWidget {
  GuidePage({super.key});

  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  final GuidePageController guidePageController = Get.put(GuidePageController());

  double iconSize = 65.w;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 50.w),
                height: 100.w,
                width: double.infinity,
                child: Center(
                  child: Text(
                    "청약길잡이",
                    style: TextStyle(
                      fontSize: 40.w,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              const DefaultTabController(
                  length: 3,
                  child: TabBar(
                    tabs: [
                      Tab(child: Text("국민주택"),),
                      Tab(child: Text("민영분양"),),
                      Tab(child: Text("신혼홈타운"),),
                    ],
                  )
              ),
              GetX<GuidePageController>(
                builder: (controller) {
                  if (controller.productDatas.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                            itemCount: controller.productDatas.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (context , index){
                                return ItemBoxWidget(productData: controller.productDatas[index] , controller: controller,);
                              }
                          ),
                        ),
                    );
                    /*return Expanded(
                      child: RefreshIndicator(
                        onRefresh: controller.getData,
                        child: ListView.builder(
                          itemCount: controller.productDatas.length,
                          itemBuilder: (context, index) {
                            var userData = controller.productDatas[index];
                            return ListTile(
                              title: Text(userData.name),
                              subtitle: Text(userData.price.toString()),
                            );
                          },
                        ),
                      ),
                    );*/
                  }
                },
              )
            ],
          )
      ),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.fromLTRB(10.w, 0, 10.w, 20.w),
          height: 100.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(onPressed: ()=>{}, icon: Icon(Icons.home , size:iconSize)),
              IconButton(onPressed: ()=>{}, icon: Icon(Icons.telegram, size:iconSize)),
              IconButton(onPressed: ()=>{}, icon: Icon(Icons.sd_card, size:iconSize)),
              IconButton(onPressed: ()=>{}, icon: Icon(Icons.file_copy, size:iconSize)),
              IconButton(onPressed: ()=>{}, icon: Icon(Icons.people, size:iconSize)),

            ],
          ),
          /*child: const DefaultTabController(
            length: 4,
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Colors.red,
              indicatorWeight: 2,
              labelColor: Colors.red,
              unselectedLabelColor: Colors.black38,
                labelStyle: TextStyle(
                  fontSize: 13,
                ),
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.home_outlined,
                  ),
                  text: 'Home',
                ),
                Tab(
                  icon: Icon(Icons.music_note),
                  text: 'Music',
                ),
                Tab(
                  icon: Icon(
                    Icons.apps,
                  ),
                  text: 'Apps',
                ),
                Tab(
                  icon: Icon(
                    Icons.settings,
                  ),
                  text: 'Settings',
                )
              ],
            ),
          ),*/
        ),
      ),
    );
  }
}
