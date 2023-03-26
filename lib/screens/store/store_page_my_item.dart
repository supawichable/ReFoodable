import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/widgets/item/add_item_dialog.dart';
import 'package:gdsctokyo/widgets/store_page/item_list.dart';

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
      body: StreamedItemList(
          itemBucket: FirebaseFirestore.instance.stores.doc(storeId).myItems),
    );
  }
}
