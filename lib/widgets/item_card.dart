import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/item/_item.dart';
import 'package:gdsctokyo/util/logger.dart';
import 'package:gdsctokyo/widgets/big_text_bold.dart';

class ItemCard extends StatefulWidget {
  final DocumentSnapshot<Item> snapshot;
  // final User user;
  const ItemCard({
    Key? key,
    required this.snapshot,
    // required this.user,
  }) : super(key: key);

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  // Deconstructing the item
  late final item = widget.snapshot.data()!;
  late final storeId = widget.snapshot.reference.parent.parent!.id;
  late final String name = item.name!;
  late final Price price = item.price!;
  late final String addedBy = item.addedBy!;
  late final Future<String?> addedByName = FirebaseFirestore
      .instance.usersPublic
      .doc(addedBy)
      .get()
      .then((value) => value.data()?.displayName);
  late final DateTime? createdAt = item.createdAt;
  late final DateTime? updatedAt = item.updatedAt;
  late final String? photoURL = item.photoURL;

  late String? timeString = createdAt?.toLocal().toString().substring(11, 16);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 130,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 4,
          offset: const Offset(0, 3),
        )
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.only(
                left: 16,
                right: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BigBoldText(text: name, size: 20),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          right: 8,
                        ),
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('lib/assets/images/Sale.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          if (price.compareAtPrice != null) ...[
                            Text(
                              '${price.currency.symbol}${price.compareAtPrice}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                  ),
                            ),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            '${price.currency.symbol}${price.amount}',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      FutureBuilder(
                        future: addedByName,
                        builder: (BuildContext context, snapshot) {
                          return Text(
                            'Added by ${snapshot.data ?? '(Deleted User)'} at $timeString',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.outline,
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          widget.snapshot.reference.delete();
                        },
                        child: const Text('Delete'),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(
              4,
            ),
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(photoURL ?? 'lib/assets/images/tomyum.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
