import 'package:flutter/material.dart';

class ArticleTitlePrefixText extends StatelessWidget {
  const ArticleTitlePrefixText({required this.text, this.prominent = false, this.maxLines = 2, super.key});

  final String text;
  final bool prominent;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final highlightColor = theme.brightness == Brightness.dark ? const Color(0xFF4AA8FF) : const Color(0xFF0B6FC8);
    final baseStyle = prominent ? theme.textTheme.titleLarge : theme.textTheme.titleSmall;

    return Text(
      text,
      maxLines: maxLines,
      overflow: .ellipsis,
      style: baseStyle?.copyWith(color: highlightColor, fontWeight: FontWeight.w700, height: 1.15),
    );
  }
}
