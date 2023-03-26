import 'package:flutter/material.dart';

enum DiscountView {
  byPrice,
  byPercent,
}

extension Label on DiscountView {
  String get label {
    switch (this) {
      case DiscountView.byPrice:
        return 'By Price';
      case DiscountView.byPercent:
        return 'By Percent';
    }
  }
}

class SingleChoice extends StatelessWidget {
  final DiscountView discountView;
  final Function(Set<DiscountView>) onDiscountViewChanged;

  const SingleChoice(
      {super.key,
      required this.onDiscountViewChanged,
      required this.discountView});

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<DiscountView>(
      selectedIcon: const Icon(Icons.check),
      segments: <ButtonSegment<DiscountView>>[
        ButtonSegment<DiscountView>(
          icon: const Icon(Icons.attach_money),
          value: DiscountView.byPrice,
          label: Text(DiscountView.byPrice.label),
        ),
        ButtonSegment<DiscountView>(
          icon: const Icon(Icons.percent),
          value: DiscountView.byPercent,
          label: Text(DiscountView.byPercent.label),
        ),
      ],
      selected: <DiscountView>{discountView},
      onSelectionChanged: onDiscountViewChanged,
    );
  }
}
