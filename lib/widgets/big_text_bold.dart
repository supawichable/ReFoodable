import 'package:flutter/material.dart';

class BigBoldText extends StatelessWidget {
  final Color? color;
  final String text;
  final double size;
  final TextOverflow overFlow;
  const BigBoldText(
      {super.key,
      this.color = Colors.black,
      required this.text,
      this.overFlow = TextOverflow.ellipsis,
      this.size = 18});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1, // making sure overflow works propperly
      overflow: overFlow,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w900,
        fontSize: size,
        fontFamily: 'Poppins',
      ),
    );
  }
}
