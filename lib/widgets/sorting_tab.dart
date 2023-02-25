import 'package:flutter/material.dart';
import 'package:gdsctokyo/theme/color_schemes.dart';
import 'package:gdsctokyo/widgets/description_text.dart';

class SortingTab extends StatefulWidget {
  const SortingTab({super.key});

  @override
  State<SortingTab> createState() => _SortingTabState();
}

class _SortingTabState extends State<SortingTab> {
  List<bool> _selections = List.generate(3, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: ToggleButtons(
        fillColor: Colors.transparent,
        renderBorder: false,
        children: [
          Container(
            height: 35,
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            margin: EdgeInsets.only(
              right: 2.5,
              left: 2.5,
              top: 10,
            ),
            decoration: BoxDecoration(
                color: _selections[0]
                    ? lightColorScheme.primaryContainer
                    : Colors.brown[50],
                borderRadius: BorderRadius.circular(20)),
            alignment: Alignment.center,
            child: DescriptionText(text: 'Nearest'),
          ),
          Container(
            height: 35,
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            margin: EdgeInsets.only(
              right: 2.5,
              left: 2.5,
              top: 10,
            ),
            decoration: BoxDecoration(
                color: _selections[1]
                    ? lightColorScheme.primaryContainer
                    : Colors.brown[50],
                borderRadius: BorderRadius.circular(20)),
            alignment: Alignment.center,
            child: DescriptionText(text: 'Cheapest'),
          ),
          Container(
            height: 35,
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            margin: EdgeInsets.only(
              right: 2.5,
              left: 2.5,
              top: 10,
            ),
            decoration: BoxDecoration(
                color: _selections[2]
                    ? lightColorScheme.primaryContainer
                    : Colors.brown[50],
                borderRadius: BorderRadius.circular(20)),
            alignment: Alignment.center,
            child: Row(children: [
              DescriptionText(text: 'Category'),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
              ),
            ]),
          ),
        ],
        splashColor: Colors.transparent,
        onPressed: (int newIndex) {
          setState(() {
            for (int index = 0; index < 3; index += 1) {
              if (index == newIndex) {
                _selections[index] = true;
              } else {
                _selections[index] = false;
              }
            }
          });
        },
        isSelected: _selections,
      ),
    );
  }
}
