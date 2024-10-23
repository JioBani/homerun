import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:homerun/Page/InterestRegistrationPage/InterestRegistrationPageController.dart';
import 'package:homerun/Page/InterestRegistrationPage/PrivacyConsentWidget.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:homerun/Style/TestImages.dart';

class InterestRegistrationPage extends StatelessWidget {
  InterestRegistrationPage({super.key, required this.houseName});
  final String houseName;
  final Color borderColor = const Color(0xffA4A4A6);

  final InterestRegistrationPageController controller = InterestRegistrationPageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor : Colors.white,
        titleSpacing: 0,
        shadowColor: Colors.black.withOpacity(0.5),
        title: AutoSizeText(
          "$houseName 관심등록",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).primaryColor
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Container(
              margin: EdgeInsets.only(top: 20.w, bottom: 20.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: Palette.baseColor,
                border: Border.all(color: borderColor, width: 0.3)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Image.asset(
                          TestImages.apt,
                          width: 320.w,
                          height: 320.w,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.w, bottom: 10.w),
                          child: Text(
                            houseName,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 30.sp,
                              color: Colors.white
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Gap(20.w),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "이름",
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: Palette.brightMode.darkText

                          ),
                        ),
                        Gap(5.w),
                        TextFormField(
                          controller: controller.nameController,
                          decoration: InputDecoration(
                            hintText: "이름을 입력해주세요.",
                            hintStyle: TextStyle(
                                color: borderColor,
                                fontSize: 12.sp
                            ),
                            focusedBorder : OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: borderColor,
                                )
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: borderColor,
                                )
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 7.w, horizontal: 10.w),
                            isDense: true,
                          ),
                          style: TextStyle(decorationThickness: 0),
                        ),
                        Gap(17.w),
                        //#. 연락처
                        Text(
                          "연락처",
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: Palette.brightMode.darkText

                          ),
                        ),
                        Gap(5.w),
                        //#. 이름
                        TextFormField(
                          controller: controller.phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: "이름을 입력해주세요.",
                            hintStyle: TextStyle(
                              color: borderColor,
                              fontSize: 12.sp
                            ),
                            focusedBorder : OutlineInputBorder(
                              borderSide: BorderSide(
                              color: borderColor,
                              )
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: borderColor,
                              )
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 7.w, horizontal: 10.w),
                            isDense: true,
                          ),
                          style: const TextStyle(decorationThickness: 0),
                        ),
                        Gap(17.w),
                        //#. 개인정보 수집 동의
                        Text(
                          "개인정보 수집 및 이용 동의",
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Palette.brightMode.darkText
                          ),
                        ),
                        Gap(6.w),
                        //#. 동의 버튼
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomCheckBoxWidget(
                              initValue: false,
                              onChanged: (value){
                                controller.setAgree(value);
                              },
                            ),
                            Gap(8.w),
                            Text(
                              "(필수)동의",
                              //"AD",
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.redAccent,
                                textBaseline: TextBaseline.ideographic,
                              ),
                            ),
                          ],
                        ),
                        Gap(7.w),
                        //#. 동의 내용
                        PrivacyConsentWidget(houseName: houseName , businessEntity: "멋지다시행사",),
                        Gap(20.w),
                        //#. 관심등록 버튼
                        InkWell(
                          onTap: (){
                            controller.submit(context);
                          },
                          child: Container(
                            height: 40.w,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: Center(
                              child: Text(
                                "관심등록",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                            ),
                          ),
                        ),
                        Gap(20.w),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}

class CustomCheckBoxWidget extends StatefulWidget {
  const CustomCheckBoxWidget({super.key, required this.initValue, required this.onChanged});
  final bool initValue;
  final Function(bool value) onChanged;

  @override
  State<CustomCheckBoxWidget> createState() => _CustomCheckBoxWidgetState();
}

class _CustomCheckBoxWidgetState extends State<CustomCheckBoxWidget> {

  late bool value = widget.initValue;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        setState(() {
          value = !value;
          widget.onChanged(value);
        });
      },
      child: Container(
        width: 17.sp,
        height: 17.sp,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.r),
          color: Colors.white,
          border: Border.all(color:const Color(0xffA4A4A6),)
        ),
        child: Builder(
          builder: (context){
            return Center(
              child: value ?
              Icon(Icons.check , color: Theme.of(context).primaryColor, size: 15.sp,) :
              const SizedBox.shrink(),
            );
          }
        ),
      ),
    );
  }
}
