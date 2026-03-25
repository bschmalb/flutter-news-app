class Api {
  const Api({
    required this.getAccessToken,
    required this.baseUrl,
  });

  final Future<String?> Function() getAccessToken;
  final String baseUrl;

  @override
  String toString() => 'Api(getAccessToken: $getAccessToken, baseUrl: $baseUrl)';
}
