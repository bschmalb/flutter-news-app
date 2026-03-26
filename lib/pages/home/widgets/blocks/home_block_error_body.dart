import 'package:flutter/material.dart';

class HomepageBlockErrorBody extends StatelessWidget {
  const HomepageBlockErrorBody({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      const SizedBox(height: 12),
      OutlinedButton(
        onPressed: onRetry,
        child: const Text('Reload section'),
      ),
    ],
  );
}
