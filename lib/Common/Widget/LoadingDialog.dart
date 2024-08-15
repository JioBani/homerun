
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      constrainedAxis: Axis.vertical,
      child: SizedBox(
        width: 50.w,
        height: 50.w,
        child: Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.r),
          ),
          child: SizedBox(
              width: 50.w,
              height: 50.w,
              child: const CupertinoActivityIndicator()
          ),
        ),
      ),
    );
  }

  /// [future]가 너무 빨리 종료될 경우 다이얼로그가 자동으로 pop되지 않는 문제가 있으므로 [CustomDialog] 사용 권장
  static Future<(T, bool)> showLoadingDialogWithFuture<T>(
      BuildContext context ,
      Future<T> future,
    ) async {
    late BuildContext dialogContext;

    showDialog(
      context: context,
      builder: (context) {
        dialogContext = context;
        return const LoadingDialog();
      },
    );

    T result = await future;

    if (dialogContext.mounted) {
      Navigator.pop(dialogContext);
      return (result, true);
    }
    else {
      return (result, false);
    }
  }
}