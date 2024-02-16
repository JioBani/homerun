import 'package:get/get.dart';
import 'package:homerun/Common/StaticLogger.dart';
import 'package:homerun/Model/AssessmentProgress.dart';
import 'package:homerun/Service/AssessmentDataService.dart';
import 'package:homerun/Model/AssessmentQuestion.dart';
import 'package:homerun/Service/FirebaseFirestoreService.dart';

class AssessmentController extends GetxController{
    AssessmentDto? assessmentDto;
    late Map<Assessment , AssessmentAnswer?> answers;
    int _nextQuestion = 0;
    int get nextQuestion => _nextQuestion;

    final List<int> _pageMoveStack = [];


    Future<bool> fetchAssessmentData() async {
        answers = <Assessment, AssessmentAnswer?>{};
        assessmentDto = await FirebaseFirestoreService.instance.getAssessmentDto();
        if(assessmentDto != null){
            for (var q in assessmentDto!.assessmentList) {
                answers[q] = null;
            }
            update();
            return true;
        }
        else{
            update();
            return false;
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

        if(assessmentDto == null){
            StaticLogger.logger.e("[AssessmentController.loadAnswers()] 자격진단 데이터가 로드되지 않았습니다.");
            return null;
        }

        if(result == null){
            StaticLogger.logger.e("[AssessmentController.loadAnswers()] 진행상황을 불러 올 수 없습니다.");
        }
        else{
            answers = Map();

            if(result.answers.length != assessmentDto!.assessmentList.length){
                StaticLogger.logger.i("[AssessmentController.loadAnswers()] 진행상황을 불러 올 수 없습니다.");
                return null;
            }

            for(int i = 0; i< assessmentDto!.assessmentList.length; i++){
                if(result.answers[i] == null){
                    answers[assessmentDto!.assessmentList[i]] = null;
                }
                else{
                    if(assessmentDto!.assessmentList[i].answers.length <= result.answers[i]!){
                        StaticLogger.logger.i("[AssessmentController.loadAnswers()] 진행상황을 불러 올 수 없습니다.");
                        return null;
                    }
                    else{
                        answers[assessmentDto!.assessmentList[i]] = assessmentDto!.assessmentList[i].answers[result.answers[i]!];
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
        if(assessmentDto!.assessmentList.length <= index){
            return null;
        }
        else{
            return answers[assessmentDto!.assessmentList[index]]?.index;
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