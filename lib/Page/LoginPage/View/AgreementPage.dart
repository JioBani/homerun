import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:homerun/Style/Palette.dart';

class AgreementPage extends StatelessWidget {
  const AgreementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 78.w,),
              //#. 환영합니다 텍스트
              Text(
                "환영합니다.",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xff3F3D3D)
                ),
              ),
              SizedBox(height: 7.w,),
              //#. 동의 텍스트
              Text(
                "원활한 서비스 이용을 위해 동의해주세요.",
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.normal,
                  color: const Color(0xff3F3D3D)
                ),
              ),
              SizedBox(height: 28.w,),
              //#. 모두 동의하기 버튼
              InkWell(
                onTap: (){},
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 25.w),
                  height: 40.w,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xffFBFBFB),
                    borderRadius: BorderRadius.circular(3.r),
                    border: GradientBoxBorder(
                      gradient: const LinearGradient(colors: [Color(0xff35C5F0), Color(0xffFF9C32)]),
                      width: 1.5.w,
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle ,
                          color: Palette.defaultOrange,
                          size: 20.sp,
                        ), //TODO 카카오 아이콘으로 변경
                        SizedBox(width: 8.w,),
                        Text(
                          "모두 동의하기",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Palette.brightMode.darkText
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40.w,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Column(
                  children: [
                    AgreementItemWidget(
                      name: '만 14세 이상입니다.',
                      content: '',
                    ),
                    AgreementItemWidget(
                      name: '만 14세 이상입니다.',
                      content: '',
                    ),
                    AgreementItemWidget(
                      name: '만 14세 이상입니다.',
                      content: '',
                      optional: true,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () => {},
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 25.w),
                  height: 40.w,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [BoxShadow(
                      color: Colors.black.withOpacity(0.25) ,
                      offset: Offset(0,2.w),
                      blurRadius: 2.r
                    )]
                  ),
                  child: Center(
                    child: Text(
                      "동의하고 계속하기",
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 36.w,)
            ],
          ),
        ),
      ),
    );
  }
}

class AgreementItemWidget extends StatelessWidget {
  const AgreementItemWidget({
    super.key,
    required this.name,
    required this.content,
    this.optional = false
  });

  final String name;
  final String content;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.5.w),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline ,
            color: Palette.defaultOrange,
            size: 20.sp,
          ), //TODO 카카오 아이콘으로 변경
          SizedBox(width: 4.w,),
          Text(
            "$name (${optional ? '선택' : '필수'})",
            style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: Palette.brightMode.darkText
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: (){

            },
            child: RichText(
              text: TextSpan(
                text: "보기",
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xffA4A4A6),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

