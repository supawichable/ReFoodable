import 'package:flutter/material.dart';

class DescriptionText extends StatelessWidget {
  final Color? color;
  final String text;
  final double size;
  final double height;
  const DescriptionText({
    super.key,
    this.color = Colors.black,
    required this.text,
    this.size = 12,
    this.height = 1.2,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        height: height,
        fontFamily: 'Poppins',
      ),
    );
  }
}
