import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';

import 'package:gdsctokyo/models/item/_item.dart';
import 'package:gdsctokyo/widgets/item_card.dart';

class StoreTodayItemPage extends StatelessWidget {
  final String storeId;

  const StoreTodayItemPage(
      {super.key, @PathParam('storeId') required this.storeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today Items'),
        centerTitle: true,
        actions: [],
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          TodayItemsList(storeId: storeId),
        ],
      ),
    );
  }
}

class TodayItemsList extends StatefulWidget {
  final String storeId;

  const TodayItemsList({super.key, required this.storeId});

  @override
  State<TodayItemsList> createState() => _TodayItemsListState();
}

class _TodayItemsListState extends State<TodayItemsList> {
  late Stream<QuerySnapshot<Item>> _todaysStream;

  @override
  void initState() {
    super.initState();
    _todaysStream = FirebaseFirestore.instance.stores
        .doc(widget.storeId)
        .todaysItems
        .snapshots();
    final item = Item(
      name: 'BentoBenjai',
      price: const Price(
        amount: 300,
        compareAtPrice: 500,
        currency: Currency.jpy,
      ),
      addedBy: FirebaseAuth.instance.currentUser!.uid,
    );
    FirebaseFirestore.instance.stores.doc(widget.storeId).todaysItems.add(item);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _todaysStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator();
          }

          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final item = snapshot.data!.docs[index].data();
                return ItemCard(item: item);
              },
            ),
          );
        });
  }
}
