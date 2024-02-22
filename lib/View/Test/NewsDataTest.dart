import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Model/NewsData.dart';
import 'package:homerun/Service/FirebaseFirestoreService.dart';

class NewsDataTest extends StatelessWidget {
  const NewsDataTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20), // 컨테이너 내부 여백
              height: 300.h,
              color: Colors.orange,
              child: Text(
                'Dynamic height content here. The content can be longer or shorter, '
                    'and the container will adjust its size accordingly.',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Transform.translate(
              offset: Offset(0, -30), // 이미지 위로 30픽셀 겹치도록 올립니다.
              child: Container(
                padding: EdgeInsets.all(20), // 컨테이너 내부 여백
                color: Colors.black.withOpacity(0.5),
                child: Column(
                  children: [
                    Text(
                      'Dynamic height content here. The content can be longer or shorter, '
                          'and the container will adjust its size accordingly.',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Dynamic height content here. The content can be longer or shorter, '
                          'and the container will adjust its size accordingly.',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Dynamic height content here. The content can be longer or shorter, '
                          'and the container will adjust its size accordingly.',
                      style: TextStyle(color: Colors.white),
                    ),

                  ],
                ),
              ),
            ),
            // 다른 컨텐츠들을 여기에 추가할 수 있습니다.
          ],
        ),
      ),
    );
  }
}
