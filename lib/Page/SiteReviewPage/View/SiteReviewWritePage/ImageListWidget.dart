import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/Widget/Snackbar.dart';
import 'package:homerun/Common/model/Result.dart';

import '../../Controller/SiteReviewWritePageController.dart';

class ImageListWidget extends StatelessWidget {
  const ImageListWidget({super.key , this.isUpdateMode = false});
  final bool isUpdateMode;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SiteReviewWritePageController>(
        builder: (controller){
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
              Builder(builder: (context){
                if(isUpdateMode){
                  if(controller.updateImageLoading == LoadingState.loading){
                    return const Center(child: CupertinoActivityIndicator());
                  }
                  else if(controller.updateImageLoading == LoadingState.fail){
                    return const Text("글 정보를 가져 올 수 없습니다.");
                  }
                  else{
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children:[
                            ... controller.showImages.values.map((file){
                              if(file == null){
                                return const ErrorImageItem();
                              }
                              else{
                                return ImageListItem(name:file.name,);
                              }
                            }).toList(),
                            ImageUploadWidget(controller: controller,)
                          ]
                      ),
                    );
                  }
                }
                else{
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        children:[
                          ... controller.showImages.values.map((file){
                            if(file == null){
                              return const ErrorImageItem();
                            }
                            else{
                              return ImageListItem(name:file.name,);
                            }
                          }).toList(),
                          ImageUploadWidget(controller: controller,)
                        ]
                    ),
                  );
                }
              }),
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
    );
  }
}

class ImageListItem extends StatelessWidget {
  const ImageListItem({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<SiteReviewWritePageController>();
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 2.w, 13.w, 2.w),
      child: Container(
        width: 60.w,
        height: 60.w,
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
              child: Builder(
                builder: (context) {
                  if(controller.showImages[name] == null){
                    return Container(
                      width: 70.w,
                      height: 70.w,
                      color: Colors.grey,
                    );
                  }
                  else{
                    return Image.file(
                      File(controller.showImages[name]!.path),
                      width: 70.w,
                      height: 70.w,
                      fit: BoxFit.cover,
                    );
                  }
                }
              ),
            ),
            InkWell(
              onTap: (){
                controller.setThumbnail(name);
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(
                        color : controller.showImages[name] == controller.thumbnailFile
                            ? Theme.of(context).primaryColor
                            : const Color(0xffA4A4A6) ,
                        width:controller.showImages[name] == controller.thumbnailFile ? 3.sp : 0.5.sp
                    )
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4.w,right: 4.w),
              child: InkWell(
                onTap: (){
                  controller.removeImage(name);
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

class ErrorImageItem extends StatelessWidget {
  const ErrorImageItem({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<SiteReviewWritePageController>();
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 2.w, 13.w, 2.w),
      child: Container(
        width: 60.w,
        height: 60.w,
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
              child: Container(
                width: 70.w,
                height: 70.w,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//TODO 이미지가 겹치는 경우
class ImageUploadWidget extends StatelessWidget {
  const ImageUploadWidget({super.key, required this.controller});
  final SiteReviewWritePageController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 2.w, 13.w, 2.w),
      child: Container(
        width: 60.w,
        height: 60.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            border: Border.all(
                color: const Color(0xffA4A4A6) ,
                width: 0.5.sp
            )
        ),
        child: InkWell(
          onTap: () async {
            Result<void> result = await controller.addImage();
            if(!result.isSuccess){
              CustomSnackbar.show('오류', '이미지를 가져올 수 없습니다.');
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                  Icons.camera_alt
              ),
              SizedBox(height: 2.w,),
              const Text("사진 추가")
            ],
          ),
        ),
      ),
    );
  }
}


