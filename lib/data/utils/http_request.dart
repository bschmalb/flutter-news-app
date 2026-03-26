import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:ksta/data/utils/api.dart';
import 'package:ksta/data/utils/api_exception.dart';

extension CheckData on http.Response {
  bool get isStatusCodeGood => statusCode >= 200 && statusCode < 400;
}

abstract class HttpRequest {
  HttpRequest(this.api);

  final Api api;

  Future<String?> getAccessToken() async => api.getAccessToken();
  String get url => api.baseUrl;

  Future<http.Response> get(
    Uri uri, {
    Map<String, String>? headers,
  }) {
    return _request(
      uri,
      requestType: 'GET',
      request: () => http.get(
        uri,
        headers: headers,
      ),
    );
  }

  Future<http.Response> _request(
    Uri uri, {
    required String requestType,
    required Future<http.Response> Function() request,
  }) async {
    final stopwatch = Stopwatch()..start();

    _logRequest(uri, requestType);
    final response = await request();
    _logResponse(
      uri,
      requestType,
      response,
      stopwatch.elapsed,
    );

    if (!response.isStatusCodeGood) throw ApiException.fromResponse(response);

    return response;
  }

  void _logRequest(Uri uri, String requestType) {
    log('--> $requestType $uri');
  }

  void _logResponse(
    Uri uri,
    String requestType,
    http.Response response,
    Duration responseDuration,
  ) {
    final prefix = response.isStatusCodeGood ? '<--' : 'X--';

    log(
      '$prefix $requestType $uri - ${response.statusCode} '
      '- (${responseDuration.inMilliseconds} ms)',
    );
  }
}
