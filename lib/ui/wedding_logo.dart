import 'package:flutter/material.dart';

class WeddingLogo extends StatelessWidget {
  final double size;

  const WeddingLogo({
    super.key,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.favorite,
      color: const Color(0xFFB76E79),
      size: size,
    );
  }
}