import 'package:flutter/material.dart';
import '../theme/color_schemes.dart';
import 'big_text_bold.dart';
import 'big_text_semibold.dart';

class ListHeader extends StatelessWidget {
  final String text;
  ListHeader({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BigSemiboldText(
            text: text,
            size: 16,
          ),
          TextButton(
              onPressed: () {},
              child: BigBoldText(
                text: 'edit',
                color: lightColorScheme.surfaceTint,
                size: 12,
              ))
        ],
      ),
    );
  }
}
