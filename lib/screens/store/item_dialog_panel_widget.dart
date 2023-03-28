import 'package:flutter/material.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/providers/item_in_context.dart';
import 'package:gdsctokyo/widgets/item/add_item_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemDialogPanelWidget extends StatefulHookConsumerWidget {
  const ItemDialogPanelWidget({super.key});

  @override
  ConsumerState<ItemDialogPanelWidget> createState() =>
      _ItemDialogPanelWidgetState();
}

class _ItemDialogPanelWidgetState extends ConsumerState<ItemDialogPanelWidget> {
  Future<T> editDialog<T>() async {
    final snapshot = ref.read(itemInContextProvider)!;
    final storeId = snapshot.reference.parent.parent!.id;
    ref.read(itemInContextProvider.notifier).update((state) => null);
    return await showDialog(
        context: context,
        builder: (context) => AddItemDialog(
              storeId: storeId,
              itemId: snapshot.id,
              bucket: snapshot.reference.parent.id == ApiPath.myItems
                  ? ItemBucket.my
                  : ItemBucket.today,
            ));
  }

  Future<T> addToMyItem<T>() async {
    final snapshot = ref.read(itemInContextProvider)!;
    final storeId = snapshot.reference.parent.parent!.id;
    ref.read(itemInContextProvider.notifier).update((state) => null);
    return await showDialog(
        context: context,
        builder: (context) => AddItemDialog(
              storeId: storeId,
              itemId: snapshot.id,
              bucket: ItemBucket.my2today,
            ));
  }

  Future<void> deleteDialog() async {
    final snapshot = ref.read(itemInContextProvider)!;
    final storeId = snapshot.reference.parent.parent!.id;
    final willDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Are you sure you want to delete this item?'),
            const SizedBox(height: 8),
            Text(
              '${snapshot.data()!.name}',
              style: Theme.of(context).textTheme.headlineSmall?.apply(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeightDelta: 2,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (willDelete == true) {
      ref.read(itemInContextProvider.notifier).update((state) => null);
      await snapshot.reference.delete();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item deleted'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(itemInContextProvider);
    return Column(
      children: [
        TextButton(
          onPressed: () => editDialog(),
          child: const Text('Edit'),
        ),
        if (snapshot?.reference.parent.id == ApiPath.myItems)
          TextButton(
            onPressed: () => addToMyItem(),
            child: const Text('Add to Today\'s Items'),
          ),
        TextButton(
          onPressed: () => deleteDialog(),
          child: Text('Delete "${snapshot?.data()?.name}"'),
        ),
      ],
    );
  }
}
