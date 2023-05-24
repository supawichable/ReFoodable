import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/providers/item_in_context.dart';
import 'package:gdsctokyo/screens/store/store_page.dart';
import 'package:gdsctokyo/widgets/item/add_item_dialog.dart';
import 'package:gdsctokyo/widgets/store_page/item_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

final _pc = PanelController();

@RoutePage()
class StoreMyItemPage extends HookConsumerWidget {
  final String storeId;

  const StoreMyItemPage(
      {super.key, @PathParam('storeId') required this.storeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(itemInContextProvider, (prev, next) {
      if (next != null) {
        _pc.open();
      } else {
        _pc.close();
      }
    });
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
      body: Stack(
        children: [
          StreamedItemList(
              itemBucket:
                  FirebaseFirestore.instance.stores.doc(storeId).myItems),
          ItemMorePanel(pc: _pc)
        ],
      ),
    );
  }
}
