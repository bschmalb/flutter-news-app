import 'dart:convert';

import 'package:ksta/data/news/models/homepage_block_model.dart';

const homepageEmbedMinimumHeight = 220.0;
const homepageEmbedDefaultHeight = 420.0;
const homepageEmbedMaximumHeight = 960.0;

double preferredHeightForEmbed(EmbedHomepageBlockModel block) {
  final candidates = <String?>[
    block.html,
    block.targetUrl,
  ];

  for (final candidate in candidates) {
    if (candidate == null) continue;

    final attributeMatch = RegExp(
      r'''height\s*=\s*["']?(\d{2,4})["']?''',
      caseSensitive: false,
    ).firstMatch(candidate);
    if (attributeMatch != null) {
      return double.parse(attributeMatch.group(1)!);
    }

    final styleMatch = RegExp(
      r'''height\s*:\s*(\d{2,4})px''',
      caseSensitive: false,
    ).firstMatch(candidate);
    if (styleMatch != null) {
      return double.parse(styleMatch.group(1)!);
    }
  }

  return homepageEmbedDefaultHeight;
}

String? buildEmbedDocument(EmbedHomepageBlockModel block) {
  final rawHtml = block.html?.trim();
  if (rawHtml != null && rawHtml.isNotEmpty) {
    return wrapEmbedHtml(rawHtml);
  }

  final targetUrl = block.targetUrl?.trim();
  if (targetUrl == null || targetUrl.isEmpty) return null;

  final escapedUrl = const HtmlEscape(HtmlEscapeMode.attribute).convert(targetUrl);
  return wrapEmbedHtml('<iframe src="$escapedUrl" loading="lazy"></iframe>');
}

String wrapEmbedHtml(String html) {
  return '''
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
      html, body {
        margin: 0;
        padding: 0;
        background: transparent;
        overflow-x: hidden;
      }

      iframe, img, video, embed, object {
        display: block;
        width: 100%;
        max-width: 100%;
        border: 0;
      }
    </style>
  </head>
  <body>
    $html
    <script>
      (function() {
        const notifyHeight = () => {
          const doc = document.documentElement;
          const body = document.body;
          const height = Math.max(
            doc ? doc.scrollHeight : 0,
            body ? body.scrollHeight : 0,
            doc ? doc.offsetHeight : 0,
            body ? body.offsetHeight : 0
          );

          if (window.Resize && typeof window.Resize.postMessage === 'function') {
            window.Resize.postMessage(String(height));
          }

          if (window.parent && window.parent !== window) {
            window.parent.postMessage(JSON.stringify({
              type: 'ksta-embed-height',
              height: height
            }), '*');
          }
        };

        window.addEventListener('load', notifyHeight);
        window.addEventListener('resize', notifyHeight);

        if (document.readyState === 'complete') {
          notifyHeight();
        }

        new MutationObserver(notifyHeight).observe(document.documentElement, {
          childList: true,
          subtree: true,
          attributes: true,
          characterData: true
        });

        setTimeout(notifyHeight, 150);
        setTimeout(notifyHeight, 600);
        setTimeout(notifyHeight, 1600);
      })();
    </script>
  </body>
</html>
''';
}
