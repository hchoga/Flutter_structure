import 'package:dio/dio.dart';

import '../errors/failures.dart';

class DioExceptionHandler {
  static Failure fromDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ServerFailure(
          message: 'Connection timeout. Please check your internet connection.',
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(exception.response);

      case DioExceptionType.connectionError:
        return ServerFailure(
          message: 'No internet connection. Please check your network.',
        );

      case DioExceptionType.badCertificate:
        return ServerFailure(message: 'Certificate validation failed.');

      case DioExceptionType.cancel:
        return ServerFailure(message: 'Request was cancelled.');

      case DioExceptionType.unknown:
        return ServerFailure(
          message: 'An unknown error occurred: ${exception.message}',
        );
    }
  }

  static Failure _handleBadResponse(Response? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;

    // Try to extract structured API error first
    if (data is Map<String, dynamic>) {
      final message = data['message'] as String?;
      final errorData = data['errorData'] as Map<String, dynamic>?;

      return ServerFailure(
        message: message ?? _fallbackMessage(statusCode),
        errorData: errorData,
        statusCode: statusCode,
      );
    }

    return ServerFailure(
      message: _fallbackMessage(statusCode),
      statusCode: statusCode,
    );
  }

  static String _fallbackMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Please log in again.';
      case 403:
        return 'Forbidden. You do not have permission.';
      case 404:
        return 'Resource not found.';
      case 500:
      case 502:
      case 503:
      case 504:
        return 'Server error. Please try again later.';
      default:
        return 'Unexpected error: $statusCode';
    }
  }
}
