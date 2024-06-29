import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:homerun/Page/SiteReviewPage/Controller/SiteReviewWritePageController.dart';
import 'package:homerun/Style/Fonts.dart';
import 'package:homerun/Style/Images.dart';
import 'package:image_picker/image_picker.dart';

class SiteReviewWritePage extends StatefulWidget {
  SiteReviewWritePage({super.key});

  static const Color subTitleColor = Color(0xff767676);
  static const Color fillColor = Color(0xffFBFBFB);
  static const Color borderColor = Color(0xffA4A4A6);

  @override
  State<SiteReviewWritePage> createState() => _SiteReviewWritePageState();
}

class _SiteReviewWritePageState extends State<SiteReviewWritePage> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(SiteReviewWritePageController());
    return Scaffold(
      appBar:AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
             "글쓰기",
              style: TextStyle(
                  fontSize:  20.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: Fonts.BCCard,
                  color: Theme.of(context).primaryColor
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.addImage();
            },
            child: Text(
              "임시저장",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: SiteReviewWritePage.subTitleColor
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w , vertical: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 2.w),
                child: Text(
                  "제목",
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: SiteReviewWritePage.subTitleColor
                  ),
                ),
              ),
              SizedBox(height: 9.w,),
              CustomTextFormField(
                hintText: "제목을 입력해주세요",
                maxLines: 1,
              ),
              SizedBox(height: 26.w,),
              Padding(
                padding: EdgeInsets.only(left: 2.w),
                child: Text(
                  "본문",
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: SiteReviewWritePage.subTitleColor
                  ),
                ),
              ),
              SizedBox(height: 9.w,),
              Expanded(
                child: CustomTextFormField(
                  hintText: "리뷰 내용을 작성해주세요.",
                  maxLines: 30,
                ),
              ),
              SizedBox(height: 14.w,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 135.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      color: SiteReviewWritePage.fillColor,
                      borderRadius: BorderRadius.circular(5.r),
                      border: Border.all(color: SiteReviewWritePage.borderColor)
                    ),
                    child: Center(
                      child: Text(
                        "파일업로드",
                        style: TextStyle(
                          color: SiteReviewWritePage.subTitleColor,
                          fontSize: 15.sp
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 135.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                        color: SiteReviewWritePage.fillColor,
                        borderRadius: BorderRadius.circular(5.r),
                        border: Border.all(color: SiteReviewWritePage.borderColor)
                    ),
                    child: Center(
                      child: Text(
                        "파일업로드",
                        style: TextStyle(
                            color: SiteReviewWritePage.subTitleColor,
                            fontSize: 15.sp
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.w,),
              Container(
                width: double.infinity,
                height: 30.w,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(5.r),
                ),
                child: Center(
                  child: Text(
                    "작성완료",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              ),
              ImageListWidget()
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({super.key, required this.hintText, required this.maxLines});

  static const Color subTitleColor = Color(0xff767676);
  static const Color inputFillColor = Color(0xffFBFBFB);
  final String hintText;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      //controller: textEditingController,
      maxLines: maxLines,
      cursorColor: const Color(0xFF35C5F0),
      decoration: InputDecoration(
        filled: true,
        fillColor: inputFillColor,
        hintText: hintText,
        hintStyle: TextStyle(color: subTitleColor , fontSize: 15.sp),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: BorderSide(color: const Color(0xffA4A4A6),width: 1.sp),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: BorderSide(color: const Color(0xffA4A4A6),width: 1.sp),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 6.w),
      ),
      style: TextStyle(
          fontSize: 11.sp
      ),
    );
  }
}

class ImageListWidget extends StatelessWidget {
  const ImageListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<SiteReviewWritePageController>(
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
            color : const Color(0xffA4A4A6),
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


