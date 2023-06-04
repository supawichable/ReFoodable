import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/models/item/_item.dart';

class BuyItemDialog extends StatefulWidget {
  final Item item;

  const BuyItemDialog({super.key, required this.item});

  @override
  State<BuyItemDialog> createState() => _BuyItemDialogState();
}

class _BuyItemDialogState extends State<BuyItemDialog> {
  final ref = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);

  double? _getSavedAmount(price) {
    if (price?.amount != null && price?.compareAtPrice != null) {
      return price!.compareAtPrice! - price.amount!;
    }
    return null;
  }

  Future _addAmountSaved(double priceDiff) async {
    try {
      final userData = await ref.get();
      final num moneySaved = userData['money_saved'] ?? 0;
      final num foodItemSaved = userData['food_item_saved'] ?? 0;
      await ref.update({
        'money_saved': moneySaved + priceDiff,
        'food_item_saved': foodItemSaved + 1
      });
    } catch (e) {
      print("ERRORR: $e");
    }
  }

  Future _undoAmountSaved(double priceDiff) async {
    try {
      final userData = await ref.get();
      final num moneySaved = userData['money_saved'] ?? 0;
      final num foodItemSaved = userData['food_item_saved'] ?? 0;
      await ref.update({
        'money_saved': moneySaved - priceDiff,
        'food_item_saved': foodItemSaved - 1
      });
    } catch (e) {
      print("ERRORR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Price? price = widget.item.price;
    String name = widget.item.name ?? '(Untitled)';
    double? savedAmount = _getSavedAmount(price);

    if (FirebaseAuth.instance.currentUser != null && savedAmount != null) {
      _addAmountSaved(savedAmount);
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
              if (FirebaseAuth.instance.currentUser != null && savedAmount != null) {
                _undoAmountSaved(savedAmount);
              }
              Navigator.pop(context);
            },
            child: const Text('Undo')
        )
      ],
    );
  }
}
