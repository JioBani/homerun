import 'HttpError.dart';

class ApiResponse {
  final int status;
  final dynamic data;
  final HttpError? error;

  ApiResponse({
    required this.status,
    this.data,
    this.error,
  });

  factory ApiResponse.fromMap(Map<String, dynamic> map) {
    return ApiResponse(
      status: map['status'],
      data: map['data'],
      error: map['error'] != null ? HttpError.fromMap(map['error']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'data': data,
      'error': error?.toMap(),
    };
  }
}
