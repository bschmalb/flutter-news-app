import 'package:flutter/material.dart';

class HomepageEmptySectionBody extends StatelessWidget {
  const HomepageEmptySectionBody({
    this.message = 'No teaser IDs available for this section.',
    super.key,
  });

  final String message;

  @override
  Widget build(BuildContext context) => Text(
    message,
    style: Theme.of(context).textTheme.bodyMedium,
  );
}
