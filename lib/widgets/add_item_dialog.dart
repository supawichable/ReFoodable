import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/item/_item.dart';
import 'package:gdsctokyo/theme/color_schemes.dart';

class AddItemDialog extends StatefulWidget {
  final String storeId;

  const AddItemDialog({super.key, required this.storeId});

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  late TextEditingController _controllerMenuName;
  late TextEditingController _controllerNormalPrice;
  late TextEditingController _controllerDiscountedPrice;

  String? menuName;
  double? normalPrice;
  double? discountedPrice;

  @override
  void initState() {
    super.initState();

    _controllerMenuName = TextEditingController();
    _controllerNormalPrice = TextEditingController();
    _controllerDiscountedPrice = TextEditingController();
  }

  @override
  void dispose() {
    _controllerMenuName.dispose();
    _controllerNormalPrice.dispose();
    _controllerDiscountedPrice.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      contentPadding: const EdgeInsets.all(0),
      titlePadding: const EdgeInsets.symmetric(vertical: 10),
      actionsPadding: const EdgeInsets.all(0),
      title: Container(
        alignment: Alignment.center,
        child: Text(
          'Add to my list',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      content: Container(
        width: 400,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 240,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Menu name',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith()),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 40,
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: lightColorScheme.outlineVariant),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: lightColorScheme.outline),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      hintText: 'menu name',
                    ),
                    controller: _controllerMenuName,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Normal price',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith()),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 40,
                        child: TextField(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: lightColorScheme.outlineVariant),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: lightColorScheme.outline),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            hintText: 'normal',
                          ),
                          controller: _controllerNormalPrice,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Discounted price',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith()),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 40,
                        child: TextField(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: lightColorScheme.outlineVariant),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: lightColorScheme.outline),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            hintText: 'discounted',
                          ),
                          controller: _controllerDiscountedPrice,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Menu name',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith()),
              const SizedBox(
                height: 8,
              ),
              Row(children: [
                Flexible(
                  flex: 4,
                  child: Container(
                    height: 50,
                    color: lightColorScheme.primaryContainer,
                  ),
                ),
                const SizedBox(width: 20,),
                Flexible(
                  flex: 1,
                  child: Container(
                    height: 50,
                    color: lightColorScheme.primaryContainer,
                  ),
                ),
              ]),
            ]),
          ],
        ),
      ),
      actions: [
        Container(
          padding: const EdgeInsets.only(right: 10),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    menuName = _controllerMenuName.text;
                    normalPrice = double.parse(_controllerNormalPrice.text);
                    discountedPrice =
                        double.parse(_controllerDiscountedPrice.text);
                  });
                  final itemDoc = FirebaseFirestore.instance.stores
                      .doc(widget.storeId)
                      .items.doc();

                  final Item item = Item(
                    name: menuName,
                    id: itemDoc.id,
                    price: Price(
                        amount: discountedPrice!,
                        compareAtPrice: normalPrice,
                        currency: Currency.jpy),
                    addedBy: FirebaseAuth.instance.currentUser!.uid,
                  );

                  itemDoc.set(item);

                  Navigator.pop(context);
                },
                child: const Text('submit'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
