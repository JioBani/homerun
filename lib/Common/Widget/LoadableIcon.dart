import 'package:flutter/material.dart';
import 'package:homerun/Common/LoadingState.dart';

import '../model/Result.dart';

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
    required this.width,
    required this.height,
    this.isMaintainValueOnFail = true, /// false 하면 실패시 null로 값을 바꿈
    this.onTap,
  });

  /// 아이콘을 구성하는 빌더 함수.
  final Widget Function(T? value, LoadingState loadingState) iconBuilder;

  /// 아이콘 클릭시 실행되는 함수
  ///
  /// 값을 리턴하면 아이콘의 새로은 데이터 값이 됩니다.
  final Future<T?>? Function(T? currentValue, LoadableIconController controller)? onTap;

  /// 초기 로딩 작업을 수행하는 함수.
  ///
  /// 값을 리턴하면 아이콘의 새로은 데이터 값이 됩니다.
  final Future<T?> Function(T? currentValue, LoadableIconController controller) load;

  /// 로딩 실패 시 값을 유지할지 여부를 설정합니다.
  final bool isMaintainValueOnFail;

  /// 아이콘의 너비.
  final double width;

  /// 아이콘의 높이.
  final double height;

  @override
  State<LoadableIcon> createState() => LoadableIconState<T>();
}

class LoadableIconState<T> extends State<LoadableIcon<T>> {
  /// 현재 로딩 상태.
  LoadingState loadingState = LoadingState.loading;

  /// 현재 값.
  T? value;

  /// 아이콘의 상태를 관리하는 컨트롤러.
  late final LoadableIconController _loadableIconController;

  @override
  void initState() {
    _loadableIconController = LoadableIconController(this);
    load();
    super.initState();
  }

  /// 새로운 값을 설정합니다.
  void setValue(T? newValue){
    value = newValue;
  }

  /// 새로운 로딩 상태를 설정합니다.
  void setLoadingState(LoadingState newState){
    loadingState = newState;
  }

  /// 위젯을 새로고침합니다.
  refresh() => setState(() {});

  /// 비동기 로딩 작업을 수행합니다.
  Future<void> load() async{
    //#. 로딩으로 변경
    loadingState = LoadingState.loading;
    setState(() {});
    
    //#. 값 가져오고 새로운 값으로 변경
    T? newValue = await widget.load(value, _loadableIconController);
    value = newValue;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if(widget.onTap != null){
          loadingState = LoadingState.loading;
          setState(() {});

          T? newValue = await widget.onTap!(value, _loadableIconController);
          value = newValue;
          setState(() {});
        }
      },
      child: Column(
        children: [
          SizedBox(
            width: widget.width,
            height: widget.height,
            child: widget.iconBuilder(value, loadingState),
          ),
        ],
      ),
    );
  }
}

/// LoadableIcon의 상태를 제어하는 컨트롤러 클래스.
class LoadableIconController<T> {
  final LoadableIconState<T> loadableIconState;

  LoadableIconController(this.loadableIconState);

  /// 아이콘의 값을 설정합니다.
  void setValue(T? value) {
    loadableIconState.setValue(value);
  }

  /// 로딩 상태를 설정합니다.
  void setLoadingState(LoadingState newState) {
    loadableIconState.setLoadingState(newState);
  }

  /// 위젯을 새로고침합니다.
  void setState() {
    loadableIconState.refresh();
  }

  /// 로딩 상태를 성공으로 설정합니다.
  void success() {
    setLoadingState(LoadingState.success);
  }

  /// 로딩 상태를 실패로 설정합니다.
  void failure() {
    setLoadingState(LoadingState.fail);
  }

  /// Result 객체로부터 상태를 변경하고 값을 반환합니다.
  T? fromResult(Result<T> result) {
    if (result.isSuccess) {
      success();
      return result.content;
    } else {
      failure();
      if (!loadableIconState.widget.isMaintainValueOnFail) {
        return null;
      } else {
        return loadableIconState.value;
      }
    }
  }

  /// Result와 새로운 값으로부터 상태를 변경하고 값을 반환합니다.
  T? fromResultAndValue(Result<T> result, T? value) {
    if (result.isSuccess) {
      success();
      return value;
    } else {
      failure();
      if (!loadableIconState.widget.isMaintainValueOnFail) {
        return null;
      } else {
        return loadableIconState.value;
      }
    }
  }
}
