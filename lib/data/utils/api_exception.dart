import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  const ApiException({required this.statusCode, required this.message, this.error, this.body});

  factory ApiException.fromResponse(http.Response response) {
    final decodedBody = _tryDecodeJson(response.body);

    if (decodedBody is Map<String, dynamic>) {
      return ApiException(
        statusCode: (decodedBody['statusCode'] as num?)?.toInt() ?? response.statusCode,
        message: _stringifyMessage(decodedBody['message']) ?? response.reasonPhrase ?? 'Request failed',
        error: decodedBody['error'] as String?,
        body: response.body,
      );
    }

    return ApiException(
      statusCode: response.statusCode,
      message: response.reasonPhrase ?? 'Request failed',
      body: response.body,
    );
  }

  final int statusCode;
  final String message;
  final String? error;
  final String? body;

  @override
  String toString() {
    if (error == null || error!.isEmpty) return 'ApiException($statusCode): $message';
    return 'ApiException($statusCode, $error): $message';
  }

  static Object? _tryDecodeJson(String body) {
    if (body.isEmpty) return null;

    try {
      return jsonDecode(body);
    } catch (_) {
      return null;
    }
  }

  static String? _stringifyMessage(Object? message) {
    if (message == null) return null;
    if (message is String) return message;

    return jsonEncode(message);
  }
}
