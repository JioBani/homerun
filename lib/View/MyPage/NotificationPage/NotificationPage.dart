import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Controller/MyPage/NotificationPageController.dart';

import 'NotificationItemWidget.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationPageController controller = Get.put(NotificationPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "공지사항",
          style: TextStyle(
            fontSize: 40.sp,
            fontWeight: FontWeight.w700
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Divider(),
            GetX<NotificationPageController>(
              builder: (controller) {
                if (controller.notificationList.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        controller.getNotificationData();
                      },
                      child: ListView.builder(
                      itemCount: controller.notificationList.length,
                        itemBuilder: (context , index){
                          return NotificationItemWidget(
                            notificationData: controller.notificationList[index],
                          );
                        }
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
