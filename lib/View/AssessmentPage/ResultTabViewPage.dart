import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homerun/Controller/AssessmentController.dart';

class ResultTabViewPage extends StatelessWidget {
  const ResultTabViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    AssessmentController assessmentController = Get.find<AssessmentController>();

    if(assessmentController.conditionList == null){
      return Text('오류가 발생했습니다.');
    }
    else{
      return Column(
        children: assessmentController.conditionList!.map((e) =>
            ResultWidget(
              id: e.questionId,
              result: e.isTrue(),
            )
        ).toList(),
      );
    }
  }
}

class ResultWidget extends StatelessWidget {
  const ResultWidget({
    super.key,
    required this.id,
    this.result
  });

  final String id;
  final bool? result;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(id),
        Builder(
            builder: (context){
              if(result == null){
                return const Icon(Icons.question_mark);
              }
              else if(result == true){
                return const Icon(Icons.done);
              }
              else{
                return const Icon(Icons.close);
              }
            }
        )
      ],
    );
  }
}

