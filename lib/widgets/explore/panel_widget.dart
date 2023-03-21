import 'package:flutter/material.dart';
import 'package:gdsctokyo/widgets/common/icon_text.dart';

class PanelWidget extends StatelessWidget {
  final ScrollController controller;

  const PanelWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          controller: controller,
          children: []),
    );
  }
}
