import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/item/_item.dart';
import 'package:gdsctokyo/widgets/segmented_button.dart';

enum ItemBucket { today, my, my2today }

final _stores = FirebaseFirestore.instance.stores;

class AddItemDialog extends StatefulWidget {
  final String storeId;
  final String? itemId;

  final ItemBucket bucket;

  const AddItemDialog({
    super.key,
    this.itemId,
    required this.storeId,
    required this.bucket,
  });

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  late final String itemId =
      widget.itemId == null || widget.bucket == ItemBucket.my2today
          ? _stores.doc().id
          : widget.itemId!;
  late final CollectionReference<Item> getCollection;
  late final CollectionReference<Item> addCollection;

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controllerMenuName =
      TextEditingController();
  late final TextEditingController _controllerNormalPrice =
      TextEditingController();
  late final TextEditingController _controllerDiscountedPrice =
      TextEditingController();
  late final TextEditingController _controllerDiscountedPercent =
      TextEditingController();

  DiscountView currentDiscountView = DiscountView.byPrice;

  void _handleDiscountViewChanged(Set<DiscountView> newView) {
    setState(() {
      currentDiscountView = newView.first;
    });
  }

  DocumentSnapshot<Item>? _itemSnapshot;
  bool _isLoading = true;

  String getDiscountedPrice(String normalPrice, String percent) {
    final normalPriceDouble = double.tryParse(normalPrice);
    final percentDouble = double.tryParse(percent);

    if (normalPriceDouble == null || percentDouble == null) {
      return '';
    }

    return (normalPriceDouble * (1 - percentDouble / 100)).toStringAsFixed(2);
  }

  String getPercentage(String normalPrice, String discountedPrice) {
    final normalPriceDouble = double.tryParse(normalPrice);
    final discountedPriceDouble = double.tryParse(discountedPrice);

    if (normalPriceDouble == null || discountedPriceDouble == null) {
      return '';
    }

    return ((1 - discountedPriceDouble / normalPriceDouble) * 100)
        .toStringAsFixed(2);
  }

