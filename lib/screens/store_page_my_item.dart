import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/item/_item.dart';
import 'package:gdsctokyo/widgets/add_item_dialog.dart';
import 'package:gdsctokyo/widgets/item_card.dart';

class StoreMyItemPage extends StatelessWidget {
  final String storeId;

  const StoreMyItemPage(
      {super.key, @PathParam('storeId') required this.storeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
            context: context,
            builder: (context) => AddItemDialog(
                  storeId: storeId,
                  bucket: ItemBucket.my,
                )),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('My Items'),
        centerTitle: true,
        actions: const [],
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          MyItem(storeId: storeId),
        ],
      ),
    );
  }
}

class MyItem extends StatefulWidget {
  final String storeId;

  const MyItem({super.key, required this.storeId});

  @override
  State<MyItem> createState() => _MyItemState();
}

class _MyItemState extends State<MyItem> {
  late Stream<QuerySnapshot<Item>> _storeStream;

  @override
  void initState() {
    super.initState();
    _storeStream = FirebaseFirestore.instance.stores
        .doc(widget.storeId)
        .myItems
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _storeStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator();
          }

          if (snapshot.hasData) {
            return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  children: snapshot.data!.docs
                      .map(
                        (snapshot) => ItemCard(snapshot: snapshot),
                      )
                      .toList(),
                ));
          }

          return const Center(
            child: Text('No items'),
          );
        });
  }
}
