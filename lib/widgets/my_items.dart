import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/models/item/_item.dart';
import 'package:gdsctokyo/routes/router.gr.dart';
import 'package:gdsctokyo/widgets/item_card.dart';
import 'package:gdsctokyo/screens/store_page_my_item.dart';

import '../screens/store_page_my_item.dart';
import 'package:gdsctokyo/screens/store_page_today_item.dart';

class MyItems extends StatefulWidget {
  const MyItems({
    Key? key,
    required this.storeId,
  }) : super(key: key);

  final String storeId;
  @override
  State<MyItems> createState() => _MyItemsState();
}

class _MyItemsState extends State<MyItems> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'My Items',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.apply(fontWeightDelta: 2),
            ),
          ],
        ),
        const SizedBox(
          height: 12,
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
