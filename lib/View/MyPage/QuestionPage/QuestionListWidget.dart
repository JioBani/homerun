import 'package:flutter/material.dart';

import 'QustionElementWidget.dart';

class QuestionListWidget extends StatelessWidget {
  const QuestionListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QuestionElementWidget(),
        QuestionElementWidget(),
        QuestionElementWidget(),
        QuestionElementWidget(),
        QuestionElementWidget(),
        QuestionElementWidget(),
        QuestionElementWidget(),
        QuestionElementWidget(),
        QuestionElementWidget(),
        QuestionElementWidget(),
        QuestionElementWidget(),
        QuestionElementWidget(),
      ],
    );
  }
}
