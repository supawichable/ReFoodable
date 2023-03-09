import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/item/_item.dart';
import 'package:gdsctokyo/widgets/big_text_bold.dart';

class ItemCard extends StatefulWidget {
  final String storeId;
  final Item item;
  // final User user;
  const ItemCard({
    Key? key,
    required this.storeId,
    required this.item,
    // required this.user,
  }) : super(key: key);

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  // Deconstructing the item
  late final item = widget.item;
  // late final user = widget.user;
  late final String id = item.id!;
  late final String name = item.name!;
  late final Price price = item.price!;
  late final String addedBy = item.addedBy!;
  late final DateTime createdAt = item.createdAt!;
  late final DateTime updatedAt = item.updatedAt!;
  late final String? photoURL = item.photoURL;

  @override
  Widget build(BuildContext context) {
    String timeString = createdAt.toLocal().toString().substring(11, 16);
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
                          Text(
                            price.compareAtPrice.toString(),
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontFamily: 'Poppins',
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            price.amount.toString(),
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
                      // SizedBox(
                      //   width: 240,
                      //   child: Text.rich(
                      //     maxLines: 1,
                      //     TextSpan(
                      //       text: 'Added by $addedBy at $timeString',
                      //       style: TextStyle(
                      //       color: Theme.of(context).colorScheme.outline,
                      //       fontFamily: 'Poppins',
                      //       fontSize: 12,
                      //       fontStyle: FontStyle.italic,
                      //     ),
                      //       children: [
                      //         if ('Added by $addedBy at $timeString'.length > 20) // Limit the text to 50 characters
                      //           TextSpan(
                      //             text: '...',
                      //             style: TextStyle(
                      //               color: Theme.of(context).colorScheme.outline,
                      //               fontFamily: 'Poppins',
                      //               fontSize: 12,
                      //               fontStyle: FontStyle.italic,
                      //             ),
                      //           ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        width: 240,
                        child: Text(
                          'Added by $addedBy at $timeString',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.outline,
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 30,
                        child: TextButton(
                          onPressed: () {
                            final User? user =
                                FirebaseAuth.instance.currentUser; 
                            if (user == null) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0)),
                                    actionsPadding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 10),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    titlePadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    title: const Text('Warning!'),
                                    content: const Text(
                                        'please login to perform this action'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('close'))
                                    ],
                                  );
                                },
                              );
                            } else {
                              final String userId = user.uid;
                            if (userId == addedBy) {
                              FirebaseFirestore.instance.stores
                                  .doc(widget.storeId)
                                  .items
                                  .doc(id)
                                  .delete();
                            }
                            if (userId != addedBy) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0)),
                                    actionsPadding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 10),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    titlePadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    title: const Text('Warning!'),
                                    content: const Text(
                                        'you can only delete cards you created'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('close'))
                                    ],
                                  );
                                },
                              );
                            }
                            }
                            
                          },
                          child: Text(
                            'Delete',
                            maxLines: 1, // making sure overflow works propperly
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.outline,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(
                4,
              ),
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(photoURL ?? 'lib/assets/images/tomyum.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
