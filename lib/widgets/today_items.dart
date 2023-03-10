import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/item/_item.dart';
import 'package:gdsctokyo/routes/router.gr.dart';
import 'package:gdsctokyo/widgets/item_card.dart';
import 'package:gdsctokyo/screens/store_page_my_item.dart';
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
    return Padding(
      padding: const EdgeInsets.only(
        right: 10,
        left: 10,
        bottom: 10,
      ),
      child: Column(
        children: [
          Row(
            // crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Today Items',
                maxLines: 1, // making sure overflow works propperly
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                ),
              ),
              TextButton(
                onPressed: () {
                  context.pushRoute(StoreTodayItemRoute(
                    storeId: widget.storeId,
                  ));
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size.zero),
                  visualDensity: VisualDensity.compact,
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.zero),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                ),
                child: Text(
                  'edit',
                  maxLines: 1, // making sure overflow works propperly
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
              )
            ],
          ),
          Column(
            children: [
              StreamBuilder(
                stream: top3Items,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Item>> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return Column(
                    children: snapshot.data!.docs
                        .map((DocumentSnapshot<Item> snapshot) {
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
                  // Navigate to the new page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StoreTodayItemPage(
                              storeId: widget.storeId,
                            )),
                  );
                },
                child: Container(
                  height: 24,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
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
          ),
        ],
      ),
    );
  }
}