  @override
  void initState() {
    super.initState();

    switch (widget.bucket) {
      case ItemBucket.today:
        getCollection = _stores.doc(widget.storeId).todaysItems;
        addCollection = _stores.doc(widget.storeId).todaysItems;
        break;
      case ItemBucket.my:
        getCollection = _stores.doc(widget.storeId).myItems;
        addCollection = _stores.doc(widget.storeId).myItems;
        break;
      case ItemBucket.my2today:
        getCollection = _stores.doc(widget.storeId).myItems;
        addCollection = _stores.doc(widget.storeId).todaysItems;
        break;
    }

    if (widget.itemId == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    getCollection.doc(widget.itemId).get().then(
      (snapshot) {
        _itemSnapshot = snapshot;
        final item = snapshot.data();
        _controllerMenuName.text = item?.name ?? '';
        _controllerNormalPrice.text =
            item?.price?.compareAtPrice.toString() ?? '';

        _controllerDiscountedPrice.text = item?.price?.amount.toString() ?? '';
        _controllerDiscountedPercent.text = getPercentage(
          _controllerNormalPrice.text,
          _controllerDiscountedPrice.text,
        );

        setState(
          () {
            _isLoading = false;
          },
        );
      },
    ).catchError((e) {
      setState(() {
        _isLoading = false;
      });
    });
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
          widget.bucket == ItemBucket.today ||
                  widget.bucket == ItemBucket.my2today
              ? 'Add to today\'s menu'
              : 'Add to my menu',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      content: Form(
        key: _formKey,
        child: Container(
          width: 400,
          color: Theme.of(context).colorScheme.background,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 320,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 8),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // debug container with border red full width height 2
                      Text('Menu name*',
                          style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 40,
                        child: TextFormField(
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .outlineVariant),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.outline),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            hintText: 'menu name',
                          ),
                          controller: _controllerMenuName,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter menu name';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (widget.bucket != ItemBucket.my) ...[
                    SingleChoice(
                        onDiscountViewChanged: _handleDiscountViewChanged,
                        discountView: currentDiscountView),
                    const SizedBox(height: 8),
                  ],
                  Row(
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                currentDiscountView == DiscountView.byPrice
                                    ? 'Normal price'
                                    : 'Normal price*',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith()),
                            const SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                              height: 40,
                              child: TextFormField(
                                  onChanged: (_) {
                                    if (currentDiscountView ==
                                        DiscountView.byPrice) {
                                      setState(() {
                                        _controllerDiscountedPercent.text =
                                            getPercentage(
                                          _controllerNormalPrice.text,
                                          _controllerDiscountedPrice.text,
                                        );
                                      });
                                    } else {
                                      setState(() {
                                        _controllerDiscountedPrice.text =
                                            getDiscountedPrice(
                                          _controllerNormalPrice.text,
                                          _controllerDiscountedPercent.text,
                                        );
                                      });
                                    }
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 10),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outlineVariant),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    hintText: 'normal',
                                  ),
                                  controller: _controllerNormalPrice,
                                  // check if is double
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter normal price';
                                    }
                                    if (double.tryParse(value) == null) {
                                      return 'Please enter valid price';
                                    }
                                    return null;
                                  }),
                            ),
                          ],
                        ),
                      ),
                      if (widget.bucket != ItemBucket.my) ...[
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  currentDiscountView == DiscountView.byPrice
                                      ? 'Discounted price'
                                      : 'Discounted percent*',
                                  style:
                                      Theme.of(context).textTheme.labelLarge),
                              const SizedBox(
                                height: 8,
                              ),
                              SizedBox(
                                height: 40,
                                child: Stack(
                                  alignment: Alignment.centerRight,
                                  children: [
                                    TextFormField(
                                      autofocus: true,
                                      keyboardType: TextInputType.number,
                                      onChanged: (_) {
                                        if (currentDiscountView ==
                                            DiscountView.byPrice) {
                                          setState(() {
                                            _controllerDiscountedPercent.text =
                                                getPercentage(
                                              _controllerNormalPrice.text,
                                              _controllerDiscountedPrice.text,
                                            );
                                          });
                                        } else {
                                          setState(() {
                                            _controllerDiscountedPrice.text =
                                                getDiscountedPrice(
                                              _controllerNormalPrice.text,
                                              _controllerDiscountedPercent.text,
                                            );
                                          });
                                        }
                                      },
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 10),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outlineVariant),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        hintText: 'discounted',
                                      ),
                                      controller: currentDiscountView ==
                                              DiscountView.byPrice
                                          ? _controllerDiscountedPrice
                                          : _controllerDiscountedPercent,
                                      // check if is double
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter discounted price';
                                        }
                                        if (double.tryParse(value) == null) {
                                          return 'Please enter valid price';
                                        }
                                        return null;
                                      },
                                    ),
                                    if (currentDiscountView ==
                                        DiscountView.byPercent)
                                      const Padding(
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: Text('%'),
                                      )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ]
                    ],
                  ),
                  if (widget.bucket != ItemBucket.my) ...[
                    const SizedBox(height: 8),
                    if (currentDiscountView == DiscountView.byPercent)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Discounted Price = ${_controllerDiscountedPrice.text}',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.outline),
                        ),
                      )
                    else
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Discounted Percent = ${_controllerDiscountedPercent.text}',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.outline),
                        ),
                      ),
                  ],
                  const SizedBox(height: 8),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Menu name',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith()),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(children: [
                          Flexible(
                            flex: 4,
                            child: Container(
                              height: 50,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              height: 50,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                          ),
                        ]),
                      ]),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        Container(
          padding: const EdgeInsets.only(right: 10),
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: _submit,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : Text(widget.bucket == ItemBucket.my
                        ? 'Save to My Items'
                        : 'Add to Today\'s List'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final name = _controllerMenuName.text;
    final compareAtPrice = double.parse(_controllerNormalPrice.text);
    final amount = double.parse(_controllerDiscountedPrice.text);

    final snackBar = SnackBar(
      content: widget.bucket == ItemBucket.my
          ? Text('$name was added to My Items')
          : Text('$name was added to Today\'s Items'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () async {
          await addCollection.doc(itemId).delete();
        },
      ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    if (_formKey.currentState!.validate()) {
      final originalItem = _itemSnapshot?.data() ?? const Item();
      final item = originalItem.copyWith(
          name: name,
          price: Price(
              amount: amount,
              compareAtPrice: compareAtPrice,
              currency: Currency.jpy),
          addedBy: FirebaseAuth.instance.currentUser!.uid,
          updatedAt: null);

      await addCollection.doc(itemId).set(item);

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }
}
