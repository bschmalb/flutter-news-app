import 'package:flutter/material.dart';

class ArticleDetailPage extends StatelessWidget {
  const ArticleDetailPage({
    super.key,
    required this.slug,
    required this.id,
  });

  static const rootName = 'articles';

  final String slug;
  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article'),
      ),
      body: Center(
        child: Text('/$rootName/$slug-$id'),
      ),
    );
  }
}
