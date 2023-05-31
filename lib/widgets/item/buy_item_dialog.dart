import 'package:flutter/material.dart';
import 'package:gdsctokyo/models/item/_item.dart';

class BuyItemDialog extends StatefulWidget {
  final Item item;

  const BuyItemDialog({super.key, required this.item});

  @override
  State<BuyItemDialog> createState() => _BuyItemDialogState();
}

class _BuyItemDialogState extends State<BuyItemDialog> {
  @override
  Widget build(BuildContext context) {
    Price? price = widget.item.price;
    String name = widget.item.name ?? '(Untitled)';
    double? savedAmount;
    if (price?.amount != null && price?.compareAtPrice != null) {
      savedAmount = price!.compareAtPrice! - price.amount!;
    }

    return AlertDialog(
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(0)),
      contentPadding: const EdgeInsets.all(0),
      titlePadding: const EdgeInsets.symmetric(vertical: 10),
      actionsPadding: const EdgeInsets.all(0),
      title: Container(
          alignment: Alignment.center,
          child: Text('You bought $name',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontSize: 18))),
      content: Container(
          // alignment: Alignment.topCenter,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Theme.of(context).colorScheme.background,
          child: savedAmount != null
              ? Text(
                  'You saved ${price?.currency.symbol}$savedAmount with this purchase.',
                  textAlign: TextAlign.center,
                )
              : Text('You just saved $name from going to waste!',
                  textAlign: TextAlign.center)),
      actions: [
        TextButton(
            onPressed: () {
              print("TAPPED UNDO");
            },
            child: Text("Undo"))
      ],
    );
  }
}
