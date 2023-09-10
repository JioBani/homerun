import 'PreSaleData.dart';

class PreSaleDataSet{
  List<PreSaleData> _dataList = [];
  get dataList => _dataList;

  int _viewCount = 0;
  static const int _initViewCount = 6;
  static const int _viewCountIncrement = 6;

  PreSaleDataSet(dataList){
    _dataList = dataList;
  }

  void resetViewCount(){
    if(dataList.length >= 2){
      _viewCount = _initViewCount;
    }
    else{
      _viewCount = dataList.length;
    }
  }

  bool addViewCount(){
    if(_viewCount >= dataList.length){
      return false;
    }
    else{
      _viewCount += _viewCountIncrement;
      if(_viewCount >= dataList.length){
        _viewCount = dataList.length;
        return false;
      }
      return true;
    }
  }

  int getRowCount(){
    return (_viewCount / 2).ceil();
  }

  void resetDataList(){
    dataList.clear();
  }
}