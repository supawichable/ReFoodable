import 'package:flutter/material.dart';
import 'package:gdsctokyo/models/menu/_menu.dart';
import 'package:gdsctokyo/widgets/big_text_bold.dart';

class ItemCard extends StatefulWidget {
  final Item item;
  const ItemCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    // Deconstructing the item
    final String name = widget.item.name;
    final Price price = widget.item.price;
    final String addedBy = widget.item.addedBy;
    final DateTime createdAt = widget.item.createdAt;
    final DateTime updatedAt = widget.item.updatedAt;
    final String? photoURL = widget.item.photoURL;

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
          Container(
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
                    Text(
                      'Added by $addedBy at $timeString',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {},
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
                    )
                  ],
                ),
              ],
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
                image: AssetImage(photoURL ?? 'lib/assets/images/tomyum.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
