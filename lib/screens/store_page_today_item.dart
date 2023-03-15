import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';

import 'package:gdsctokyo/models/item/_item.dart';
import 'package:gdsctokyo/widgets/add_item_dialog.dart';
import 'package:gdsctokyo/widgets/item_card.dart';

class StoreTodayItemPage extends StatelessWidget {
  final String storeId;

  const StoreTodayItemPage(
      {super.key, @PathParam('storeId') required this.storeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
            context: context,
            builder: (context) => AddItemDialog(
                  storeId: storeId,
                  bucket: ApiPath.todaysItems,
                )),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Today Items'),
        centerTitle: true,
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
            child: ListView(
                children: snapshot.data!.docs
                    .map((snapshot) => ItemCard(
                          key: ValueKey(snapshot.id),
                          snapshot: snapshot,
                        ))
                    .toList()),
          );
        });
  }
}
