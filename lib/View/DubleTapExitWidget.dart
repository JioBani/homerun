import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DoubleTapExitWidget extends StatelessWidget {
  DoubleTapExitWidget({super.key, required this.child});

  final Widget child;
  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: child
    );
  }

  Future<bool> onWillPop(){

    DateTime now = DateTime.now();

    if(currentBackPressTime == null || now.difference(currentBackPressTime!)
        > Duration(seconds: 2))
    {

      currentBackPressTime = now;
      final msg = "'뒤로'버튼을 한 번 더 누르면 종료됩니다.";

      Fluttertoast.showToast(msg: msg);
      return Future.value(false);

    }

    return Future.value(true);

  }
}
