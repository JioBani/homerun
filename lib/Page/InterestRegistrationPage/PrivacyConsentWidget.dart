import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:homerun/String/InterestRegistrationPrivacyConsentStrings.dart';
import 'package:homerun/Style/Palette.dart';

class PrivacyConsentWidget extends StatelessWidget {
  PrivacyConsentWidget({super.key, required this.houseName, required this.businessEntity});
  final Color borderColor = const Color(0xffA4A4A6);
  final String houseName;
  final String businessEntity;

  late final InterestRegistrationPrivacyConsentStrings strings = InterestRegistrationPrivacyConsentStrings(houseName: houseName);

  @override
  Widget build(BuildContext context) {

    final TextStyle boldStyle = TextStyle(
      fontSize: 9.sp,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );

    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color:borderColor,),
      ),
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.w,vertical: 10.w),
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: 9.sp,
                color: Palette.brightMode.darkText
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BasicContentWidget(strings: strings),
                  Gap(10.w),
                  ThirdPartiesContentWidget(strings: strings,businessEntity : businessEntity),
                  Gap(10.w),
                  EctContentWidget(strings: strings),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 개인정보 수집 및 이용동의
class BasicContentWidget extends StatelessWidget {
  const BasicContentWidget({super.key, required this.strings});

  final InterestRegistrationPrivacyConsentStrings strings;

  @override
  Widget build(BuildContext context) {

    final TextStyle subtitleStyle = TextStyle(
      fontSize: 11.sp,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).primaryColor,
    );


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "개인정보 수집 및 이용 동의",
          style: subtitleStyle,
        ),
        Gap(7.w),
        Text(strings.basicDescription),
        Gap(7.w),
        //#. 제공받는자
        ContentText(subTitle: strings.receiver, content: "청약홈런"),
        //#. 목적
        ContentText(subTitle: strings.purpose, content: strings.purposeContent),
        //#. 수집항목
        ContentText(subTitle: strings.collection, content: strings.collectionContent),
        //#. 보유 및 이용 기간
        ContentText(subTitle: strings.saveAndUsagePeriod, content: strings.saveAndUsagePeriodContent),
        Gap(15.w),
        const Divider()
      ],
    );
  }
}

/// 개인정보 수집 및 이용동의
class ThirdPartiesContentWidget extends StatelessWidget {
  const ThirdPartiesContentWidget({super.key, required this.strings, required this.businessEntity});

  final String businessEntity;
  final InterestRegistrationPrivacyConsentStrings strings;

  @override
  Widget build(BuildContext context) {

    final TextStyle subtitleStyle = TextStyle(
      fontSize: 11.sp,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).primaryColor,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "개인정보 제3자 제공 동의",
          style: subtitleStyle,
        ),
        Gap(7.w),
        Text(strings.thirdPartContent),
        Gap(7.w),
        //#. 제공받는자
        ContentText(subTitle: strings.receiver, content: businessEntity),
        //#. 목적
        ContentText(subTitle: strings.purpose, content: strings.purposeContent),
        //#. 수집항목
        ContentText(subTitle: strings.collection, content: strings.collectionContent),
        //#. 보유 및 이용 기간
        ContentText(subTitle: strings.saveAndUsagePeriod, content: strings.saveAndUsagePeriodContent),
        Gap(15.w),
        const Divider()
      ],
    );
  }
}

/// 기타 개인정보 관리
class EctContentWidget extends StatelessWidget {
  const EctContentWidget({super.key, required this.strings});

  final InterestRegistrationPrivacyConsentStrings strings;

  @override
  Widget build(BuildContext context) {

    final TextStyle subtitleStyle = TextStyle(
      fontSize: 11.sp,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).primaryColor,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "기타 개인정보 관련 안내",
          style: subtitleStyle,
        ),
        Gap(7.w),
        //#. 제공받는자
        EctContentTextWidget(subtitle: strings.rightInRowTitle, content: strings.rightInRow),
        EctContentTextWidget(subtitle: strings.rejectionRightTitle, content: strings.rejectionRight),
        EctContentTextWidget(subtitle: strings.etcSaveAndUsagePeriodTitle, content: strings.etcSaveAndUsagePeriodContent),
        EctContentTextWidget(subtitle: strings.deleteMethodTitle, content: strings.deleteMethod),
        EctContentTextWidget(subtitle: strings.shareTitle, content: strings.share),
        EctContentTextWidget(subtitle: strings.shareTitle, content: strings.share),
        EctContentTextWidget(subtitle: strings.rightToRejectAgreeTitle, content: strings.rejectionRight),
        EctContentTextWidget(subtitle: strings.optionalNotificationTitle, content: strings.optionalNotification),
        Gap(15.w),
      ],
    );
  }
}

class ContentText extends StatelessWidget {
  const ContentText({super.key, required this.subTitle, required this.content});
  final String subTitle;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: subTitle, style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            )),
            TextSpan(text: content, style: TextStyle(
              fontSize: 9.sp,
              color: Palette.brightMode.darkText
            )),
          ]
        ),
      ),
    );
  }
}

class EctContentTextWidget extends StatelessWidget {
  const EctContentTextWidget({super.key, required this.subtitle, required this.content});
  final String subtitle;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 7.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            )
          ),
          Gap(1.5.w),
          Text(
            content,
            style: TextStyle(
              fontSize: 9.sp,
              color: Palette.brightMode.darkText
            )
          ),
        ],
      ),
    );
  }
}


