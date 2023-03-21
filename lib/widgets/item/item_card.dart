import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/item/_item.dart';
import 'package:gdsctokyo/widgets/item/add_item_dialog.dart';
import 'package:gdsctokyo/widgets/store_page/item_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ItemCard extends StatelessWidget {
  final DocumentSnapshot<Item> snapshot;
  // final User user;
  const ItemCard({
    Key? key,
    required this.snapshot,
    // required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final item = snapshot.data()!;
    late final storeId = snapshot.reference.parent.parent!.id;
    late final String name = item.name!;
    late final Price price = item.price!;
    late final String addedBy = item.addedBy!;
    late final Future<String?> addedByName = FirebaseFirestore.instance.users
        .doc(addedBy)
        .get()
        .then((value) => value.data()?.displayName);
    late final DateTime? createdAt = item.createdAt;
    late final DateTime? updatedAt = item.updatedAt;
    late final String? photoURL = item.photoURL;

    late String? timeString = createdAt?.toLocal().toString().substring(11, 16);

    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => AddItemDialog(
                  storeId: storeId,
                  itemId: snapshot.id,
                  bucket: snapshot.reference.parent.id == ApiPath.myItems
                      ? ItemBucket.my
                      : ItemBucket.today,
                ));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.25),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 3),
              )
            ]),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Title(name: name),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (price.compareAtPrice != null) ...[
                          Image.asset('lib/assets/images/Sale.png',
                              height: 16, width: 16),
                          const SizedBox(width: 4),
                          snapshot.reference.parent.id == ApiPath.myItems
                              ? Text(
                                  '${price.currency.symbol}${price.compareAtPrice}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground),
                                )
                              : Text(
                                  '${price.currency.symbol}${price.compareAtPrice}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error),
                                ),
                          const SizedBox(width: 4),
                        ],
                        snapshot.reference.parent.id == ApiPath.myItems
                            ? const SizedBox.shrink()
                            : Text(
                                '${price.currency.symbol}${price.amount}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.apply(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontWeightDelta: 2),
                              )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        snapshot.reference.parent.id == ApiPath.myItems
                            ? GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AddItemDialog(
                                            storeId: storeId,
                                            itemId: snapshot.id,
                                            bucket: ItemBucket.my2today,
                                          ));
                                },
                                child: Text('Add to Today\'s Item',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.apply(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        )),
                              )
                            : FutureBuilder(
                                future: addedByName,
                                builder: (BuildContext context, snapshot) {
                                  return Text.rich(
                                    TextSpan(
                                      text: 'Added by ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.apply(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                      children: [
                                        TextSpan(
                                          text: snapshot.data ?? 'Unknown',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.apply(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                                fontWeightDelta: 2,
                                              ),
                                        ),
                                        TextSpan(
                                          text: ' at $timeString',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.apply(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                              ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                        GestureDetector(
                          onTap: () async {
                            final willDelete = await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Item'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                        'Are you sure you want to delete this item?'),
                                    const SizedBox(height: 8),
                                    Text(
                                      name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.apply(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontWeightDelta: 2,
                                          ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                            if (willDelete == true) {
                              await snapshot.reference.delete();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Item deleted'),
                                  ),
                                );
                              }
                            }
                          },
                          child: Text('Delete',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.apply(
                                    color: Theme.of(context).colorScheme.error,
                                  )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (photoURL != null)
              Image.network(
                photoURL,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              )
            else
              Image.asset(
                'lib/assets/images/tomyum.jpg',
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
          ],
        ),
      ),
    );
  }
}

class _Title extends HookConsumerWidget {
  const _Title({required this.name});

  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchedName = ref.watch(searchTextProvider);
    final regExp = RegExp(searchedName, caseSensitive: false);
    final matchedPart = regExp.firstMatch(name)?.group(0);
    // highlight the matched part by setting background color

    return Text.rich(
      TextSpan(
        text: name.substring(0, regExp.firstMatch(name)!.start),
        style: Theme.of(context).textTheme.headlineSmall?.apply(
              color: Theme.of(context).colorScheme.onSurface,
            ),
        children: [
          TextSpan(
            text: matchedPart,
            style: Theme.of(context).textTheme.headlineSmall?.apply(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  color: Theme.of(context).colorScheme.onSecondary,
                  fontWeightDelta: 2,
                ),
          ),
          TextSpan(
            text: name.substring(regExp.firstMatch(name)!.end),
            style: Theme.of(context).textTheme.headlineSmall?.apply(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeightDelta: 2,
                ),
          ),
        ],
      ),
    );
  }
}