import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  final Color? color;
  final Color? iconColor;
  final String text;
  final IconData? icon;
  const IconText(
      {super.key,
      this.color,
      this.iconColor,
      required this.icon,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 16,
          color: iconColor,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
              ),
        )
      ],
    );
  }
}
