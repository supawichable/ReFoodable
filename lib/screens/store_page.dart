import 'package:flutter/material.dart';
import 'package:gdsctokyo/assets/data/food_list.dart';
import 'package:gdsctokyo/models/store/_store.dart';
import 'package:gdsctokyo/widgets/big_text_bold.dart';
import 'package:gdsctokyo/widgets/icon_text.dart';
import 'package:gdsctokyo/widgets/pop_up_component.dart';

class StorePage extends StatelessWidget {
  final Store store;

  const StorePage({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(store.name),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                Image(
                  image: const AssetImage('lib/assets/images/tomyum.jpg'),
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                const Positioned(
                    left: 10,
                    bottom: 3,
                    child: BigBoldText(
                      text: 'My Basket Himonya',
                      color: Colors.white,
                      size: 24,
                    ))
              ],
            ),
          ),
          SizedBox(
            height: 75,
            child: Container(
              margin: const EdgeInsets.only(
                top: 15,
                left: 15,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            bottom: 8,
                          ),
                          child: IconText(
                              iconType: Icons.location_pin,
                              iconColor: Colors.red[300],
                              text: '500m from here'),
                        ),
                        IconText(
                            iconType: Icons.bento,
                            iconColor: Colors.red[300],
                            text: 'bento'),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: 8,
                        ),
                        child: IconText(
                            iconType: Icons.schedule,
                            iconColor: Colors.red[300],
                            text: '11:00 - 23:00'),
                      ),
                      IconText(
                          iconType: Icons.discount,
                          iconColor: Colors.red[300],
                          text: '40% - 80% discount'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ...menuList,
        ],
      ),
    );
  }
}
