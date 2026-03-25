import 'package:flutter/material.dart';
import 'package:ksta/router/router.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            const ArticleDetailRoute(
              slug: 'test-article',
              id: 1,
            ).push<void>(context);
          },
          child: const Text('Open test article'),
        ),
      ),
    );
  }
}
