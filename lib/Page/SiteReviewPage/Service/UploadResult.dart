import 'package:homerun/Page/SiteReviewPage/Model/SiteReview.dart';

class UploadResultInfo{
  final UploadResult uploadState;
  final SiteReview? siteReview;
  final Object? exception;
  final StackTrace? stackTrace;
  final List<String>? failImages;

  UploadResultInfo({
    required this.uploadState,
    this.siteReview,
    this.exception,
    this.stackTrace,
    this.failImages
  });

  factory UploadResultInfo.fromSuccess(SiteReview siteReview){
    return UploadResultInfo(
      uploadState: UploadResult.success,
      siteReview : siteReview
    );
  }

  factory UploadResultInfo.fromFailure({
    required UploadResult state,
    required Object exception,
    required StackTrace stackTrace,
    List<String>? failImages
  }){
    return UploadResultInfo(
      uploadState: state,
      exception : exception,
      stackTrace : stackTrace,
      failImages : failImages,
    );
  }
}

enum UploadResult{
  authFailure,
  createDocFailure,
  writeDocFailure,
  imageUploadFailure,
  getUploadedDocFailure,
  success,
}