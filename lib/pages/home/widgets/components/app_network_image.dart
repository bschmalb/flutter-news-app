import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ksta/config/app_config.dart';
import 'package:ksta/utils/app_breakpoint.dart';

enum AppNetworkImageVariant {
  thumbnail,
  card,
  featured,
}

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    required this.imagePath,
    this.variant = AppNetworkImageVariant.card,
    this.fit,
    this.width,
    this.height,
    this.loadingBuilder,
    this.errorBuilder,
    super.key,
  });

  final String imagePath;
  final AppNetworkImageVariant variant;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final ImageLoadingBuilder? loadingBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;

  @override
  Widget build(BuildContext context) {
    final resolvedUrl = resolveImageUrl(
      imagePath,
      breakpoint: context.breakpoint,
      variant: variant,
    );

    return Image.network(
      resolvedUrl,
      fit: fit,
      width: width,
      height: height,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
    );
  }

  static String resolveImageUrl(
    String imagePath, {
    required AppBreakpoint breakpoint,
    required AppNetworkImageVariant variant,
  }) {
    final baseUri = Uri.parse(AppConfig.imageBaseUrl.value);
    final resolvedUri = _resolveImageUri(
      imagePath: imagePath,
      baseUri: baseUri,
    );

    if (!_isConfiguredImageUri(resolvedUri, baseUri)) return resolvedUri.toString();

    final unsignedQuery = _removeSignatureFromQuery(resolvedUri.query);
    final effectiveQuery = unsignedQuery.isEmpty
        ? _defaultQuery(breakpoint: breakpoint, variant: variant)
        : unsignedQuery;

    final signature = _buildSignature(
      path: _signingPath(imageUri: resolvedUri, baseUri: baseUri),
      query: effectiveQuery,
    );
    final signedQuery = effectiveQuery.isEmpty ? 's=$signature' : '$effectiveQuery&s=$signature';

    return resolvedUri.replace(query: signedQuery).toString();
  }

  static Uri _resolveImageUri({
    required String imagePath,
    required Uri baseUri,
  }) {
    final parsedUri = Uri.tryParse(imagePath);

    if (parsedUri != null && parsedUri.hasScheme) return parsedUri;

    return baseUri.resolve(imagePath.replaceFirst(RegExp('^/+'), ''));
  }

  static bool _isConfiguredImageUri(Uri imageUri, Uri baseUri) {
    return imageUri.scheme == baseUri.scheme &&
        imageUri.authority == baseUri.authority &&
        imageUri.path.startsWith(_normalizedBasePath(baseUri));
  }

  static String _buildSignature({required String path, required String query}) {
    final payload = query.isEmpty
        ? '${AppConfig.imgixSecret.value}$path'
        : '${AppConfig.imgixSecret.value}$path?$query';

    return md5.convert(utf8.encode(payload)).toString();
  }

  static String _defaultQuery({
    required AppBreakpoint breakpoint,
    required AppNetworkImageVariant variant,
  }) {
    final preset = _imagePreset(breakpoint: breakpoint, variant: variant);

    return _encodeQuery([
      MapEntry('w', '${preset.width}'),
      MapEntry('h', '${preset.height}'),
      MapEntry('fm', preset.format),
      MapEntry('q', '${preset.quality}'),
      MapEntry('fit', preset.fit),
    ]);
  }

  static _AppImagePreset _imagePreset({
    required AppBreakpoint breakpoint,
    required AppNetworkImageVariant variant,
  }) {
    return switch (variant) {
      AppNetworkImageVariant.thumbnail => switch (breakpoint) {
        AppBreakpoint.compact => const _AppImagePreset(width: 192, height: 144),
        AppBreakpoint.medium => const _AppImagePreset(width: 288, height: 216),
        AppBreakpoint.expanded => const _AppImagePreset(
          width: 384,
          height: 288,
        ),
      },
      AppNetworkImageVariant.card => switch (breakpoint) {
        AppBreakpoint.compact => const _AppImagePreset(width: 480, height: 360),
        AppBreakpoint.medium => const _AppImagePreset(width: 640, height: 480),
        AppBreakpoint.expanded => const _AppImagePreset(
          width: 800,
          height: 600,
        ),
      },
      AppNetworkImageVariant.featured => switch (breakpoint) {
        AppBreakpoint.compact => const _AppImagePreset(width: 640, height: 360),
        AppBreakpoint.medium => const _AppImagePreset(width: 960, height: 540),
        AppBreakpoint.expanded => const _AppImagePreset(
          width: 1280,
          height: 720,
        ),
      },
    };
  }

  static String _encodeQuery(List<MapEntry<String, String>> parameters) {
    return parameters
        .map(
          (parameter) => '${Uri.encodeQueryComponent(parameter.key)}=${Uri.encodeQueryComponent(parameter.value)}',
        )
        .join('&');
  }

  static String _signingPath({
    required Uri imageUri,
    required Uri baseUri,
  }) {
    final basePath = _normalizedBasePath(baseUri);
    final relativePath = imageUri.path.startsWith(basePath) ? imageUri.path.substring(basePath.length) : imageUri.path;

    if (relativePath.startsWith('/')) return relativePath;

    return '/$relativePath';
  }

  static String _normalizedBasePath(Uri uri) {
    final trimmedPath = uri.path.endsWith('/') ? uri.path.substring(0, uri.path.length - 1) : uri.path;

    if (trimmedPath.isEmpty || trimmedPath.startsWith('/')) return trimmedPath;

    return '/$trimmedPath';
  }

  static String _removeSignatureFromQuery(String query) {
    if (query.isEmpty) return '';

    return query.split('&').where((segment) => segment.isNotEmpty && !_isSignatureSegment(segment)).join('&');
  }

  static bool _isSignatureSegment(String segment) {
    final separatorIndex = segment.indexOf('=');
    final rawKey = separatorIndex == -1 ? segment : segment.substring(0, separatorIndex);

    return Uri.decodeQueryComponent(rawKey) == 's';
  }
}

class _AppImagePreset {
  const _AppImagePreset({
    required this.width,
    required this.height,
  });

  final int width;
  final int height;

  int get quality => 65;

  String get format => kIsWeb ? 'webp' : 'avif';

  String get fit => 'crop';
}
