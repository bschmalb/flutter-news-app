import 'package:flutter/material.dart';

class ArticleAction extends StatelessWidget {
  const ArticleAction({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
    );
  }
}
