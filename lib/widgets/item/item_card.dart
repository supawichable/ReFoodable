// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/item/_item.dart';
import 'package:gdsctokyo/providers/item_in_context.dart';
import 'package:gdsctokyo/widgets/item/buy_item_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ItemCard extends HookConsumerWidget {
  final DocumentSnapshot<Item> snapshot;
  final PanelController? panelController;
  // final User user;
  const ItemCard({
    Key? key,
    required this.snapshot,
    this.panelController,
    // required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late final item = snapshot.data()!;
    late final storeId = snapshot.reference.parent.parent!.id;
    late final String name = item.name ?? '(Untitled)';
    late final Price? price = item.price;
    late final String? addedBy = item.addedBy;
    late final Future<String?> addedByName = FirebaseFirestore.instance.users
        .doc(addedBy)
        .get()
        .then((value) => value.data()?.displayName);
    late final DateTime? createdAt = item.createdAt;
    late final DateTime? updatedAt = item.updatedAt;
    late final String? photoURL = item.photoURL;

    late String? timeString = createdAt?.toLocal().toString().substring(11, 16);

    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
              onTap: () {
                ref
                    .read(itemInContextProvider.notifier)
                    .update((state) => snapshot);
              },
              child: const Padding(
                padding: EdgeInsets.fromLTRB(4, 8, 4, 0),
                child: Icon(
                  Icons.more_vert,
                  size: 16,
                ),
              )),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 4),
                _Title(name: name),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (price?.compareAtPrice != null) ...[
                      if (price?.amount != null)
                        Image.asset('lib/assets/images/Sale.png',
                            height: 16, width: 16),
                      const SizedBox(width: 4),
                      if (snapshot.reference.parent.id == ApiPath.myItems)
                        Text(
                          '${price?.currency.symbol ?? ''}${price?.compareAtPrice ?? '...'}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                        )
                      else if (price?.compareAtPrice != null)
                        Text(
                          '${price?.currency.symbol ?? ''}${price?.compareAtPrice ?? '...'}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: Theme.of(context).colorScheme.error),
                        ),
                      const SizedBox(width: 4),
                    ],
                    snapshot.reference.parent.id == ApiPath.myItems
                        ? const SizedBox.shrink()
                        : Text(
                            '${price?.currency.symbol ?? ''}${price?.amount ?? ''}',
                            style: Theme.of(context).textTheme.bodySmall?.apply(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeightDelta: 2),
                          )
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // at $timeString
                    Text('Added at $timeString',
                        style: Theme.of(context).textTheme.bodySmall?.apply(
                              color: Theme.of(context).colorScheme.onSurface,
                            )),
                    snapshot.reference.parent.id == ApiPath.myItems
                        ? const SizedBox.shrink()
                        : Container(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () => {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return BuyItemDialog(item: item);
                                    }),
                              },
                              child: Text('Buy this',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.apply(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      )),
                            ),
                          )
                  ],
                ),
              ],
            ),
          ),
          // use food unsplash placeholder image if no image is available
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                  photoURL ?? 'https://source.unsplash.com/featured/?food',
                  height: 90,
                  width: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                // try refetching the image
                final itemPhotoRef = FirebaseStorage.instance.ref().child(
                    'stores/$storeId/todays_items/${snapshot.id}/item_photo.jpg');
                itemPhotoRef.getDownloadURL().then((itemPhotoUrl) async {
                  await snapshot.reference
                      .update({'photo_u_r_l': itemPhotoUrl});
                });
                return Image.asset(
                  'lib/assets/images/tomyum.jpg',
                  height: 90,
                  width: 90,
                  fit: BoxFit.cover,
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}

class _Title extends HookConsumerWidget {
  const _Title({required this.name});

  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(name,
        style: Theme.of(context).textTheme.headlineSmall?.apply(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeightDelta: 2,
            ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1);
  }
}
