import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ksta/data/news/models/homepage_block_model.dart';
import 'package:ksta/pages/home/widgets/blocks/homepage_embed_document.dart';
import 'package:ksta/pages/home/widgets/blocks/homepage_inline_embed_view.dart';

class HomepageEmbedBlockBody extends StatefulWidget {
  const HomepageEmbedBlockBody({
    required this.block,
    super.key,
  });

  final EmbedHomepageBlockModel block;

  @override
  State<HomepageEmbedBlockBody> createState() => _HomepageEmbedBlockBodyState();
}

class _HomepageEmbedBlockBodyState extends State<HomepageEmbedBlockBody> {
  late double _embedHeight;
  late bool _hasConsent;
  bool _isLoading = false;
  String? _errorMessage;
  int _reloadToken = 0;

  String? get _embedDocument => buildEmbedDocument(widget.block);

  @override
  void initState() {
    super.initState();
    _resetFromBlock(widget.block);
  }

  @override
  void didUpdateWidget(covariant HomepageEmbedBlockBody oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.block != widget.block) {
      _resetFromBlock(widget.block);
    }
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
    final theme = Theme.of(context);

    if (!_hasConsent) {
      return _EmbedContainer(
        child: Padding(
          padding: const .all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.block.providerName ?? 'External content',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'This section loads content from an external provider. Tap below to load it inline.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: _grantConsent,
                child: const Text('Load external content'),
              ),
            ],
          ),
        ),
      );
    }

    final document = _embedDocument;
    if (document == null) {
      return _EmbedContainer(
        child: Padding(
          padding: const .all(16),
          child: Text(
            'No embeddable payload was provided for this section.',
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    return _EmbedContainer(
      child: Stack(
        children: [
          HomepageInlineEmbedView(
            key: ValueKey('${widget.block.hashCode}-$_reloadToken'),
            document: document,
            height: _embedHeight,
            onHeightChanged: (height) {
              final clampedHeight = height.clamp(
                homepageEmbedMinimumHeight,
                homepageEmbedMaximumHeight,
              );

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
          if (_isLoading)
            const Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: LinearProgressIndicator(),
            ),
          if (_errorMessage != null)
            Positioned.fill(
              child: ColoredBox(
                color: theme.colorScheme.surface.withValues(alpha: 0.92),
                child: Padding(
                  padding: const .all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Failed to load external content.',
                        style: theme.textTheme.titleSmall,
                        textAlign: .center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: .center,
                      ),
                      const SizedBox(height: 12),
                      FilledButton.tonal(
                        onPressed: _retry,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmbedContainer extends StatelessWidget {
  const _EmbedContainer({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: .circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      child: ClipRRect(
        borderRadius: .circular(16),
        child: child,
      ),
    );
  }
}
