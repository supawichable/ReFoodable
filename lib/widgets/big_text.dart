import 'package:flutter/material.dart';

class BigText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  TextOverflow overFlow;
  BigText(
      {super.key,
      this.color = Colors.black,
      required this.text,
      this.overFlow = TextOverflow.ellipsis,
      this.size = 20});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1, // making sure overflow works propperly
      overflow: overFlow,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w400,
        fontSize: size,
        fontFamily: 'Poppins',
      ),
    );
  }
}