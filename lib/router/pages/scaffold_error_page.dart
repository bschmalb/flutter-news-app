import 'package:flutter/material.dart';

class ScaffoldErrorPage extends StatelessWidget {
  const ScaffoldErrorPage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const .all(24),
          child: Text(
            message,
            textAlign: .center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
