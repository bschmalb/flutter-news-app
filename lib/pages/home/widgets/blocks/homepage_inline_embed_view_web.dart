// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

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
  static int _nextViewId = 0;

  late final String _viewType;
  late final html.IFrameElement _iframeElement;
  StreamSubscription<html.Event>? _loadSubscription;
  StreamSubscription<html.Event>? _errorSubscription;
  StreamSubscription<html.MessageEvent>? _messageSubscription;

  @override
  void initState() {
    super.initState();
    _viewType = 'homepage-inline-embed-${_nextViewId++}';
    _iframeElement = _createIframe(widget.document);
    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (_) => _iframeElement,
    );
    _subscribeToEvents();
  }

  @override
  void didUpdateWidget(covariant HomepageInlineEmbedView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.document != widget.document) {
      _iframeElement.srcdoc = widget.document;
    }

    if (oldWidget.isInteractionEnabled != widget.isInteractionEnabled) {
      _applyInteractionState(_iframeElement);
    }
  }

  @override
  void dispose() {
    _loadSubscription?.cancel();
    _errorSubscription?.cancel();
    _messageSubscription?.cancel();
    super.dispose();
  }

  html.IFrameElement _createIframe(String document) {
    final iframe = html.IFrameElement()
      ..srcdoc = document
      ..style.border = '0'
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.display = 'block';

    _applyInteractionState(iframe);
    return iframe;
  }

  void _applyInteractionState(html.IFrameElement iframe) {
    iframe.style.pointerEvents = widget.isInteractionEnabled ? 'auto' : 'none';
  }

  void _subscribeToEvents() {
    _loadSubscription = _iframeElement.onLoad.listen((_) {
      widget.onLoadingChanged?.call(false);
      widget.onErrorChanged?.call(null);
    });

    _errorSubscription = _iframeElement.onError.listen((_) {
      widget.onLoadingChanged?.call(false);
      widget.onErrorChanged?.call(
        'The external embed could not be loaded in the browser.',
      );
    });

    _messageSubscription = html.window.onMessage.listen((event) {
      if (event.source != _iframeElement.contentWindow) return;

      final payload = event.data;
      if (payload is! String) return;

      final decoded = _tryDecodeMessage(payload);
      if (decoded is! Map<String, dynamic>) return;
      if (decoded['type'] != 'ksta-embed-height') return;

      final height = switch (decoded['height']) {
        final num value => value.toDouble(),
        final String value => double.tryParse(value),
        _ => null,
      };

      if (height != null) {
        widget.onHeightChanged?.call(height);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: HtmlElementView(viewType: _viewType),
    );
  }
}

Object? _tryDecodeMessage(String payload) {
  try {
    return jsonDecode(payload);
  } catch (_) {
    return null;
  }
}
