import 'package:flutter/material.dart';
import 'package:gdsctokyo/widgets/big_text_bold.dart';
import 'package:gdsctokyo/widgets/description_text.dart';

class Item extends StatefulWidget {
  final String menuName;
  final double normalPrice;
  final double discountedPrice;
  final String imageLocation;
  final String addedName;
  final String addedTime;

  const Item({
    Key? key,
    required this.menuName,
    required this.normalPrice,
    this.discountedPrice = 0,
    required this.imageLocation,
    required this.addedName,
    required this.addedTime,
  }) : super(key: key);

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    String timeString = widget.addedTime.substring(11, 16);
    return Container(
      // height: 130,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 4,
          offset: Offset(0, 3),
        )
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 16,
              right: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(child: BigBoldText(text: widget.menuName, size: 20)),
                SizedBox(height: 8),
                Container(
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          right: 8,
                        ),
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('lib/assets/images/Sale.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            widget.normalPrice.toInt().toString(),
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontFamily: 'Poppins',
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            widget.discountedPrice.toInt().toString(),
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  child: Row(
                    children: [
                      Text(
                        "Added by ${widget.addedName} at $timeString",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(width: 8),
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
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(
              4,
            ),
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.imageLocation),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
