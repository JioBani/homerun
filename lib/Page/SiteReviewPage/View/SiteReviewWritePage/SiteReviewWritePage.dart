import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Page/SiteReviewPage/Controller/SiteReviewWritePageController.dart';
import 'package:homerun/Page/SiteReviewPage/Model/SiteReview.dart';
import 'package:homerun/Page/SiteReviewPage/View/SiteReviewWritePage/ImageListWidget.dart';
import 'package:homerun/Style/Fonts.dart';

import '../../Controller/controller.dart';

class SiteReviewWritePage extends StatefulWidget {
  const SiteReviewWritePage({super.key, required this.noticeId, this.updateTargetReview, this.isUpdateMode = false});
  final String noticeId;
  final SiteReview? updateTargetReview;
  final bool isUpdateMode;

  @override
  State<SiteReviewWritePage> createState() => _SiteReviewWritePageState();
}

class _SiteReviewWritePageState extends State<SiteReviewWritePage> {

  static const Color subTitleColor = Color(0xff767676);

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  late final SiteReviewWritePageController controller;


  @override
  void initState() {
    controller = Get.put(
        SiteReviewWritePageController(
            noticeId: widget.noticeId,
            updateTarget: widget.updateTargetReview,
            updateMode: widget.updateTargetReview != null
        )
    );

    if(widget.isUpdateMode){
      controller.getUploadedImages();
      titleController.text = widget.updateTargetReview!.title;
      contentController.text = widget.updateTargetReview!.content;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //#. Appbar
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

            },
            child: Text(
              "임시저장",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: subTitleColor
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w , vertical: 15.w),
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - (MediaQuery.of(context).padding.top + kToolbarHeight + kBottomNavigationBarHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //#. 제목
                  Padding(
                    padding: EdgeInsets.only(left: 2.w),
                    child: Text(
                      "제목",
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: subTitleColor
                      ),
                    ),
                  ),
                  SizedBox(height: 9.w,),
                  //#. 제목 입력
                  CustomTextFormField(
                    controller: titleController,
                    hintText: "제목을 입력해주세요",
                    maxLines: 1,
                  ),
                  SizedBox(height: 26.w,),
                  ImageListWidget(isUpdateMode: widget.isUpdateMode,),
                  //#. 본문
                  Padding(
                    padding: EdgeInsets.only(left: 2.w),
                    child: Text(
                      "본문",
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: subTitleColor
                      ),
                    ),
                  ),
                  //#. 본문 입력
                  SizedBox(height: 9.w,),
                   Expanded(
                    child: CustomTextFormField(
                      controller: contentController,
                      hintText: "리뷰 내용을 작성해주세요.",
                      maxLines: 30,
                    ),
                  ),
                  SizedBox(height: 14.w,),
                  SizedBox(height: 14.w,),
                  InkWell(
                    onTap: () {
                      if(widget.isUpdateMode){
                        controller.updateReview(titleController.text, contentController.text);
                      }
                      else{
                        controller.upload(titleController.text, contentController.text , context);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 30.w,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Center(
                        child: Text(
                          widget.isUpdateMode ? "수정완료" : "작성완료",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({super.key, required this.hintText, required this.maxLines, required this.controller});

  static const Color subTitleColor = Color(0xff767676);
  static const Color inputFillColor = Color(0xffFBFBFB);
  final String hintText;
  final int maxLines;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
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
