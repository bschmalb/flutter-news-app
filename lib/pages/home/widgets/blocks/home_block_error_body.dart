import 'package:flutter/material.dart';
import 'package:ksta/utils/app_breakpoint.dart';

class HomepageBlockErrorBody extends StatelessWidget {
  const HomepageBlockErrorBody({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final spacing = context.breakpoint.blockSpacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: spacing),
        OutlinedButton(
          onPressed: onRetry,
          child: const Text('Reload section'),
        ),
      ],
    );
  }
}
