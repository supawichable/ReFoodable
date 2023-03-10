import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/store/_store.dart';
import 'package:gdsctokyo/routes/router.gr.dart';
import 'package:gdsctokyo/widgets/store_info.dart';

import '../models/item/_item.dart';
import '../widgets/item_card.dart';
import '../widgets/my_items.dart';
import '../widgets/today_items.dart';

class StorePageMyItem extends StatelessWidget {
  final String storeId;

  const StorePageMyItem(
      {super.key, @PathParam('storeId') required this.storeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Items"),
        centerTitle: true,
        actions: [],
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          StoreInfo(storeId: storeId),
        ],
      ),
    );
  }
}

class StoreInfo extends StatefulWidget {
  final String storeId;

  const StoreInfo({super.key, required this.storeId});

  @override
  State<StoreInfo> createState() => _StoreInfoState();
}

class _StoreInfoState extends State<StoreInfo> {
  late Stream<DocumentSnapshot<Store>> _storeStream;

  @override
  void initState() {
    super.initState();
    _storeStream =
        FirebaseFirestore.instance.stores.doc(widget.storeId).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    List<Item> items = [
      Item(
        name: 'BentoBenjai',
        price: const Price(
          amount: 300,
          compareAtPrice: 500,
          currency: Currency.jpy,
        ),
        addedBy: 'atomicativesjai',
        createdAt: DateTime.parse('2022-10-05 13:20:00'),
        updatedAt: DateTime.parse('2022-10-05 13:20:00'),
        photoURL: 'lib/assets/images/tomyum.jpg',
      ),
      Item(
        name: 'BentoJa',
        price: const Price(
          amount: 200,
          compareAtPrice: 500,
          currency: Currency.jpy,
        ),
        addedBy: 'atomicativesjai',
        createdAt: DateTime.parse('2022-10-05 13:20:00'),
        updatedAt: DateTime.parse('2022-10-05 13:20:00'),
        photoURL: 'lib/assets/images/tomyum.jpg',
      ),
      Item(
        name: 'BentoBenjai',
        price: const Price(
          amount: 300,
          compareAtPrice: 500,
          currency: Currency.jpy,
        ),
        addedBy: 'atomicativesjai',
        createdAt: DateTime.parse('2022-10-05 13:20:00'),
        updatedAt: DateTime.parse('2022-10-05 13:20:00'),
        photoURL: 'lib/assets/images/tomyum.jpg',
      ),
      Item(
        name: 'BentoBenjai',
        price: const Price(
          amount: 300,
          compareAtPrice: 500,
          currency: Currency.jpy,
        ),
        addedBy: 'atomicativesjai',
        createdAt: DateTime.parse('2022-10-05 13:20:00'),
        updatedAt: DateTime.parse('2022-10-05 13:20:00'),
        photoURL: 'lib/assets/images/tomyum.jpg',
      ),
      Item(
        name: 'BentoBenjai',
        price: const Price(
          amount: 300,
          compareAtPrice: 500,
          currency: Currency.jpy,
        ),
        addedBy: 'atomicativesjai',
        createdAt: DateTime.parse('2022-10-05 13:20:00'),
        updatedAt: DateTime.parse('2022-10-05 13:20:00'),
        photoURL: 'lib/assets/images/tomyum.jpg',
      ),
    ];

    List<ItemCard> itemCards = [];

    for (int i = 0; i < items.length; i++) {
      Item item = items[i];
      ItemCard itemCard = ItemCard(item: item);
      itemCards.add(itemCard);
    }

    return StreamBuilder<DocumentSnapshot<Store>>(
        stream: _storeStream,
        builder: (context, snapshot) {
          final store = snapshot.data?.data();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(children: itemCards),
          );
        });
  }
}
