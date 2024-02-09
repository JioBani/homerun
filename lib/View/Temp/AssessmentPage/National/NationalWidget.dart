import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Palette.dart';
import 'package:homerun/Style/ShadowPalette.dart';
import 'package:homerun/View/ad_widget.dart';

import 'CategoryButtomWidget.dart';

class NationalWidget extends StatefulWidget {
  const NationalWidget({super.key});

  @override
  State<NationalWidget> createState() => _NationalWidgetState();
}

class _NationalWidgetState extends State<NationalWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(25.w, 0, 25.w, 0),
        child: Column(
          children: [
            Text(
              "국민주택은 청약종합저축, 청약저축통장 가입자만 신청 할 수 있습니다.\n"
              "국민주택 유형을 선택해주세요.",
              style: TextStyle(
                fontSize: 32.w,
              ),
            ),
            SizedBox(height: 20.w,),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CategoryButtonWidget(),
                  CategoryButtonWidget(),
                  CategoryButtonWidget()
                ],
              ),
            ),
            SizedBox(height: 20.w,),
            Container(
              height: 220.w,
              width: double.infinity,
              margin: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: Palette.light,
                boxShadow: [
                  ShadowPalette.defaultShadowLight
                ],
                borderRadius: BorderRadius.circular(20.w),
              ),
              child: Center(
                child: Text("광고",
                  style: TextStyle(
                    fontSize: 30.w,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ),
            AdWidget(content: "청약홈런이 작성하는\n프리미엄 분양정보"),
            AdWidget(content: "청약홈런이 작성하는\n프리미엄 분양정보"),
            AdWidget(content: "청약홈런이 작성하는\n프리미엄 분양정보"),
          ],
        ),
      ),
    );
  }
}
