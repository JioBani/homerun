import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Page/NoticesPage/Model/SiteReview.dart';
import 'package:homerun/Service/Auth/UserDto.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:homerun/Style/TestImages.dart';

class SiteReviewPage extends StatelessWidget {
  const SiteReviewPage({super.key, required this.siteReview, required this.userDto});
  final SiteReview siteReview;
  final UserDto userDto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              surfaceTintColor: Colors.white,
              expandedHeight: 80.w,
              leading: const Icon(Icons.arrow_back),
              backgroundColor: Theme.of(context).colorScheme.background,
              pinned: true,
              shadowColor: Colors.black.withOpacity(0.5),
              shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.0)),
              ),
              title: Text(
                siteReview.title,
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Icon(Icons.favorite_border),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Icon(Icons.folder_open),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Icon(Icons.share),
                ),
                SizedBox(width: 10.w,)
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Align(
                  alignment: Alignment.bottomLeft,
                  child: ProfileWidget(userDto: userDto,)
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: 20,
                  primary: false,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.redAccent,
                      margin: EdgeInsets.all(10.w),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key, required this.userDto});
  final UserDto userDto;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(left: 25.w),
        child: SizedBox(
          height: 40.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30.w),
                child: Image.asset(
                  TestImages.ashe_43,
                  width: 35.w,
                  height: 35.w,
                ),
              ),
              SizedBox(width: 7.w,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userDto.displayName ?? '알 수 없음',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: Palette.brightMode.darkText
                    ),
                  ),
                  Text(
                    "2024.07.04",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                      color: Palette.brightMode.mediumText
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

