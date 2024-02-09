import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Model/AssessmentProgress.dart';
import 'package:homerun/Service/AssessmentDataService.dart';
import 'package:homerun/View/AssessmentPage/AssessmentQuestion.dart';

class AssessmentController extends GetxController{
    final List<Assessment> questions;
    late Map<Assessment , AssessmentAnswer?> answers;
    int _nextQuestion = 0;
    int get nextQuestion => _nextQuestion;

    final List<int> _pageMoveStack = [];

    AssessmentController({required this.questions}){
        answers = <Assessment, AssessmentAnswer?>{};
        for (var q in questions) {
            answers[q] = null;
        }
    }

    void setAnswer(Assessment assessment, AssessmentAnswer? answer){
        answers[assessment] = answer;
    }

    void setNextQuestion(int index){
        _nextQuestion = index;
    }

    String print(){
        String result = "";


        answers.forEach((key, value) {
            result += "${key.question} : ${value?.answer ?? "NULL" }\n";
        });

        return result;
    }

    AssessmentProgress getProgress(){
        List<int?> result = [];

        answers.forEach((key, value) {
            if(value == null){
                result.add(null);
            }
            else{
                result.add(value.index);
            }
        });

        return AssessmentProgress(
            answers: result,
            nextQuestion: _nextQuestion
        );
    }

    List<int?> getAnswersToIntList(){

        List<int?> result = [];

        answers.forEach((key, value) {
            if(value == null){
                result.add(null);
            }
            else{
                result.add(value.index);
            }
        });

        return result;
    }

    Future<int?> loadAnswers() async {
        AssessmentProgress? result = await AssessmentDataService.loadAnswer();

        if(result == null){
            StaticLogger.logger.i("[AssessmentController.loadAnswers()] 진행상황을 불러 올 수 없습니다.");
        }
        else{
            answers = Map();

            if(result.answers.length != questions.length){
                StaticLogger.logger.i("[AssessmentController.loadAnswers()] 진행상황을 불러 올 수 없습니다.");
                return null;
            }

            for(int i = 0; i< questions.length; i++){
                if(result.answers[i] == null){
                    answers[questions[i]] = null;
                }
                else{
                    if(questions[i].answers.length <= result.answers[i]!){
                        StaticLogger.logger.i("[AssessmentController.loadAnswers()] 진행상황을 불러 올 수 없습니다.");
                        return null;
                    }
                    else{
                        answers[questions[i]] = questions[i].answers[result.answers[i]!];
                    }
                }
            }

            _nextQuestion = result.nextQuestion;

            StaticLogger.logger.i("[AssessmentController.loadAnswers()] 진행상황을 불러왔습니다. : ${result.toJson()}");
            update();

            return result.nextQuestion;
        }
    }

    Future<void> saveAnswers() async{
        AssessmentDataService.saveAnswer(
            getProgress()
        );
    }

    int? findSelected(int index){
        if(questions.length <= index){
            return null;
        }
        else{
            return answers[questions[index]]?.index;
        }
    }

    void pushPageStack(int page){
        _pageMoveStack.add(page);
    }

    int? popPageStack(){
        try{
            int pop = _pageMoveStack.last;
            _pageMoveStack.removeLast();
            return pop;
        }catch(e){
            return null;
        }
    }
}