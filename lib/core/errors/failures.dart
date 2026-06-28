/// Failure classes for handling errors throughout the application layers.
/// These are used with dartz Either to represent failure states.
/// Following SOLID principles (Open/Closed Principle)

abstract class Failure {
  final String message;

  Failure({required this.message});
}

class ServerFailure extends Failure {
  final Map<String, dynamic>? errorData;
  final int? statusCode;

  ServerFailure({required super.message, this.errorData, this.statusCode});

  /// Returns ALL validation error messages from errorData joined by newline,
  /// falls back to the top-level message when errorData is absent or empty.
  String get displayMessage {
    if (errorData != null && errorData!.isNotEmpty) {
      final messages = <String>[];
      for (final errors in errorData!.values) {
        if (errors is List) {
          for (final e in errors) {
            if (e != null) messages.add(e.toString());
          }
        } else if (errors != null) {
          messages.add(errors.toString());
        }
      }
      if (messages.isNotEmpty) return messages.join('\n');
    }
    return message;
  }
}

class CacheFailure extends Failure {
  CacheFailure({required super.message});
}

class NetworkFailure extends Failure {
  NetworkFailure({required super.message});
}

class ValidationFailure extends Failure {
  ValidationFailure({required super.message});
}

class UnknownFailure extends Failure {
  UnknownFailure({String message = 'An unknown error occurred'})
      : super(message: message);
}
