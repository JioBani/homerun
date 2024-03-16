import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnswerCheckBoxTile extends StatelessWidget {
  const AnswerCheckBoxTile({
    Key? key,
    required this.selected,
    required this.onTap,
    required this.title,
  }) : super(key: key);

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnswerCheckboxWidget(
          value: selected,
          onChange: (value){
            onTap();
          },
        ),
        SizedBox(width: 5.w,),
        Flexible(
          child: RichText(
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            text: TextSpan(
              text: title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13.sp,
                color: Colors.black
              ),
            ),
          ),
        )
      ],
    );
  }
}


class AnswerCheckboxWidget extends StatefulWidget {
  const AnswerCheckboxWidget({Key? key , required this.value , required this.onChange}) : super(key: key);
  final bool value;
  final void Function(bool) onChange;

  @override
  State<AnswerCheckboxWidget> createState() => _AnswerCheckboxWidgetState();
}

class _AnswerCheckboxWidgetState extends State<AnswerCheckboxWidget> with TickerProviderStateMixin{
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: (){
        widget.onChange(!widget.value);
      },
      child: SizedBox(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Center(
            child: Stack(
              alignment : AlignmentDirectional.center,
              children: [
                AnimatedOpacity(
                  opacity: widget.value ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 150),
                  child: Image.asset(
                      "assets/images/assessment/check.png",
                      width: 25.sp,
                      height: 25.sp,
                      fit: BoxFit.fill
                  ),
                ),
                AnimatedOpacity(
                  opacity: widget.value ? 0 : 1,
                  duration: const Duration(milliseconds: 150),
                  child:  Image.asset(
                      "assets/images/assessment/uncheck.png",
                      width: 20.sp,
                      height: 20.sp,
                      fit: BoxFit.fill
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}