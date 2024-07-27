import 'package:flutter/material.dart';
import 'package:homerun/Common/LoadingState.dart';
import 'package:homerun/Common/model/Result.dart';

class LoadableIcon<T> extends StatefulWidget {
  const LoadableIcon({
    super.key,
    required this.iconBuilder,
    required this.load,
    required this.width,
    required this.height,
    this.isMaintainValueOnFail = true, /// false 하면 실패시 null로 값을 바꿈
    this.onTap,
  });

  final Widget Function(T? value ,LoadingState loadingState) iconBuilder;
  final Future<Result<T>>? Function(T? currentValue)? onTap;
  final Future<Result<T>> Function(T? currentValue) load;
  final bool isMaintainValueOnFail;
  final double width;
  final double height;

  @override
  State<LoadableIcon> createState() => LoadableIconState<T>();
}

class LoadableIconState<T> extends State<LoadableIcon<T>> {
  LoadingState loadingState = LoadingState.loading;
  T? value;

  @override
  void initState() {
    load();
    super.initState();
  }

  void setValue(T newValue){
    value = newValue;
  }

  void setLoadingState(LoadingState newState){
    loadingState = newState;
  }

  refresh() => setState(() {});

  Future<void> load() async{
    loadingState = LoadingState.loading;
    setState(() {});
    Result<T> result = await widget.load(value);
    if(result.isSuccess){
      loadingState = LoadingState.success;
      value = result.content;
    }
    else{
      loadingState = LoadingState.fail;
      if(!widget.isMaintainValueOnFail){
        value = null;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if(widget.onTap != null){
          loadingState = LoadingState.loading;
          setState(() {});

          Result<T>? result = await widget.onTap!(value);

          if(result == null){
            return;
          }

          if(result.isSuccess){
            loadingState = LoadingState.success;
            value = result.content;
          }
          else{
            loadingState = LoadingState.fail;
            if(widget.isMaintainValueOnFail){
              value = null;
            }
          }
          setState(() {});
        }
      },
      child: Column(
        children: [
          SizedBox(
            width: widget.width,
            height: widget.height,
            child: widget.iconBuilder(value , loadingState)
          ),
        ],
      ),
    );
  }
}

// class LoadableIconController<T>{
//   final LoadableIconState<T> widget;
//
//   LoadableIconController({required this.widget});
//
//   void update(){
//     widget.refresh();
//   }
//
//   void setValue(T newValue){
//     widget.setValue(newValue);
//   }
//
//   void setLoadingState(LoadingState newState){
//     widget.setLoadingState(newState);
//   }
//
//   get value => widget.value;
// }
