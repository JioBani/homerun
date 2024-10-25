import 'package:homerun/Common/LoadingState.dart';

class Loader<T>{
  T? value;
  LoadingState loadingState = LoadingState.before;

  final Function(LoadingState state, T? value) onStateChanged;

  final Future<T?> Function(Loader<T> loader) onLoad;

  Loader({required this.onLoad, required this.onStateChanged});

  void setState(LoadingState newState){
    loadingState = newState;
    onStateChanged(newState , value);
  }

  Future<void> load() async {
    value = await onLoad(this);
  }
}