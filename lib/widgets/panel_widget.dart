import 'package:flutter/material.dart';
import 'package:gdsctokyo/widgets/big_text_bold.dart';
import 'package:gdsctokyo/widgets/description_text.dart';

class PanelWidget extends StatelessWidget {
  final ScrollController controller;

  const PanelWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        controller: controller,
        children: List<Widget>.generate(
          10,
          (index) => Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              height: 130,
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
                      left: 10,
                      right: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.only(
                              top: 10,
                            ),
                            child: BigBoldText(text: 'Restuarant Name')),
                        Container(
                          margin: EdgeInsets.only(
                            top: 15,
                          ),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  right: 10,
                                ),
                                child: Icon(
                                  Icons.location_pin,
                                  size: 15,
                                ),
                              ),
                              DescriptionText(text: '500m from here')
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 2),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  right: 10,
                                ),
                                child: Icon(
                                  Icons.bento,
                                  size: 15,
                                ),
                              ),
                              DescriptionText(text: 'Bento (food Type)')
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 20,
                          ),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  right: 10,
                                ),
                                child: Icon(
                                  Icons.discount,
                                  size: 15,
                                ),
                              ),
                              DescriptionText(text: '40% - 80% Discounted')
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          right: 20,
                        ),
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('lib/assets/images/tomyum.jpg'),
                          fit: BoxFit.cover,
                        )),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 10,
                          right: 20,
                        ),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                right: 10,
                              ),
                              child: Icon(
                                Icons.schedule,
                                size: 15,
                              ),
                            ),
                            DescriptionText(text: 'closes 23:00')
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
