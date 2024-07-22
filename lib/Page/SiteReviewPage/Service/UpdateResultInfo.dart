import 'package:homerun/Page/SiteReviewPage/Model/SiteReview.dart';

class UpdateResultInfo{
  final UpdateResult updateResult;
  final SiteReview? siteReview;
  final Object? exception;
  final StackTrace? stackTrace;
  final List<String>? uploadFailImages;
  final List<String>? deleteFailImages;

  UpdateResultInfo({
    required this.updateResult,
    this.siteReview,
    this.exception,
    this.stackTrace,
    this.uploadFailImages,
    this.deleteFailImages,
  });

  factory UpdateResultInfo.fromSuccess(SiteReview siteReview){
    return UpdateResultInfo(
        updateResult: UpdateResult.success,
        siteReview : siteReview
    );
  }

  factory UpdateResultInfo.fromFailure({
    required UpdateResult state,
    required Object exception,
    required StackTrace stackTrace,
    List<String>? uploadFailImages,
    List<String>? deleteFailImages,
    List<String>? failImages
  }){
    return UpdateResultInfo(
      updateResult: state,
      exception : exception,
      stackTrace : stackTrace,
      uploadFailImages : uploadFailImages,
      deleteFailImages : deleteFailImages,
    );
  }
}

enum UpdateResult{
  authFailure,
  docUpdateFailure,
  imageUpdateFailure,
  getUploadedDocFailure,
  success,
}