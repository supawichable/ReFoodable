import 'package:flutter/material.dart';
import 'package:gdsctokyo/widgets/big_text_bold.dart';
import 'package:gdsctokyo/widgets/description_text.dart';
import 'package:gdsctokyo/widgets/item.dart';

class MyItems extends StatefulWidget {
  const MyItems({
    Key? key,
  }) : super(key: key);

  @override
  State<MyItems> createState() => _MyItemsState();
}

class _MyItemsState extends State<MyItems> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 10,
        left: 10,
        bottom: 10,
      ),
      child: Column(
        children: [
          Container(
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    'My Items',
                    maxLines: 1, // making sure overflow works propperly
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
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
          ),
          Column(
            children: [
              Item(
                menuName: "BentoBenjai",
                normalPrice: 500,
                discountedPrice: 300,
                imageLocation: 'lib/assets/images/tomyum.jpg',
                addedName: "atomicativesjai",
                addedTime: "2022-10-05 13:20:00",
              ),
              Item(
                menuName: "BentoJa",
                normalPrice: 500,
                discountedPrice: 200,
                imageLocation: 'lib/assets/images/tomyum.jpg',
                addedName: "atomicativesjai",
                addedTime: "2022-10-05 13:20:00",
              ),
              Item(
                menuName: "BentoBenjai",
                normalPrice: 500,
                discountedPrice: 300,
                imageLocation: 'lib/assets/images/tomyum.jpg',
                addedName: "atomicativesjai",
                addedTime: "2022-10-05 13:20:00",
              ),
              Container(
                height: 24,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 3),
                  )
                ]),
                child: Icon(
                  Icons.more_horiz,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
