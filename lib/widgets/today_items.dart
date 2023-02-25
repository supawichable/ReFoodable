import 'package:flutter/material.dart';
import 'package:gdsctokyo/widgets/item.dart';

class TodayItems extends StatefulWidget {
  const TodayItems({
    Key? key,
  }) : super(key: key);

  @override
  State<TodayItems> createState() => _TodayItemsState();
}

class _TodayItemsState extends State<TodayItems> {
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
          Column(
            children: [
              const Item(
                name: 'BentoBenjai',
                compareAtPrice: 500,
                amount: 300,
                photoURL: 'lib/assets/images/tomyum.jpg',
                addedBy: 'atomicativesjai',
                createdAt: '2022-10-05 13:20:00',
              ),
              const Item(
                name: 'BentoJa',
                compareAtPrice: 500,
                amount: 200,
                photoURL: 'lib/assets/images/tomyum.jpg',
                addedBy: 'atomicativesjai',
                createdAt: '2022-10-05 13:20:00',
              ),
              const Item(
                name: 'BentoBenjai',
                compareAtPrice: 500,
                amount: 300,
                photoURL: 'lib/assets/images/tomyum.jpg',
                addedBy: 'atomicativesjai',
                createdAt: '2022-10-05 16:20:00',
              ),
              Container(
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
            ],
          ),
        ],
      ),
    );
  }
}
