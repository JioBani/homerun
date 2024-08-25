import 'package:flutter/material.dart';
import 'package:homerun/Common/LoadingState.dart';

/// 명세
/// onSuccessBuilder
/// onErrorBuilder
/// onLoading

/// LoadableIcon은 비동기 로딩과 관련된 아이콘을 나타내는 위젯입니다.
/// 이 위젯은 로딩 상태에 따라 아이콘을 변경하거나 특정 작업을 수행할 수 있습니다.
///
/// [T]는 아이콘이 로드할 데이터 타입입니다.
class LoadableIcon<T> extends StatefulWidget {
  /// LoadableIcon 생성자.
  ///
  /// [load] 시작시 데이터를 가져오는 함수입니다.
  ///
  /// [isMaintainValueOnFail]이 false이면 로딩 실패 시 값이 null로 설정됩니다.
  const LoadableIcon({
    super.key,
    required this.iconBuilder,
    required this.load,
    this.onTap,
  });

  /// 아이콘을 구성하는 빌더 함수.
  final Widget Function(T? value, LoadingState loadingState) iconBuilder;

  /// 아이콘 클릭시 실행되는 함수
  ///
  /// 값을 리턴하면 아이콘의 새로은 데이터 값이 됩니다.
  final Future<(T?,LoadingState)> Function(T? currentValue, LoadingState loadingState)? onTap;

  /// 초기 로딩 작업을 수행하는 함수.
  ///
  /// 값을 리턴하면 아이콘의 새로은 데이터 값이 됩니다.
  final Future<(T?,LoadingState)> Function(T? currentValue) load;

  @override
  State<LoadableIcon> createState() => LoadableIconState<T>();
}

class LoadableIconState<T> extends State<LoadableIcon<T>> {
  /// 현재 로딩 상태.
  LoadingState loadingState = LoadingState.loading;

  /// 현재 값.
  T? value;

  @override
  void initState() {
    load();
    super.initState();
  }

  /// 비동기 로딩 작업을 수행합니다.
  Future<void> load() async{
    //#. 로딩으로 변경
    loadingState = LoadingState.loading;
    setState(() {});

    //#. 값 가져오고 새로운 값으로 변경
    var(T? newValue, LoadingState newState) = await widget.load(value);
    value = newValue;
    loadingState = newState;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if(widget.onTap != null){
          loadingState = LoadingState.loading;
          setState(() {});
          var(T? newValue, LoadingState newState) = await widget.onTap!(value , loadingState);
          value = newValue;
          loadingState = newState;
          setState(() {});
        }
      },
      child: widget.iconBuilder(value, loadingState),
    );
  }
}
