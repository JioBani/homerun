import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Page/SiteReviewPage/Controller/SiteReviewWritePageController.dart';

class ImageListWidget extends StatelessWidget {
  const ImageListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SiteReviewWritePageController>(
        builder: (controller){
          if(controller.images.isNotEmpty){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "이미지",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xff767676),
                      fontSize: 16.sp
                  ),
                ),
                SizedBox(height: 2.w,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    //scrollDirection : Axis.horizontal,
                      children: List.generate(controller.images.length, (index) => ImageListItem(index: index,))
                  ),
                ),
                SizedBox(height: 2.w,),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "(${controller.images.length}/10)",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                          fontSize: 12.sp
                        ),
                      ),
                      Text(
                        "  ,  ",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor,
                            fontSize: 12.sp
                        ),
                      ),
                      Text(
                        "(${controller.imageSize.toStringAsFixed(2)}MB/10MB)",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor,
                            fontSize: 12.sp
                        ),
                      ),
                    ],
                  )
                ),
                SizedBox(height: 10.w,),
              ],
            );
          }
          else{
            return SizedBox();
          }
        }
    );
  }
}

class ImageListItem extends StatelessWidget {
  const ImageListItem({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<SiteReviewWritePageController>();
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 2.w, 13.w, 2.w),
      child: Container(
        width: 70.w,
        height: 70.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            border: Border.all(
                color: const Color(0xffA4A4A6) ,
                width: 0.5.sp
            )
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5.r),
              child: Image.file(
                File(controller.images[index].path),
                width: 70.w,
                height: 70.w,
                fit: BoxFit.cover,
              ),
            ),
            InkWell(
              onTap: (){
                controller.setThumbnail(index);
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(
                        color : controller.images[index] == controller.thumbnailFile.value ? Theme.of(context).primaryColor : const Color(0xffA4A4A6) ,
                        width: controller.images[index] == controller.thumbnailFile.value ? 3.sp : 0.5.sp
                    )
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4.w,right: 4.w),
              child: InkWell(
                onTap: (){
                  controller.removeImage(index);
                },
                child: Container(//TODO 이미지로 교체하기?
                    width: 16.w,
                    height: 16.w,
                    decoration: BoxDecoration(
                        color: Color(0xff565555),
                        borderRadius: BorderRadius.circular(16.w)
                    ),
                    child: Icon(
                      Icons.close,
                      size: 16.w,
                      color: Colors.grey,
                    )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

