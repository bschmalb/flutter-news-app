import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomepageInlineEmbedView extends StatefulWidget {
  const HomepageInlineEmbedView({
    required this.document,
    required this.height,
    required this.isInteractionEnabled,
    this.onHeightChanged,
    this.onLoadingChanged,
    this.onErrorChanged,
    super.key,
  });

  final String document;
  final double height;
  final bool isInteractionEnabled;
  final ValueChanged<double>? onHeightChanged;
  final ValueChanged<bool>? onLoadingChanged;
  final ValueChanged<String?>? onErrorChanged;

  @override
  State<HomepageInlineEmbedView> createState() => _HomepageInlineEmbedViewState();
}

class _HomepageInlineEmbedViewState extends State<HomepageInlineEmbedView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = _buildController();
    _loadDocument();
  }

  @override
  void didUpdateWidget(covariant HomepageInlineEmbedView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.document != widget.document) {
      _loadDocument();
    }
  }

  WebViewController _buildController() {
    return WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            widget.onLoadingChanged?.call(true);
            widget.onErrorChanged?.call(null);
          },
          onPageFinished: (_) {
            widget.onLoadingChanged?.call(false);
          },
          onWebResourceError: (error) {
            widget.onLoadingChanged?.call(false);
            widget.onErrorChanged?.call(error.description);
          },
        ),
      )
      ..addJavaScriptChannel(
        'Resize',
        onMessageReceived: (message) {
          final nextHeight = double.tryParse(message.message);
          if (nextHeight == null) return;
          widget.onHeightChanged?.call(nextHeight);
        },
      );
  }

  void _loadDocument() {
    _controller.loadHtmlString(widget.document);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: IgnorePointer(
        ignoring: !widget.isInteractionEnabled,
        child: WebViewWidget(
          controller: _controller,
        ),
      ),
    );
  }
}
