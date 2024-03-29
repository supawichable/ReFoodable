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
class StoreTodayItemPage extends HookConsumerWidget {
  final String storeId;

  const StoreTodayItemPage(
      {Key? key, @PathParam('storeId') required this.storeId})
      : super(key: key);

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
                  bucket: ItemBucket.today,
                )),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Today's Items"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          StreamedItemList(
              itemBucket:
                  FirebaseFirestore.instance.stores.doc(storeId).todaysItems),
          ItemMorePanel(pc: _pc)
        ],
      ),
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
