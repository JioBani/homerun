import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:homerun/Feature/Notice/Model/ApplyHomeDto.dart';
import 'package:homerun/Feature/Notice/Model/AptDetailsInfo.dart';
import 'package:homerun/Page/AnnouncementPage/Model/AnnouncementDto.dart';
import 'package:homerun/Page/NoticePage/View/InfoBoxWidget.dart';
import 'package:homerun/Page/NoticePage/View/SubTitleWidget.dart';
import 'package:homerun/Style/Palette.dart';

import 'ContentBoxWidget.dart';

//TODO 디자인 수정 및 데이터 불러오기 적용해야함 (회의 필요)
class SupplyScaleInfoWidget extends StatelessWidget {
  const SupplyScaleInfoWidget({super.key, required this.applyHomeDto});
  final ApplyHomeDto? applyHomeDto;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if(applyHomeDto?.aptBasicInfo == null){
          return InfoBoxWidget(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Column(
                children: [
                  Gap(17.w),
                  SubTitleWidget(
                    text: "공급 세대수",
                    leftPadding: 10.w,
                  ),
                  Gap(30.w),
                  Center(
                    child: Text(
                      "정보를 가져 올 수 없습니다.",
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: Palette.brightMode.darkText
                      ),
                    ),
                  ),
                  Gap(30.w),
                ],
              ),
            ),
          );
        }
        else{
          int? generalScale = 0;
          int? specialScale = 0;

          if(applyHomeDto!.detailsList == null){
            generalScale = null;
            specialScale = null;
          }
          else{
            applyHomeDto!.detailsList!.forEach((details){
              if(details == null){
                generalScale = null;
                specialScale = null;
              }
              else{
                generalScale =  (generalScale == null || details.generalSupplyHouseholds == null) ?
                                null : generalScale! + details.generalSupplyHouseholds!;

                specialScale =  (specialScale == null || details.specialSupplyHouseholds == null) ?
                                null : specialScale! + details.specialSupplyHouseholds!;
              }

            });
          }

          return InfoBoxWidget(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Column(
                  children: [
                    Gap(17.w),
                    SubTitleWidget(
                      text: "공급 세대수",
                      leftPadding: 10.w,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(17.w),
                          Text(
                            "아파트 지하 2층, 지상 29층 8개동",
                            style: TextStyle(
                                fontSize: 11.sp,
                                color: Palette.brightMode.darkText
                            ),
                          ),
                          Gap(12.w),
                          Builder(
                            builder: (context) {
                              if(applyHomeDto!.aptBasicInfo!.totalSupplyHouseholdCount == null){
                                return Row(
                                  children: [
                                    Text(
                                      "전체 세대 정보 취합중입니다.",
                                      style: TextStyle(
                                          fontSize: 11.sp,
                                          color: Palette.brightMode.darkText
                                      ),
                                    ),
                                  ],
                                );
                              }
                              else{
                                return Row(
                                  children: [
                                    Text(
                                      "아파트 총 760 대 중",
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: Palette.brightMode.darkText
                                      ),
                                    ),
                                    Gap(5.w),
                                    Text(
                                      "총 ${applyHomeDto?.aptBasicInfo?.totalSupplyHouseholdCount}세대 분양",
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                );
                              }
                            }
                          ),
                          Gap(12.w),
                          Text(
                            "특별공급 ${specialScale == null ? "취합중" : "$specialScale세대"} / 일반공급 ${generalScale == null ? "취합중" : "$generalScale세대"}",
                            style: TextStyle(
                                fontSize: 11.sp,
                                color: Palette.brightMode.darkText
                            ),
                          ),
                          Gap(17.w),
                        ],
                      ),
                    ),
                    SupplyTableWidget(applyHomeDto : applyHomeDto),
                    Gap(17.w),
                  ],
                ),
              )
          );
        }
      }
    );
  }
}

