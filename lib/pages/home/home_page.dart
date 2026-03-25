import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: .center,
              children: [
                Text('KSTA', style: textTheme.headlineMedium),
                const SizedBox(height: 12),
                Text('Empty app scaffold', style: textTheme.bodyLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
