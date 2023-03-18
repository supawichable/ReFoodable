import 'package:flutter/material.dart';

List<String> discountType = ["By Price", "By %"];

class SingleChoice extends StatefulWidget {
  final Function(String) onDiscountViewChanged;

  SingleChoice({required this.onDiscountViewChanged});

  @override
  State<SingleChoice> createState() => _SingleChoiceState();
}

class _SingleChoiceState extends State<SingleChoice> {
  String discountView = "By Price";

  void _onDiscountViewChanged(String newView) {
    setState(() {
      discountView = newView;
    });
    widget.onDiscountViewChanged(newView);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: Stack(children: [
        SegmentedButton<String>(
          segments: const <ButtonSegment<String>>[
            ButtonSegment<String>(
              value: "By Price",
              label: Text(''),
              // padding: EdgeInsets.zero,
            ),
            ButtonSegment<String>(
              value: "By %",
              label: Text(''),
            )
          ],
          selected: <String>{discountView},
          onSelectionChanged: (Set<String> newSelection) {
            setState(() {
              // By default there is only a single segment that can be
              // selected at one time, so its value is always the first
              // item in the selected set.
              _onDiscountViewChanged(newSelection.first);
            });
          },
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all<Size>(
              Size(8, 20),
            ),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(vertical: 0, horizontal: 40),
              // EdgeInsets.zero),
            ),
            foregroundColor:
                MaterialStateProperty.all<Color>(Colors.transparent),
          ),
        ),
        Positioned.fill(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () {
                    _onDiscountViewChanged("By Price");
                  },
                  child: Text('By Price', style: TextStyle(fontSize: 12))),
              GestureDetector(
                  onTap: () {
                    _onDiscountViewChanged("By %");
                  },
                  child: Text('By %', style: TextStyle(fontSize: 12))),
            ],
          ),
        ),
      ]),
    );
  }
}
