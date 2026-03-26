const _baseUrlKey = 'base_url';
const _imageBaseUrlKey = 'image_base_url';
const _imgixSecretKey = 'imgix_secret';

enum AppConfig {
  baseUrl(_baseUrlKey, true, String.fromEnvironment(_baseUrlKey)),
  imageBaseUrl(_imageBaseUrlKey, true, String.fromEnvironment(_imageBaseUrlKey)),
  imgixSecret(_imgixSecretKey, true, String.fromEnvironment(_imgixSecretKey));

  const AppConfig(this.key, this.isRequired, this.value);

  final String key;
  final bool isRequired;
  final String value;

  static void validateRequired() {
    final missingKeys = values
        .where((field) => field.isRequired && field.value.isEmpty)
        .map((field) => field.key)
        .join(', ');

    if (missingKeys.isEmpty) return;

    throw StateError(
      'Missing required app config values: $missingKeys. Run the app with '
      '--dart-define-from-file=configs/config.dev.json.',
    );
  }
}
