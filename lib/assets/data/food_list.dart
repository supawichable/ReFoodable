import 'package:flutter/material.dart';
import 'package:gdsctokyo/widgets/big_text_semibold.dart';
import 'package:gdsctokyo/widgets/description_text.dart';
import 'package:gdsctokyo/widgets/icon_text.dart';
export 'food_list.dart';

List<Widget> menuList = List<Widget>.generate(
  10,
  (index) => Container(
    margin: const EdgeInsets.only(
      left: 20,
      right: 20,
    ),
    alignment: Alignment.center,
    height: 100,
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
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
            top: 5,
            bottom: 5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const BigSemiboldText(text: 'Bento'),
              IconText(
                iconType: Icons.discount,
                iconColor: Colors.red[300],
                text: '500',
              ),
              const DescriptionText(
                text: 'Added by atomicative at 20:00 pm',
                color: Colors.grey,
                size: 12,
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
            right: 5,
          ),
          width: 90,
          height: 90,
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('lib/assets/images/tomyum.jpg'),
            fit: BoxFit.cover,
          )),
        ),
      ],
    ),
  ),
);
