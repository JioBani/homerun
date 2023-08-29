import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Style/ShadowPalette.dart';
import 'package:homerun/View/MyPage/QuestionPage/QuestionCategoryButtonWidget.dart';

import 'QuestionListWidget.dart';

class QuestionPage extends StatelessWidget {
  const QuestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "자주 묻는 질문",
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 42.sp
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Divider(),
              Container(
                margin: EdgeInsets.fromLTRB(30.w, 10.w, 30.w, 10.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    ShadowPalette.defaultShadow
                  ]
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 150.w,
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          "자주 묻는 질문",
                          style: TextStyle(
                              fontSize: 45.sp,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                      ),
                    ),
                    const Divider(
                      color: Colors.black45,
                      thickness: 3,
                    ),
                    const Wrap(
                      children: [
                        QuestionCategoryButtonWidget(),
                        QuestionCategoryButtonWidget(),
                        QuestionCategoryButtonWidget(),
                        QuestionCategoryButtonWidget(),
                        QuestionCategoryButtonWidget(),
                        QuestionCategoryButtonWidget(),
                        QuestionCategoryButtonWidget(),
                        QuestionCategoryButtonWidget(),
                      ],
                    ),
                    const Divider(
                      color: Colors.black45,
                      thickness: 3,
                    ),
                    const Divider(
                      color: Colors.black45,
                      thickness: 1,
                    ),
                    QuestionListWidget(),
                    const Divider(
                      color: Colors.black45,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
