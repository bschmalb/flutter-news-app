class AppConfig {
  const AppConfig._();

  static const String baseUrl = String.fromEnvironment('base_url');

  static String requireBaseUrl({String? override}) {
    final value = override ?? baseUrl;

    if (value.isEmpty) {
      throw StateError(
        'Missing "base_url". Run the app with '
        '--dart-define-from-file=configs/config.dev.json.',
      );
    }

    return value;
  }
}
