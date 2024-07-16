import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homerun/Style/Palette.dart';

class CommentInputWidget extends StatefulWidget {
  const CommentInputWidget({
    super.key,
    this.startString,
    this.startWithOpen = false,
    this.maintainButtons = false,
    this.hasCloseButton = false,
    this.onFocus,
    this.onTapSubmit,
    this.onTapClosed,
  });

  final String? startString;
  final bool startWithOpen;
  final bool maintainButtons;
  final bool hasCloseButton;
  final Function(BuildContext)? onFocus;
  final Function(
      BuildContext context,
      String content ,
      FocusNode focusNode ,
      TextEditingController textEditingController
      )? onTapSubmit;
  final Function(BuildContext)? onTapClosed;

  @override
  State<CommentInputWidget> createState() => _CommentInputWidgetState();
}

///들어가야하는 기능
/// - upload : Collection , content , replyTarget
///   - onUpload
/// - update : Comment , content
/// - delete : Comment
///  - update like state
/// - upload의 서비스는

class _CommentInputWidgetState extends State<CommentInputWidget> with TickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    _focusNode.addListener(_toggleOpen);
    if(widget.startString != null){
      textEditingController.text = widget.startString!;
    }
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_toggleOpen);
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleOpen() {
    setState(() {
      if(_focusNode.hasFocus){
        widget.onFocus?.call(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        TextFormField(
          controller: textEditingController,
          cursorColor: const Color(0xFF35C5F0),
          maxLines: _focusNode.hasFocus ? 6 : 1,
          focusNode: _focusNode,
          autofocus: widget.startWithOpen,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0x00FBFBFB),
            hintText: ' 댓글을 입력해주세요.',
            hintStyle: TextStyle(color: Palette.brightMode.lightText , fontSize: 14.sp),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.r),
              borderSide: BorderSide(color: Palette.brightMode.lightText,width: 1.sp),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3.r),
              borderSide: BorderSide(color: Palette.brightMode.lightText,width: 1.sp),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 6.w),
          ),
          style: TextStyle(
              fontSize: 14.sp,
              color: Palette.brightMode.mediumText
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Builder(builder: (context){
            if(_focusNode.hasFocus || widget.maintainButtons){
              if(widget.hasCloseButton){
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButtonWidget(
                      text: "취소",
                      width: 50.w,
                      height: 25.w,
                      onPressed: (){
                        if(widget.onTapClosed != null){
                          widget.onTapClosed!(context);
                        }
                      }
                    ),
                    SizedBox(width: 5.w,),
                    CustomButtonWidget(
                      text: "등록",
                      width: 50.w,
                      height: 25.w,
                      onPressed: (){
                        if(widget.onTapSubmit != null){
                          widget.onTapSubmit!(context, textEditingController.text, _focusNode , textEditingController);
                        }
                      }
                    )
                  ],
                );
              }
              else{
                return CustomButtonWidget(
                  text: "등록",
                  width: 50.w,
                  height: 25.w,
                  onPressed: (){
                    if(widget.onTapSubmit != null){
                      widget.onTapSubmit!(context, textEditingController.text, _focusNode , textEditingController);
                    }
                  },
                );
              }
            }
            else{
              return const SizedBox();
            }
          }),
        )
      ],
    );
  }
}

class CustomButtonWidget extends StatelessWidget {
  const CustomButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    required this.width,
    required this.height
  });

  final String text;
  final Function onPressed;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.w),
      child: SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: () {
            onPressed();
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape:  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.r),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 0 , vertical: 0)
          ),
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12.sp
            ),
          ),
        ),
      ),
    );
  }
}
