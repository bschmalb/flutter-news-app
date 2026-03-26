import 'package:flutter/material.dart';

class ArticleErrorState extends StatelessWidget {
  const ArticleErrorState({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(vertical: 96),
      child: Column(
        children: [
          Text(message, style: Theme.of(context).textTheme.titleMedium, textAlign: .center),
          const SizedBox(height: 16),
          FilledButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ),
    );
  }
}
