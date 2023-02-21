import 'package:flutter/material.dart';
import 'package:gdsctokyo/widgets/big_text_bold.dart';
import 'package:gdsctokyo/assets/data/food_list.dart';
import 'package:gdsctokyo/widgets/icon_text.dart';
import 'package:gdsctokyo/widgets/list_header.dart';

class MyStorePage extends StatelessWidget {
  MyStorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
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
                Positioned(
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
          ListHeader(text: 'Store Info'),
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
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                margin: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 5,
                ),
                child: Container( 
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 10,
                    bottom: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconText(iconType: Icons.location_pin, iconColor: Colors.red[300], text: '東京都目黒区大岡山'),
                      IconText(iconType: Icons.bento,iconColor: Colors.red[300], text: 'Bento' ),
                      IconText(iconType: Icons.schedule,iconColor: Colors.red[300], text: '11:00 - 23:00' ),
                      IconText(iconType: Icons.person, iconColor: Colors.red[300],text: 'Tanaka Tarou' ),
                      IconText(iconType: Icons.mail, iconColor: Colors.red[300],text: 'tanaka.t@gmail.com' ),
                      IconText(iconType: Icons.phone , iconColor: Colors.red[300],text: '080-0000-0000' ),
                    ],
                  ),
                )),
          ),
          ListHeader(text: 'Menu Items'),
          ...menuList,
          Container(
            height: 20,
          )
        ],
      ),
    );
  }
}
