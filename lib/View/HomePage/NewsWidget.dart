import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Common/FirebaseStorageImage.dart';
import 'package:homerun/Model/NewsData.dart';
import 'package:homerun/Service/FirebaseFirestoreService.dart';
import 'package:homerun/Style/Palette.dart';

class NewsWidget extends StatelessWidget {
  const NewsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text("#청약뉴스",
            style: TextStyle(
                fontSize: 20.sp,
                //TODO w600 -> w700
                fontWeight: FontWeight.w600,
                color: Palette.defaultBlue
            ),
          ),
        ),
        FutureBuilder(
          future: FirebaseFirestoreService.instance.getNewsList(),
          builder: (context , snapshot){
            if(snapshot.hasData){
              return NewImageWidget(newsData: snapshot.data![0]);
            }else if(snapshot.hasError){
              return Text("데이터를 불러 올 수 없습니다.");
            }else{
              return CupertinoActivityIndicator();
            }
          }
        )
      ],
    );
  }
}

class NewImageWidget extends StatelessWidget {
  const NewImageWidget({super.key, required this.newsData});
  final NewsData newsData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FireStorageImage(path: newsData.getProfileImagePath()),
        Transform.translate(
          offset: Offset(0, -30), // 이미지 위로 30픽셀 겹치도록 올립니다.
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(24.r) , topRight: Radius.circular(24.r))
            ),
            padding: EdgeInsets.fromLTRB(15.w, 20.h, 15.w, 30.h),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.share,
                      size: 24.sp,
                    ),
                    SizedBox(width: 5.w,),
                    Icon(
                      Icons.bookmark_added_outlined,
                      size: 24.sp,
                    )
                  ],
                ),
                SizedBox(height: 10.w,),
                Text(
                  newsData.profileTitle,
                  style: TextStyle(
                    fontSize: 21.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromRGBO(46, 60, 107, 1)
                  ),
                ),
                SizedBox(height: 10.w,),
                Text(
                  newsData.profileSubTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                    color: const Color.fromRGBO(164, 164, 166, 1)
                  ),
                ),
              ],
            ),
          ),
        ),
        // 다른 컨텐츠들을 여기에 추가할 수 있습니다.
      ],
    );
  }
}

