import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/models/item/_item.dart';
import 'package:gdsctokyo/widgets/item_card.dart';

class StreamedItemList extends StatefulWidget {
  final Stream<QuerySnapshot<Item>> itemStream;

  const StreamedItemList({super.key, required this.itemStream});

  @override
  State<StreamedItemList> createState() => _StreamedItemListState();
}

class _StreamedItemListState extends State<StreamedItemList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.itemStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator();
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView(
                children: [
                  for (final item in snapshot.data!.docs)
                    ItemCard(key: ValueKey(item.id), snapshot: item)
                ],
              ),
            );
          }

          return const Center(
            child: Text('No items'),
          );
        });
    ;
  }
}
