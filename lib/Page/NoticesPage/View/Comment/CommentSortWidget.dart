import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:homerun/Common/Comment/Enums.dart';
import 'package:homerun/Page/NoticesPage/Controller/CommentViewWidgetController.dart';
import 'package:homerun/Style/Images.dart';
import 'package:homerun/Style/Palette.dart';

class CommentSortWidget extends StatefulWidget {
  const CommentSortWidget({super.key, required this.noticeId});
  final String noticeId;

  @override
  State<CommentSortWidget> createState() => _CommentSortWidgetState();
}

class _CommentSortWidgetState extends State<CommentSortWidget> {
  final List<String> items = [
    '최신순',
    '추천순',
  ];

  late String? selectedValue = items[0];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            Image.asset(NoticePageImages.comment.reply),
            SizedBox(width: 5.w,),
            GetBuilder<CommentViewWidgetController>(
              tag: widget.noticeId,
              builder: (controller) {
                return Text("${controller.showLoader.allCommentCount}개의 댓글");
              }
            ),
          ],
        ),
        Spacer(),
        SortDropDownButton(noticeId: widget.noticeId,),
      ],
    );
  }
}

class SortDropDownButton extends StatefulWidget {
  const SortDropDownButton({super.key, required this.noticeId});
  final String noticeId;

  @override
  State<SortDropDownButton> createState() => _SortDropDownButtonState();
}

class _SortDropDownButtonState extends State<SortDropDownButton> {
  final List<OrderType> items = [
    OrderType.likes,
    OrderType.date,
  ];

  late OrderType? selectedValue = items[0];

  late final CommentViewWidgetController controller;

  @override
  void initState() {
    controller = Get.find<CommentViewWidgetController>(
      tag: widget.noticeId
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownButtonHideUnderline(
          child: DropdownButton2<OrderType>(
            hint: Text(
              selectedValue?.koreanName ?? '',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            items: items
              .map((OrderType item) => DropdownMenuItem<OrderType>(
                value: item,
                child: Text(
                  item.koreanName,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Palette.brightMode.mediumText,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              )).toList(),
            value: selectedValue,
            onChanged: (value) {
              setState(() {
                selectedValue = value;
                controller.setOrderType(value);
              });
            },
            buttonStyleData: ButtonStyleData(
              height: 30.w,
              width: 80.w,
              padding: const EdgeInsets.only(left: 14, right: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            iconStyleData: IconStyleData(
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
              ),
              iconSize: 20.sp,
              iconEnabledColor: Palette.brightMode.mediumText,
              iconDisabledColor: Palette.brightMode.mediumText,
            ),
            dropdownStyleData: DropdownStyleData(
              width: 80.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
              ),
              offset: const Offset(-20, 0),
              scrollbarTheme: ScrollbarThemeData(
                radius: Radius.circular(20.r),
                thickness: MaterialStateProperty.all(6),
                thumbVisibility: MaterialStateProperty.all(true),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

