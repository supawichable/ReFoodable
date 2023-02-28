import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/models/item/_item.dart';
import 'package:gdsctokyo/theme/color_schemes.dart';
import 'package:gdsctokyo/widgets/big_text.dart';
import 'package:gdsctokyo/widgets/description_text.dart';
import 'package:gdsctokyo/widgets/text_field_with_description.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

class PopUpComponent extends StatefulWidget {
  const PopUpComponent({Key? key}) : super(key: key);

  @override
  _PopUpComponentState createState() => _PopUpComponentState();
}

class _PopUpComponentState extends State<PopUpComponent> {
  bool _isPopupOpen = false;

  final _controllerMenuName = TextEditingController();
  final _controllerNormalPrice = TextEditingController();
  final _controllerDiscountedPrice = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 100,
          left: 10,
          right: 10,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: _isPopupOpen ? 5.0 : 0.0,
              sigmaY: _isPopupOpen ? 5.0 : 0.0,
            ),
            child: Container(
              width: _isPopupOpen ? 380.0 : 0.0,
              height: _isPopupOpen ? 300.0 : 0.0,
              decoration: _isPopupOpen
                  ? BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400.withOpacity(0.5),
                        blurRadius: 4,
                        spreadRadius: 2,
                        offset: Offset(0, 3),
                      )
                    ])
                  : null,
              child: Column(
                children: [
                  Container(
                    width: 400,
                    height: 50,
                    color: lightColorScheme.onInverseSurface,
                    child: Center(
                      child: BigText(
                        text: 'Add to my list',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                    ),
                    child: Container(
                      child: TextField(
                        controller: _controllerMenuName,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'menu name',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: 5,
                      left: 10,
                      right: 10,
                    ),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Container(
                              child: TextField(
                                controller: _controllerNormalPrice,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'normal price',
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: TextField(
                              controller: _controllerDiscountedPrice,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'discounted price',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: 5,
                      left: 10,
                      right: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DescriptionText(text: 'Image'),
                        SizedBox(
                          height: 10,
                        ),
                        Flex(
                          direction: Axis.horizontal,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                alignment: Alignment.center,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: lightColorScheme.onInverseSurface,
                                ),
                                child: DescriptionText(
                                  text: 'Upload image',
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.center,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: lightColorScheme.onInverseSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Button
        _isPopupOpen
            ? Positioned(
                bottom: 16.0,
                right: 16.0,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isPopupOpen = !_isPopupOpen;
                        });
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30.0,
                        child: Icon(
                          Icons.close,
                          color: Colors.red[300],
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    InkWell(
                      onTap: () {
                        final menuName = _controllerMenuName;
                        final normalPrice = _controllerNormalPrice;
                        final discountedPrice = _controllerDiscountedPrice;

                        createItem(
                          discountedPrice: discountedPrice,
                          menuName: menuName,
                          normalPrice: normalPrice,
                        );

                        setState(() {
                          _isPopupOpen = !_isPopupOpen;
                        });
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.red[300],
                        radius: 30.0,
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Positioned(
                bottom: 16.0,
                right: 16.0,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isPopupOpen = !_isPopupOpen;
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.red[300],
                    radius: 30.0,
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}

Future createItem(
    {required menuName, required normalPrice, required discountedPrice}) async {
  final item = Item(
    name: menuName,
    price: Price(
      amount: normalPrice,
      compareAtPrice: discountedPrice,
      currency: Currency.jpy,
    ),
    addedBy: 'user',
  );

  final itemJson = item.toJson();

  final newItem = FirebaseFirestore.instance.collection('item').doc();

  await newItem.set(itemJson);
}
