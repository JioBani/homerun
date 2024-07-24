import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:homerun/Common/LoadingState.dart';

class Loadable<T>{
  T? _value;
  T? get value => _value;
  LoadingState loadingState = LoadingState.before;
  GetxController controller;

  Map<String , Future Function(Loadable<T>)> loadingActions;

  Loadable({required this.controller , required this.loadingActions});

  Future<void> load(String name)async{
    loadingActions[name]?.call(this);
  }

  void update(LoadingState newState){
    loadingState = newState;
    controller.update();
  }

  void setValue(T? newValue){
    _value = newValue;
  }
}