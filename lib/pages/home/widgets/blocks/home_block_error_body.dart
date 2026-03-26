import 'package:flutter/material.dart';
import 'package:ksta/utils/app_breakpoint.dart';

class HomepageBlockErrorBody extends StatelessWidget {
  const HomepageBlockErrorBody({super.key, required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: context.breakpoint.blockSpacing,
      children: [
        Text(message, style: Theme.of(context).textTheme.bodyMedium),
        OutlinedButton(onPressed: onRetry, child: const Text('Reload section')),
      ],
    );
  }
}
