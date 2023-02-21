import 'package:flutter/material.dart';
import 'package:gdsctokyo/widgets/description_text.dart';

class IconText extends StatelessWidget {
  Color? color;
  Color? iconColor;
  final String text;
  IconData? iconType;
  IconText(
      {super.key,
      this.color = Colors.black,
      this.iconColor = Colors.black,
      required this.iconType,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(
            right: 6,
          ),
          child: Icon(
            iconType,
            size: 15,
            color: iconColor,
          ),
        ),
        DescriptionText(text: text, color: color, )
      ],
    );
  }
}
