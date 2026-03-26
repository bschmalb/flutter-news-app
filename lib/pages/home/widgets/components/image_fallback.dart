import 'package:flutter/material.dart';

class ImageFallback extends StatelessWidget {
  const ImageFallback({required this.icon, required this.backgroundColor, super.key});

  final IconData icon;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: backgroundColor,
    child: Center(child: Icon(icon)),
  );
}
