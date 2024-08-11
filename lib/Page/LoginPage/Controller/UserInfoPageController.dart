import '../View/UserInfoInputPage/SelectBoxWidget.dart';

class UserInfoPageController{

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

  SelectBoxController({this.isCanSelectMulti = false});

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
}