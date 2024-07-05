import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentInputWidget extends StatefulWidget {
  const CommentInputWidget({super.key});

  @override
  State<CommentInputWidget> createState() => _CommentInputWidgetState();
}

class _CommentInputWidgetState extends State<CommentInputWidget> {
  final FocusNode _focusNode = FocusNode();

  int _maxLines = 1;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _maxLines = _focusNode.hasFocus ? 5 : 1;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: EdgeInsets.fromLTRB(10.w, 4.w, 10.w, 4.w),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(
              offset: Offset(0,0) ,
              blurRadius: 4.sp,
              color: Colors.black.withOpacity(0.25)
          )]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            cursorColor: const Color(0xFF35C5F0),
            maxLines: _maxLines,
            focusNode: _focusNode,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0x00FBFBFB),
              hintText: ' 댓글을 입력해주세요.',
              hintStyle: TextStyle(color: const Color(0xFFD9D9D9) , fontSize: 14.sp),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3.r),
                borderSide: BorderSide(color: const Color(0xFFD9D9D9),width: 1.sp),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3.r),
                borderSide: BorderSide(color: const Color(0xFFD9D9D9),width: 1.sp),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 6.w),
            ),
            style: TextStyle(
                fontSize: 11.sp
            ),
          ),
          Builder(
            builder: (context){
              if(_focusNode.hasFocus){
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: (){
                          _focusNode.unfocus();
                        },
                        child: Text("제출")
                    )
                  ],
                );
              }
              else{
                return SizedBox(height: 0,);
              }
            }
          )
        ],
      ),
    );
  }
}
