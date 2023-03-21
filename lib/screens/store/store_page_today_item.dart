import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/widgets/item/add_item_dialog.dart';
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

class RefreshedButton extends StatefulWidget {
  final void Function(bool) onRefreshed;
  final String storeId;

  const RefreshedButton(
      {Key? key, required this.storeId, required this.onRefreshed})
      : super(key: key);

  @override
  State<RefreshedButton> createState() => _RefreshedButtonState();
}

class _RefreshedButtonState extends State<RefreshedButton> {
  bool _refresh = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: IconButton(
        onPressed: () {
          _refresh = !_refresh;

          widget.onRefreshed(_refresh);
        },
        icon: const Icon(Icons.refresh),
      ),
    );
  }
}
