import 'package:homerun/Common/StaticLogger.dart';

class Condition{
  String questionId;
  final List<Condition>? subConditions;
  final List<int>? value;
  int? checkedValue;
  final int conditionType;

  static const int single = 0;
  static const int all = 1;
  static const int any = 2;

  Condition({
    required this.questionId,
    this.subConditions,
    required this.conditionType,
    this.value,
  });

  factory Condition.autoId({
    subConditions,
    required conditionType,
    value,
  }){
    Condition condition = Condition(questionId: '', conditionType: conditionType , value: value);
    condition.setId(condition.toExpression());

    return condition;
  }

  factory Condition.fromMap(Map<String, dynamic> map) {
    return Condition(
      questionId: map['questionId'],
      conditionType: map['conditionType'],
      value: map['value'] != null ? List<int>.from(map['value']) : null,
      subConditions: map['subConditions'] != null ? (map['subConditions'] as List).map((subMap) => Condition.fromMap(subMap)).toList() : null,
    );
  }

  // 이 컨디션이 ture인지 판단하는 함수
  bool? isTrue() {
    switch (conditionType) {
      case Condition.single:
      // 단일 조건 검사
        if(checkedValue == null){
          return null;
        }
        else{
          return value!.contains(checkedValue);
        }
      case Condition.all:
      // 모든 서브조건이 참이어야 함
        if (subConditions != null) {
          for (var condition in subConditions!) {
            bool? result = condition.isTrue();
            if (result == false) {
              return false;
            }
            else if(result == null){
              return null;
            }
          }
          return true;
        }
        throw Exception('subConditions 이 null임');
      case Condition.any:
      // 하나의 서브조건이라도 참이면 됨
        if (subConditions != null) {
          bool hasNull = false;
          for (var condition in subConditions!) {
            bool? result = condition.isTrue();
            if (result == true) {
              return true;
            }
            else if(result == null){
              hasNull = true;
            }
          }
          if(hasNull){
            return null;
          }
          else{
            return false;
          }
        }

        throw Exception('subConditions 이 null임');
      default:
        throw Exception('알수없는 conditionType');
    }
  }

  bool? isTureDebug(){
    bool? finalResult;

    switch (conditionType) {
      case Condition.single:
      // 단일 조건 검사
        if(checkedValue == null){
          StaticLogger.logger.i('${toExpressionWithCheckedValue()} : ${null}');
          return null;
        }
        else{
          return value!.contains(checkedValue);
        }
      case Condition.all:
      // 모든 서브조건이 참이어야 함
        if (subConditions != null) {
          for (var condition in subConditions!) {
            bool? result = condition.isTureDebug();
            if (result == false) {
              StaticLogger.logger.i('${toExpressionWithCheckedValue()} : ${false}');
              return false;
            }
            else if(result == null){
              return null;
            }
          }
          return true;
        }
        return false; // 서브조건이 없으면 false
      case Condition.any:
        bool hasNull = false;
        // 하나의 서브조건이라도 참이면 됨
        if (subConditions != null) {
          for (var condition in subConditions!) {
            bool? result = condition.isTureDebug();
            if (result == true) {
              StaticLogger.logger.i('${toExpressionWithCheckedValue()} : ${true}');
              return true;
            }
            else if(result == null){
              hasNull = true;
            }
          }
        }
        if(hasNull){
          StaticLogger.logger.i('${toExpressionWithCheckedValue()} : ${null}');
          return null;
        }
        else{
          StaticLogger.logger.i('${toExpressionWithCheckedValue()} : ${false}');
          return false;
        }
        return false;
      default:
        throw Exception('알수없는 conditionType');
    }

  }

  String toExpression() {
    if (subConditions == null || subConditions!.isEmpty) {
      return '$questionId = $value';
    } else {
      String expression = subConditions!.map((c) => c.toExpression()).join(conditionType == all ? ' && ' : ' || ');
      return '($expression)';
    }
  }

  String toExpressionWithCheckedValue() {
    if (subConditions == null || subConditions!.isEmpty) {
      // 서브 조건이 없는 경우, questionId와 함께 checkedValue를 표현
      return '$questionId[${checkedValue ?? '?'}]';
    } else {
      // 서브 조건이 있는 경우, 각 서브 조건의 toStringExpression 결과를 연결
      String expression = subConditions!.map((c) => c.toExpressionWithCheckedValue()).join(conditionType == Condition.all ? ' && ' : ' || ');
      return '($expression)';
    }
  }

  void setValue(int input){
    checkedValue = input;
  }

  bool? setValues(Map<String, int> input) {
    // 입력된 맵으로부터 checkedValue 설정
    if (input.containsKey(questionId)) {
      setValue(input[questionId]!);
    }

    // 서브 조건이 있는 경우, 재귀적으로 doTest 호출
    if (subConditions != null) {
      for (var subCondition in subConditions!) {
        subCondition.setValues(input); // 서브 조건에 대해서도 doTest 호출
      }
    }

    // 설정된 checkedValue를 바탕으로 조건 평가
    return isTrue();
  }

  void setId(String id){
    questionId = id;
  }

  Map<String, dynamic> toMap() {
    return {
      'questionId': questionId,
      'subConditions': subConditions?.map((condition) => condition.toMap()).toList(),
      'value': value,
      'checkedValue': checkedValue,
      'conditionType': conditionType,
    };
  }

  Map<String, dynamic> toFirestoreDocMap() {
    return {
      'questionId': questionId,
      'subConditions': subConditions?.map((condition) => condition.toMap()).toList(),
      'value': value,
      'conditionType': conditionType,
    };
  }
}