class SupplyTableWidget extends StatelessWidget {
  const SupplyTableWidget({super.key, this.applyHomeDto});
  final ApplyHomeDto? applyHomeDto;

  int? calculatedScale(int? scale, int? newScale){
    if(scale == null || newScale == null){
      return null;
    }
    else{
      return scale + newScale;
    }
  }

  @override
  Widget build(BuildContext context) {

    String generalText = "";
    String childrenText = "";
    String newlywedText = "";
    String firstText = "";
    String elderText = "";
    String newBornText = "";
    String recommendText = "";
    String relocatedText = "";

    String fetchText = "취합중";

    if(applyHomeDto?.detailsList != null){
      int? general = 0,children = 0, newlywed = 0,first = 0, elder = 0, newborn = 0, recommend = 0, relocated = 0;

      //#. 합산
      for (var details in applyHomeDto!.detailsList!) {
        general = details == null ? null : calculatedScale(general,  details.generalSupplyHouseholds);
        children = details == null ? null : calculatedScale(children,  details.multiChildHouseholds);
        newlywed = details == null ? null : calculatedScale(newlywed,  details.newlywedHouseholds);
        first = details == null ? null : calculatedScale(first,  details.firstTimeHouseholds);
        elder = details == null ? null : calculatedScale(elder,  details.elderlyParentSupportHouseholds);
        newborn = details == null ? null : calculatedScale(newborn,  details.newbornHouseholds);
        recommend = details == null ? null : calculatedScale(recommend,  details.institutionRecommendedHouseholds);
        relocated = details == null ? null : calculatedScale(relocated,  details.relocatedInstitutionHouseholds);
      }

      //#. 검토
      if(applyHomeDto?.aptBasicInfo?.totalSupplyHouseholdCount != null) {
          int total = 0;
          total += general ?? 0;
          total += children ?? 0;
          total += newlywed ?? 0;
          total += first ?? 0;
          total += elder ?? 0;
          total += newborn ?? 0;
          total += recommend ?? 0;
          total += relocated ?? 0;
          
          //합이 맞으면 취합중이 아닌 0으로 변경
          if(total == applyHomeDto!.aptBasicInfo!.totalSupplyHouseholdCount){
            fetchText = "0";
          }
      }

      generalText = general == null ? fetchText : general.toString();
      childrenText = children == null ? fetchText : children.toString();
      newlywedText = newlywed == null ? fetchText : newlywed.toString();
      firstText = first == null ? fetchText : first.toString();

      elderText = elder == null ? fetchText : elder.toString();
      newBornText = newborn == null ? fetchText : newborn.toString();
      recommendText = recommend == null ? fetchText : recommend.toString();
      relocatedText = relocated == null ? fetchText : relocated.toString();
    }

    return Column(
      children: [
        Row(
          children: [
            TitleBox(text: "일반", scale: generalText),
            TitleBox(text: "다자녀", scale: childrenText,),
            TitleBox(text: "신혼", scale: newlywedText,),
            TitleBox(text: "생애최초", scale: firstText,),
          ],
        ),
        Gap(5.w),
        Row(
          children: [
            TitleBox(text: "노부모", scale: elderText,),
            TitleBox(text: "신생아", scale: newBornText,),
            TitleBox(text: "기관추천", scale: recommendText,),
            TitleBox(text: "신생아", scale: relocatedText,),
          ],
        ),
      ],
    );
  }
}

class TitleBox extends StatelessWidget {
  const TitleBox({super.key, required this.text, required this.scale});
  final String text;
  final String scale;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 1.w),
            padding: EdgeInsets.symmetric(horizontal: 1.w,vertical: 1.w),
            color: const Color(0xff014FAB),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 1.w),
            padding: EdgeInsets.symmetric(horizontal: 1.w,vertical: 1.w),
            color: const Color(0xffF7F7F7),
            child: Center(
              child: Text(
                scale,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: Palette.brightMode.darkText
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


