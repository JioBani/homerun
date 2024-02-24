import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'LoadingState.dart';

class LoadingButton extends StatefulWidget {
  const LoadingButton({super.key, required this.onLoad});
  final Future<LoadingState> Function() onLoad;

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton>  with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  bool isLoading = false;
  LoadingState state = LoadingState.idle;

  Future<void> onLoad() async {
    setState(() {
      state = LoadingState.loading;
    });

    state = await widget.onLoad();

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    switch(state){
      case LoadingState.loading :
        return const CupertinoActivityIndicator();
      case LoadingState.complete :
        return TextButton(
            onPressed: onLoad, child: const Text("더 불러오기")
        );
      case LoadingState.idle :
        return TextButton(
            onPressed: onLoad, child: const Text("더 불러오기")
        );
      case LoadingState.noMoreData :
        return const Text("더이상 불러올 데이터가 없습니다.");
      case LoadingState.fail :
        return const Text("데이터를 불러 올 수 없습니다.");
      default :
        return const Text("오류");
    }
  }
}
