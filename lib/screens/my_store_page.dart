import 'package:flutter/material.dart';
import 'package:gdsctokyo/models/store/_store.dart';
import 'package:gdsctokyo/widgets/big_text_bold.dart';
import 'package:gdsctokyo/assets/data/food_list.dart';
import 'package:gdsctokyo/widgets/icon_text.dart';
import 'package:gdsctokyo/widgets/list_header.dart';

class MyStorePage extends StatelessWidget {
  final Store store;

  const MyStorePage({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Flexible(
        child: ListView(
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
            const ListHeader(text: 'Store Info'),
            SizedBox(
              height: 200,
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 5,
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 10,
                      bottom: 10,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconText(
                            icon: Icons.location_pin,
                            iconColor: Colors.red[300],
                            text: '東京都目黒区大岡山'),
                        IconText(
                            icon: Icons.bento,
                            iconColor: Colors.red[300],
                            text: 'Bento'),
                        IconText(
                            icon: Icons.schedule,
                            iconColor: Colors.red[300],
                            text: '11:00 - 23:00'),
                        IconText(
                            icon: Icons.person,
                            iconColor: Colors.red[300],
                            text: 'Tanaka Tarou'),
                        IconText(
                            icon: Icons.mail,
                            iconColor: Colors.red[300],
                            text: 'tanaka.t@gmail.com'),
                        IconText(
                            icon: Icons.phone,
                            iconColor: Colors.red[300],
                            text: '080-0000-0000'),
                      ],
                    ),
                  )),
            ),
            const ListHeader(text: 'Menu Items'),
            ...menuList,
            Container(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
