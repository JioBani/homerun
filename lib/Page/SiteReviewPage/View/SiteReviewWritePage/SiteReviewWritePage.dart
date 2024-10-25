import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Widget/CustomDialog.dart';
import 'package:homerun/Page/SiteReviewPage/Controller/SiteReviewWritePageController.dart';
import 'package:homerun/Page/SiteReviewPage/Model/SiteReview.dart';
import 'package:homerun/Page/SiteReviewPage/View/SiteReviewWritePage/ImageListWidget.dart';
import 'package:homerun/Style/Fonts.dart';
import 'package:homerun/Style/Palette.dart';

//TODO 사용자 경험 문제
// - 업로드시 다이얼로그가 진행 될 때 마다 키보드가 올라왔따 내려갔다 함
// - s22에서 작성할때의 글씨가 전반적으로 작음
// - 등록 버튼등의 크기를 수정해야할거 같음
//#. 앱 크기가 커지면 pagedListview로 변경
class SiteReviewWritePage extends StatefulWidget {
  const SiteReviewWritePage({
    super.key,
    required this.noticeId,
    this.updateTargetReview,
    this.isUpdateMode = false,
  });

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
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode contentFocusNode = FocusNode();

  late final SiteReviewWritePageController controller;


  @override
  void initState() {
    controller = Get.put(
      SiteReviewWritePageController(
        titleController : titleController,
        contentController : contentController,
        titleFocusNode : titleFocusNode,
        contentFocusNode : contentFocusNode,
        noticeId: widget.noticeId,
        updateTarget: widget.updateTargetReview,
        updateMode: widget.updateTargetReview != null,
      ),
    );

    if(widget.isUpdateMode){
      controller.setUploadedData(context);
      titleController.text = widget.updateTargetReview!.title;
      contentController.text = widget.updateTargetReview!.content;
    }
    else{
      controller.loadTempReview(context);
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
              controller.saveReview(context);
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
                    focusNode: titleFocusNode,
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
                      focusNode: contentFocusNode,
                    ),
                  ),
                  SizedBox(height: 14.w,),
                  SizedBox(height: 14.w,),
                  InkWell(
                    onTap: () {
                      titleFocusNode.unfocus();
                      contentFocusNode.unfocus();
                      CustomDialog.show(
                          builder: (dialogContext){
                            if(widget.isUpdateMode) {
                              return ConfirmDialog(
                                onConfirm: (){
                                  controller.updateReview(titleController.text, contentController.text , context);
                                },
                                title: "수정하시겠습니까?",
                                dialogContext: dialogContext
                              );
                            }
                            else{
                              return ConfirmDialog(
                                onConfirm: (){
                                  controller.upload(titleController.text, contentController.text , context);
                                },
                                title: "등록하시겠습니까?",
                                dialogContext: dialogContext
                              );
                            }
                          },
                          context: context
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 40.w,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Center(
                        child: Text(
                          widget.isUpdateMode ? "수정완료" : "작성완료",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.sp,
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

//TODO 안쪽 색 변경 필요할거 같음
class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.maxLines,
    required this.controller,
    this.focusNode
  });

  static const Color subTitleColor = Color(0xff767676);
  static const Color inputFillColor = Colors.white;
  final String hintText;
  final int maxLines;
  final TextEditingController controller;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      maxLines: maxLines,
      cursorColor: const Color(0xFF35C5F0),
      decoration: InputDecoration(
        filled: true,
        fillColor: inputFillColor,
        hintText: hintText,
        hintStyle: TextStyle(color: subTitleColor , fontSize: 15.sp),
        //labelStyle: TextStyle(fontSize: 15.sp),
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
        fontSize: 15.sp
      ),
    );
  }
}

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.onConfirm,
    required this.title,
    required this.dialogContext
  });

  final Function() onConfirm;
  final String title;
  final BuildContext dialogContext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14.sp,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: ()  {
                  if(dialogContext.mounted){
                    Navigator.pop(context);
                  }
                  onConfirm();
                },
                child: Container(
                  width: 75.w,
                  height: 25.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r),
                    color: Theme.of(dialogContext).primaryColor,
                  ),
                  child: Center(
                    child: Text(
                      "예",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12.sp,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15.w,),
              InkWell(
                onTap: ()  {
                  if(dialogContext.mounted){
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  width: 75.w,
                  height: 25.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r),
                    color: Palette.brightMode.lightText,
                  ),
                  child: Center(
                    child: Text(
                      "아니오",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12.sp,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

