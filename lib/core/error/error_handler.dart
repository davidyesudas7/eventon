import 'dart:io';
import 'package:dio/dio.dart';
import 'failures.dart';

/// Extracts a clean, user-friendly error message from any error or exception.
/// Prioritizes the API response's `message` field when available.
/// If no message is provided by the API, returns an easily understandable fallback.
String extractErrorMessage(dynamic error, {String? defaultMessage}) {
  if (error == null) {
    return defaultMessage ?? 'An unexpected error occurred. Please try again.';
  }

  if (error is Failure) {
    return error.message;
  }

  if (error is DioException) {
    // 1. Connection / Timeout issues
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return 'Unable to connect to the server. Please check your internet connection.';
      case DioExceptionType.cancel:
        return 'The request was cancelled.';
      case DioExceptionType.badCertificate:
        return 'Security verification failed. Please try again later.';
      case DioExceptionType.badResponse:
      case DioExceptionType.unknown:
      default:
        break;
    }

    // 2. Extract from API response payload if available
    final response = error.response;
    if (response != null) {
      final data = response.data;
      if (data is Map) {
        // Backend typically returns:
        // { "statusCode": 400, "message": "...", "error": "..." }
        // or { "message": ["...", "..."] }
        final msgVal = data['message'];
        if (msgVal is String && msgVal.trim().isNotEmpty) {
          return _cleanMessage(msgVal);
        } else if (msgVal is List && msgVal.isNotEmpty) {
          final joined = msgVal
              .map((item) => item?.toString().trim())
              .where((item) => item != null && item.isNotEmpty)
              .join('\n');
          if (joined.isNotEmpty) {
            return _cleanMessage(joined);
          }
        }

        // Secondary fields: 'error' or 'detail' or 'details'
        final errVal = data['error'];
        if (errVal is String && errVal.trim().isNotEmpty) {
          return _cleanMessage(errVal);
        }
        final detailVal = data['detail'] ?? data['details'];
        if (detailVal is String && detailVal.trim().isNotEmpty) {
          return _cleanMessage(detailVal);
        }
      } else if (data is String && data.trim().isNotEmpty) {
        final trimmed = data.trim();
        // Check that response is not an HTML page from proxy / gateway
        if (!trimmed.toLowerCase().contains('<html') &&
            !trimmed.toLowerCase().contains('<!doctype') &&
            trimmed.length < 250) {
          return _cleanMessage(trimmed);
        }
      }

      // 3. Fallback based on HTTP Status Code
      final statusCode = response.statusCode;
      if (statusCode != null) {
        switch (statusCode) {
          case 400:
            return defaultMessage ??
                'Invalid request. Please check the entered information.';
          case 401:
            return 'Your session has expired. Please sign in again.';
          case 403:
            return 'You do not have permission to perform this action.';
          case 404:
            return defaultMessage ?? 'The requested item could not be found.';
          case 409:
            return defaultMessage ??
                'A conflict occurred with this request. Please try again.';
          case 422:
            return defaultMessage ??
                'Validation failed. Please verify your details.';
          case 429:
            return 'Too many requests. Please wait a moment and try again.';
          case 500:
          case 502:
          case 503:
          case 504:
            return 'Server is temporarily unavailable. Please try again later.';
        }
      }
    }

    // 4. Fallback if no response or unknown DioException
    if (error.error is SocketException ||
        (error.message != null &&
            error.message!.toLowerCase().contains('socketexception'))) {
      return 'Unable to reach the server. Please check your internet connection.';
    }

    return defaultMessage ??
        'An unexpected network error occurred. Please try again.';
  }

  // Generic Exception / Error / String
  final rawString = error.toString();
  return _cleanMessage(rawString, defaultFallback: defaultMessage);
}

/// Helper to sanitize error message strings
String _cleanMessage(String msg, {String? defaultFallback}) {
  var clean = msg.trim();
  // Strip leading Exception labels
  if (clean.startsWith('Exception: ')) {
    clean = clean.substring('Exception: '.length).trim();
  }
  if (clean.startsWith('StateError: ')) {
    clean = clean.substring('StateError: '.length).trim();
  }
  if (clean.startsWith('FormatException: ')) {
    clean = clean.substring('FormatException: '.length).trim();
  }
  // Strip DioException prefixes if any leaked
  final dioMatch = RegExp(r'^DioException\s*\[.*?\]:\s*');
  clean = clean.replaceFirst(dioMatch, '').trim();

  // If message contains raw socket or http stack info, don't show it raw
  if (clean.toLowerCase().contains('socketexception') ||
      clean.toLowerCase().contains('failed host lookup') ||
      clean.toLowerCase().contains('connection refused') ||
      clean.toLowerCase().contains('os error:')) {
    return 'Unable to reach the server. Please check your internet connection.';
  }

  if (clean.isEmpty) {
    return defaultFallback ?? 'An unexpected error occurred. Please try again.';
  }

  // Capitalize first letter if it starts with lower-case
  if (clean.isNotEmpty && clean[0].toLowerCase() != clean[0].toUpperCase()) {
    clean = clean[0].toUpperCase() + clean.substring(1);
  }

  return clean;
}

/// Converts any caught error into a strongly-typed [Failure] with a user-friendly message.
Failure handleApiError(
  dynamic error, {
  String? defaultMessage,
  String? idToken,
}) {
  if (error is Failure) {
    return error;
  }

  final message = extractErrorMessage(error, defaultMessage: defaultMessage);

  if (error is DioException) {
    final statusCode = error.response?.statusCode;
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return NetworkFailure(message);
    }
    if (statusCode == 422 || message.toLowerCase().contains('profile_required')) {
      return ProfileRequiredFailure(message, idToken);
    }
    if (statusCode == 409 && message.toLowerCase().contains('use_password')) {
      return const UsePasswordFailure();
    }
    if (statusCode == 401) {
      return UnauthorizedFailure(message);
    }
    return ServerFailure(message);
  }

  if (error is SocketException) {
    return NetworkFailure(message);
  }

  return ServerFailure(message);
}
