import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Page/NoticePage/View/ScrapIconButton.dart';
import 'package:homerun/Style/Fonts.dart';
import 'package:homerun/Style/Palette.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key, required this.stream, required this.noticeId});
  final Stream<bool> stream;
  final String noticeId;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    widget.stream.listen((isVisible) {
      setState(() {
        _isVisible = isVisible;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: _isVisible ? 46.w : 0.0,
      curve: Curves.easeInOut,
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        child: Material(
          elevation: 10,
          child: Container(
            padding: EdgeInsets.only(left: 16.w , right: 26.w),
            width: double.infinity,
            color: Theme.of(context).colorScheme.surface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //#. 스크랩
                ScrapIconButton(noticeId: widget.noticeId,width: 22.w,height: 22.w,iconSize: 22.w,),
                //#. 공유
                Icon(Icons.share ,size: 22.sp,),

                //#. 관심등록
                Container(
                  width: 120.w,
                  height: 35.w,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(7.r)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.sell_outlined,
                        color: Colors.white,
                      ),
                      SizedBox(width: 2.w,),
                      Text(
                        "관심등록",
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: Fonts.BCCard,
                            color: Colors.white
                        ),
                      )
                    ],
                  ),
                ),

                //#. 전화문의
                Container(
                  width: 120.w,
                  height: 35.w,
                  decoration: BoxDecoration(
                      color: const Color(0xffF6F5F5),
                      borderRadius: BorderRadius.circular(7.r),
                      border: Border.all(
                          color: const Color(0xffA4A4A6),
                          width: 0.3.w
                      )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        color: Palette.brightMode.mediumText,
                      ),
                      SizedBox(width: 2.w,),
                      Text(
                        "전화문의",
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: Fonts.BCCard,
                            color: Palette.brightMode.mediumText
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}