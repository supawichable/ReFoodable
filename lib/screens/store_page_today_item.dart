import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/widgets/add_item_dialog.dart';
import 'package:gdsctokyo/widgets/store_page/item_list.dart';

class StoreTodayItemPage extends StatefulWidget {
  final String storeId;

  const StoreTodayItemPage(
      {Key? key, @PathParam('storeId') required this.storeId})
      : super(key: key);

  @override
  State<StoreTodayItemPage> createState() => _StoreTodayItemPageState();
}

class _StoreTodayItemPageState extends State<StoreTodayItemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
            context: context,
            builder: (context) => AddItemDialog(
                  storeId: widget.storeId,
                  bucket: ItemBucket.today,
                )),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Today's Items"),
        centerTitle: true,
      ),
      body: StreamedItemList(
          itemBucket: FirebaseFirestore.instance.stores
              .doc(widget.storeId)
              .todaysItems),
    );
  }
}
