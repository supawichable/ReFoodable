import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/theme/color_schemes.g.dart';
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

  String _menuName = '';
  String _normalPrice = '';
  String _discountedPrice = '';

  Future<void> writeToJSONFile(String data) async {
    final file = File('food_detail.json');
    final jsonString = json.decode(data);
    file.writeAsStringSync(jsonString);
  }

  void _setMenuName(String menuName) {
    setState(() {
      _menuName = menuName;
    });
  }

  void _setnormalPrice(String normalPrice) {
    setState(() {
      _normalPrice = normalPrice;
    });
  }

  void _setdiscountedPrice(String discountedPrice) {
    setState(() {
      _discountedPrice = discountedPrice;
    });
  }

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
                    child: TextFieldWithDescription(
                      descriptionText: 'Menu name',
                      placeHolderText: 'Yakisoba',
                      function: _setMenuName,
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
                            child: TextFieldWithDescription(
                              descriptionText: 'Normal price',
                              placeHolderText: 'normal price',
                              function: _setnormalPrice,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: TextFieldWithDescription(
                              descriptionText: 'Discounted price',
                              placeHolderText: 'discounted price',
                              function: _setdiscountedPrice,
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
                      onTap: () async {
                        final data = "{'menuName': $_menuName,'normalPrice': $_normalPrice,'discountedPrice': $_discountedPrice,}";
                        await writeToJSONFile(data);

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
