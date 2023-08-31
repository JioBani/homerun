import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class InquiryPage extends StatefulWidget {
  const InquiryPage({super.key});

  @override
  State<InquiryPage> createState() => _InquiryPageState();
}

class _InquiryPageState extends State<InquiryPage> {

  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8',
  ];
  String? selectedValue;
 // 선택한 항목을 저장할 변수 선언
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "문의하기",
          style: TextStyle(
              fontSize: 40.sp,
              fontWeight: FontWeight.w700
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Divider(),
            Padding(
              padding: EdgeInsets.fromLTRB(30.w, 20.h, 30.w, 0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "이메일 문의하기",
                      style: TextStyle(
                        fontSize: 45.sp,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Row(
                        children: [
                          Text(
                            'Select Item',
                            style: TextStyle(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      items: items
                          .map((String item) => DropdownMenuItem<String>(
                        value: item,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ))
                          .toList(),
                      value: selectedValue,
                      onChanged: (String? value) {
                        setState(() {
                          selectedValue = value;
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 50,
                        width: double.infinity,
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: Colors.blueAccent,
                            width: 1.5
                          ),
                        ),
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.arrow_forward_ios_outlined,
                        ),
                        iconSize: 14,
                        iconEnabledColor: Colors.black54,
                        iconDisabledColor: Colors.black54,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        elevation: 2,
                        width: MediaQuery.sizeOf(context).width - 60.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        scrollbarTheme: ScrollbarThemeData(
                          radius: Radius.circular(15.r),
                          thickness: MaterialStateProperty.all<double>(6),
                          thumbVisibility: MaterialStateProperty.all<bool>(true),
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                        padding: EdgeInsets.only(left: 14, right: 14),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h,),
                  TextField(
                    decoration: new InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.black45)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.black45)
                      ),
                      contentPadding: EdgeInsets.only(left: 20.w, bottom: 5, top: 5, right: 5),
                      hintText: '이름',
                      labelStyle:TextStyle(fontSize:35.sp),
                      hintStyle: TextStyle(fontSize:35.sp),
                    ),
                  ),
                  SizedBox(height: 20.h,),
                  TextField(
                    decoration: new InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.black45)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.black45)
                      ),
                      contentPadding: EdgeInsets.only(left: 20.w, bottom: 5, top: 5, right: 5),
                      hintText: '이메일',
                      labelStyle:TextStyle(fontSize:35.sp),
                      hintStyle: TextStyle(fontSize:35.sp),
                    ),
                  ),
                  SizedBox(height: 20.h,),
                  TextField(
                    decoration: new InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.black45)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.black45)
                      ),
                      contentPadding: EdgeInsets.only(left: 20.w, bottom: 5, top: 5, right: 5),
                      hintText: '제목',
                      labelStyle:TextStyle(fontSize:35.sp),
                      hintStyle: TextStyle(fontSize:35.sp),
                    ),
                  ),
                  SizedBox(height: 20.h,),
                  Container(
                    width: double.infinity, // 원하는 너비 지정
                    height: 500.h, // 원하는 높이 지정
                    child: TextField(
                      decoration: new InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: Colors.black45)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2, color: Colors.black45)
                        ),
                        contentPadding: EdgeInsets.only(left: 20.w, bottom: 5, top: 5, right: 5),
                        hintText: '문의 내용',
                        isDense: true, // important line
                        labelStyle:TextStyle(fontSize:35.sp),
                        hintStyle: TextStyle(fontSize:35.sp),
                      ),
                      maxLines: 10,
                      minLines: 10,
                    ),
                  ),
                  SizedBox(height: 20.h,),
                  SizedBox(
                    width: double.infinity,
                    height: 100.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r), // borderRadius를 10으로 지정
                        ),
                        backgroundColor: Colors.lightBlue, // 배경색을 하늘색으로 지정
                      ),
                      onPressed: () {
                        // 버튼을 눌렀을 때 수행할 작업을 여기에 추가하세요.
                      },
                      child: Text(
                        '제출하기',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 35.sp,
                          color: Colors.white
                        ),
                      ), // 버튼에 표시할 텍스트
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
