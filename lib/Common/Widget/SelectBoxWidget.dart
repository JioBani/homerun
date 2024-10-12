import 'package:flutter/material.dart';


///선택 박스 위젯
class SelectBoxWidget<T> extends StatefulWidget {
  const SelectBoxWidget({
    super.key,
    required this.value,
    required this.builder,
    required this.controller,
    this.inkWellBorderRadius,
    this.onSelectCountOverFlow,
  });

  final T value;
  final SelectBoxController<T> controller;
  final Function(BuildContext context ,T value, bool selected) builder;
  final BorderRadius? inkWellBorderRadius;
  final Function(BuildContext context, T value, int selectCount)? onSelectCountOverFlow;

  @override
  State<SelectBoxWidget<T>> createState() => SelectBoxWidgetState<T>();
}

class SelectBoxWidgetState<T> extends State<SelectBoxWidget<T>> {
  bool isSelected = false;

  @override
  void initState() {
    widget.controller.addWidget(this);
    
    //#. 초기값 적용
    if(widget.controller.isCanSelectMulti){ //#. 다중선택 가능인 경우
      if(widget.controller.values.contains(widget.value)){
        changeSelect(true);
      }
    }
    else{ //#. 단일 선택인 경우
      if(widget.controller.value != null && widget.controller.value == widget.value){
        changeSelect(true);
      }
    }

    super.initState();
  }

  void changeSelect(bool select){
    isSelected = select;
    if(mounted){
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: widget.inkWellBorderRadius,
      onTap: (){
        if(widget.controller.isCanSelectMulti){
          if(!isSelected && widget.controller.maxSelectCount != null && widget.controller.values.length >= widget.controller.maxSelectCount!){
            if(widget.onSelectCountOverFlow != null){
              widget.onSelectCountOverFlow!(context,widget.value,widget.controller.values.length);
            }
          }
          else{
            isSelected = !isSelected;
            setState(() { });
            widget.controller.onTap(this, isSelected);
          }
        }
        else{
          isSelected = !isSelected;
          setState(() { });
          widget.controller.onTap(this, isSelected);
        }
      },
      child: widget.builder(context , widget.value, isSelected),
    );
  }
}

class SelectBoxController<T>{
  /// 선택한 값
  T? value;

  /// 복수선택 가능시 선택한 값들
  List<T> values = [];

  /// 버튼 위젯들
  List<SelectBoxWidgetState<T>> widgets = [];

  /// 복수 선택 가능한지
  final bool isCanSelectMulti;

  final int? maxSelectCount;

  SelectBoxController({this.isCanSelectMulti = false, this.maxSelectCount,T? initValue , List<T>? initValues}){
    value = initValue;
    if(initValues != null){
      values = initValues;
    }
  }

  /// 위젯 추가
  void addWidget(SelectBoxWidgetState<T> widget){
    widgets.add(widget);
  }

  /// 버튼 클릭시
  void onTap(SelectBoxWidgetState<T> widget, bool select){
    if(select){
      if(isCanSelectMulti){
        values.add(widget.widget.value);
      }
      else{
        value = widget.widget.value;
        for (var element in widgets) {
          if(element.widget.value != value){
            element.changeSelect(false);
          }
        }
      }
    }
    else{
      if(isCanSelectMulti){
        values.remove(widget.widget.value);
      }
      else{
        value = null;
      }
    }
  }

  void setValue(T value, bool select){
    if(isCanSelectMulti){

      /// 선택 하는 경우 : select = ture, contains = false
      /// 선택하지 않는 경우 : select = false , contains = ture
      /// 두 경우에만 수행
      if(select != values.contains(value)){
        //#. 값을 추가 또는 제거
        select ? values.add(value) : values.remove(value);

        //#. widget의 changeSelect를 호출
        for (var widget in widgets) {
          if(widget.widget.value == value){
            widget.changeSelect(select);
          }
        }
      }
    }
    else{
      if(select){
        //#. 선택이 true이고, value가 현재 this.value와 다른 경우에만 실행
        if(this.value != value){
          this.value = value;

          for (var widget in widgets) {
            if(widget.widget.value == value){
              widget.changeSelect(select);
            }
          }
        }
      }
      else{
        //#. 선택이 false 이고, value가 현재 this.value와 같은 경우에만 실행
        if(this.value == value){
          this.value = null;

          for (var widget in widgets) {
            if(widget.widget.value == value){
              widget.changeSelect(select);
            }
          }
        }
      }
    }
  }

  void reset(){
    for (var widget in widgets) {
      widget.changeSelect(false);
    }

    if(isCanSelectMulti){
      values = [];
    }
    else{
      value = null;
    }
  }
}