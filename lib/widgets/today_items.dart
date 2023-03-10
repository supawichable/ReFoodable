import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/item/_item.dart';
import 'package:gdsctokyo/routes/router.gr.dart';
import 'package:gdsctokyo/widgets/item_card.dart';
import 'package:gdsctokyo/screens/store_page_today_item.dart';

class TodayItems extends StatefulWidget {
  const TodayItems({
    Key? key,
    required this.storeId,
  }) : super(key: key);

  final String storeId;
  @override
  State<TodayItems> createState() => _TodayItemsState();
}

class _TodayItemsState extends State<TodayItems> {
  late Stream<QuerySnapshot<Item>> top3Items = FirebaseFirestore.instance.stores
      .doc(widget.storeId)
      .todaysItems
      .orderBy('updated_at', descending: true)
      .limit(3)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text("Today's Items",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.apply(fontWeightDelta: 2)),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        StreamBuilder(
          stream: top3Items,
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Item>> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: LinearProgressIndicator(),
              );
            }

            return Column(
              children:
                  snapshot.data!.docs.map((DocumentSnapshot<Item> snapshot) {
                return ItemCard(
                  key: ValueKey(snapshot.id),
                  snapshot: snapshot,
                );
              }).toList(),
            );
          },
        ),
        GestureDetector(
          onTap: () {
            context.router.push(StoreTodayItemRoute(
              storeId: widget.storeId,
            ));
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 3),
                  )
                ]),
            child: const Icon(
              Icons.more_horiz,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}
