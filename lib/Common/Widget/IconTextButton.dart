import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  const IconTextButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.textStyle
  });

  final Widget icon;
  final String text;
  final TextStyle? textStyle;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          Text(
            text,
            style: textStyle,
          )
        ],
      ),
    );
  }
}


