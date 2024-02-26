import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/FirebaseStorageImage.dart';
import 'package:homerun/Style/Palette.dart';
import 'package:homerun/View/GuidePage/GuidePage.dart';

class TypeGuideTabWidget extends StatefulWidget {
  TypeGuideTabWidget({
    super.key,
    required this.imagePath,
    required this.name,
    required this.tabController,
    required this.index,
    this.size,
  });

  final String imagePath;
  final String name;
  final TabController tabController;
  final int index;
  double? size;

  @override
  State<TypeGuideTabWidget> createState() => _TypeGuideTabWidgetState();
}

class _TypeGuideTabWidgetState extends State<TypeGuideTabWidget> {
  final Color unSelectedColor = const Color.fromRGBO(126, 141, 192, 1);
  late double size;

  @override
  void initState() {
    size = widget.size ??= 60.w;
    widget.tabController.addListener(() {
      if(mounted){
        setState(() {

        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: (){
        widget.tabController.animateTo(widget.index , duration: const Duration(milliseconds: 500));
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Palette.defaultGrey,
              borderRadius: BorderRadius.circular(widget.size!),
            ),
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(widget.size! * 0.2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: FireStorageImage(
                      path: widget.imagePath,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.w),
            child: Text(
              widget.name,
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                  color: widget.index == widget.tabController.index ? Palette.defaultBlue : unSelectedColor
              ),
            ),
          ),
          SizedBox(height: 10.h,)
        ],
      ),
    );
  }
}
