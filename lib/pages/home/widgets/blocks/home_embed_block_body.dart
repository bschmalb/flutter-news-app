import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:ksta/data/news/models/homepage_block_model.dart';
import 'package:ksta/pages/home/widgets/blocks/homepage_embed_document.dart';
import 'package:ksta/pages/home/widgets/blocks/homepage_inline_embed_view.dart';

class HomepageEmbedBlockBody extends StatefulWidget {
  const HomepageEmbedBlockBody({required this.block, super.key});

  final EmbedHomepageBlockModel block;

  @override
  State<HomepageEmbedBlockBody> createState() => _HomepageEmbedBlockBodyState();
}

class _HomepageEmbedBlockBodyState extends State<HomepageEmbedBlockBody> {
  late double _embedHeight;
  late bool _hasConsent;
  bool _isLoading = false;
  bool _isModifierPressed = false;
  bool _showInteractionHint = false;
  String? _errorMessage;
  int _reloadToken = 0;
  Timer? _interactionHintTimer;

  String? get _embedDocument => buildEmbedDocument(widget.block);
  bool get _usesInteractionLock {
    return switch (defaultTargetPlatform) {
      TargetPlatform.macOS || TargetPlatform.windows || TargetPlatform.linux => true,
      _ => false,
    };
  }

  bool get _isEmbedInteractionEnabled {
    if (!_usesInteractionLock) return true;
    if (!_hasConsent || _errorMessage != null) return false;
    return _isModifierPressed;
  }

  @override
  void initState() {
    super.initState();
    _resetFromBlock(widget.block);
    HardwareKeyboard.instance.addHandler(_handleHardwareKeyEvent);
  }

  @override
  void didUpdateWidget(covariant HomepageEmbedBlockBody oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.block != widget.block) {
      _resetFromBlock(widget.block);
    }
  }

  @override
  void dispose() {
    _interactionHintTimer?.cancel();
    HardwareKeyboard.instance.removeHandler(_handleHardwareKeyEvent);
    super.dispose();
  }

  void _resetFromBlock(EmbedHomepageBlockModel block) {
    _embedHeight = preferredHeightForEmbed(block);
    _hasConsent = !block.requiresConsent;
    _isLoading = _hasConsent && buildEmbedDocument(block) != null;
    _errorMessage = null;
    _reloadToken = 0;
  }

  void _grantConsent() {
    setState(() {
      _hasConsent = true;
      _isLoading = true;
      _errorMessage = null;
      _reloadToken++;
    });
  }

  void _retry() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _reloadToken++;
    });
  }

  bool _handleHardwareKeyEvent(KeyEvent event) {
    final isModifierPressed = HardwareKeyboard.instance.isControlPressed || HardwareKeyboard.instance.isMetaPressed;

    if (isModifierPressed == _isModifierPressed) {
      return false;
    }

    _setStateSafely(() {
      _isModifierPressed = isModifierPressed;
    });
    return false;
  }

  void _showInteractionHintTemporarily() {
    if (!_usesInteractionLock || _isEmbedInteractionEnabled || _errorMessage != null) {
      return;
    }

    _interactionHintTimer?.cancel();

    if (!_showInteractionHint) {
      _setStateSafely(() {
        _showInteractionHint = true;
      });
    }

    _interactionHintTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted || !_showInteractionHint) return;
      _setStateSafely(() {
        _showInteractionHint = false;
      });
    });
  }

  void _setStateSafely(VoidCallback fn) {
    if (!mounted) return;

    final phase = SchedulerBinding.instance.schedulerPhase;
    if (phase == SchedulerPhase.persistentCallbacks) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(fn);
      });
      return;
    }

    setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasConsent) {
      return _EmbedConsentLayer(providerName: widget.block.providerName, onGrantConsent: _grantConsent);
    }

    final document = _embedDocument;
    if (document == null) {
      return _EmbedContainer(
        child: Padding(
          padding: const .all(16),
          child: Text('No embeddable payload was provided for this section.', style: Theme.of(context).textTheme.bodyMedium),
        ),
      );
    }

    return RepaintBoundary(
      child: MouseRegion(
        onEnter: _usesInteractionLock ? (_) => _showInteractionHintTemporarily() : null,
        onHover: _usesInteractionLock ? (_) => _showInteractionHintTemporarily() : null,
        child: Listener(
          onPointerDown: _usesInteractionLock ? (_) => _showInteractionHintTemporarily() : null,
          onPointerSignal: _usesInteractionLock ? (_) => _showInteractionHintTemporarily() : null,
          child: _EmbedContainer(
            child: Stack(
              children: [
                HomepageInlineEmbedView(
                  key: ValueKey('${widget.block.hashCode}-$_reloadToken'),
                  document: document,
                  height: _embedHeight,
                  isInteractionEnabled: _isEmbedInteractionEnabled,
                  onHeightChanged: (height) {
                    final clampedHeight = height.clamp(homepageEmbedMinimumHeight, homepageEmbedMaximumHeight);

                    if ((clampedHeight - _embedHeight).abs() < 1) return;

                    _setStateSafely(() {
                      _embedHeight = clampedHeight;
                    });
                  },
                  onLoadingChanged: (isLoading) {
                    if (_isLoading == isLoading) return;

                    _setStateSafely(() {
                      _isLoading = isLoading;
                    });
                  },
                  onErrorChanged: (message) {
                    if (_errorMessage == message) return;

                    _setStateSafely(() {
                      _errorMessage = message;
                    });
                  },
                ),
                if (_usesInteractionLock && _showInteractionHint && !_isEmbedInteractionEnabled)
                  _EmbedInteractionHint(),
                if (_isLoading) const Positioned(top: 12, left: 12, right: 12, child: LinearProgressIndicator()),
                if (_errorMessage != null) _EmbedErrorLayer(errorMessage: _errorMessage!, onRetry: _retry),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmbedConsentLayer extends StatelessWidget {
  const _EmbedConsentLayer({required this.providerName, required this.onGrantConsent});

  final String? providerName;
  final VoidCallback onGrantConsent;

  @override
  Widget build(BuildContext context) {
    return _EmbedContainer(
      child: Padding(
        padding: const .all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(providerName ?? 'External content', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Text(
              'This section loads content from an external provider. Tap below to load it inline.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            FilledButton.tonal(onPressed: onGrantConsent, child: const Text('Load external content')),
          ],
        ),
      ),
    );
  }
}

class _EmbedInteractionHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.surface.withValues(alpha: 0.06),
                Theme.of(context).colorScheme.surface.withValues(alpha: 0.12),
              ],
            ),
          ),
          child: Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.96),
                borderRadius: .circular(999),
                border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Text(
                  'Hold Ctrl or Cmd to interact with this embed',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: .center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmbedErrorLayer extends StatelessWidget {
  const _EmbedErrorLayer({required this.errorMessage, required this.onRetry});

  final String errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.92),
        child: Padding(
          padding: const .all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Failed to load external content.', style: Theme.of(context).textTheme.titleSmall, textAlign: .center),
              const SizedBox(height: 8),
              Text(
                errorMessage,
                style:
                    Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                textAlign: .center,
              ),
              const SizedBox(height: 12),
              FilledButton.tonal(onPressed: onRetry, child: const Text('Retry')),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmbedContainer extends StatelessWidget {
  const _EmbedContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: .circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: ClipRRect(borderRadius: .circular(16), child: child),
    );
  }
}
