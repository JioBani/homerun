import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:homerun/Style/Palette.dart';

/// 소제목 위젯
class SubTitleWidget extends StatelessWidget {
  const SubTitleWidget({super.key, required this.text,required this.frontPadding,});
  final double frontPadding;
  final String text;

  @override
  Widget build(BuildContext context) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 11.sp,
          color: Colors.white
      )
    );

    final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout();

    return SizedBox(
      height: 20.w,
      width: 260.w,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          SubTitleDecoration(bottomWidth: textPainter.width + 25.w,),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(frontPadding),
              Text(
                text,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 11.sp,
                    color: Colors.white
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class SubTitleDecoration extends StatelessWidget {
  const SubTitleDecoration({super.key, required this.bottomWidth});
  final double bottomWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260.w,
      height: 20.w,
      child: CustomPaint(
        painter: SubTitleDecorationPainter(
          bottomWidth: bottomWidth,
        ),
      ),
    );
  }
}

class SubTitleDecorationPainter extends CustomPainter {
  final double bottomWidth;
  late final double topWidth;

  SubTitleDecorationPainter({required this.bottomWidth}){
    topWidth = bottomWidth - 10.w;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Palette.defaultDarkBlue
      ..style = PaintingStyle.fill;

    final path1 = Path();
    path1.moveTo(0, 0);
    path1.lineTo(topWidth, 0);
    path1.cubicTo(topWidth + 2.637, 0, topWidth + 5.05, 1.48177, topWidth + 6.243, 3.83337);
    path1.lineTo(bottomWidth, 20.w);
    path1.lineTo(0, 20.w);
    path1.close();
    canvas.drawPath(path1, paint);

    final paintLine = Paint()
      ..color = Palette.defaultDarkBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final path2 = Path();
    path2.moveTo(0, 20.w);
    path2.lineTo(260.w, 20.w);
    canvas.drawPath(path2, paintLine);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

