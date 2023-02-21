import 'package:flutter/material.dart';
import 'package:gdsctokyo/widgets/big_text_bold.dart';
import 'package:gdsctokyo/widgets/description_text.dart';

class StoreInfo extends StatefulWidget {
  const StoreInfo({
    Key? key,
  }) : super(key: key);

  @override
  State<StoreInfo> createState() => _StoreInfoState();
}

class _StoreInfoState extends State<StoreInfo> {
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
          SizedBox(
            height: 12,
          ),
          Container(
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    'Store Info',
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
          Container(
            // height: 130,
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 3),
              )
            ]),
            child: Container(
              margin: EdgeInsets.only(
                bottom: 18,
                left: 16,
                right: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                            size: 20,
                          ),
                        ),
                        DescriptionText(size: 16, text: '東京都目黒区大岡山')
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            right: 10,
                          ),
                          child: Icon(
                            Icons.bento,
                            size: 20,
                          ),
                        ),
                        DescriptionText(size: 16, text: 'Bento')
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            right: 10,
                          ),
                          child: Icon(
                            Icons.schedule,
                            size: 20,
                          ),
                        ),
                        DescriptionText(size: 16, text: '11:00-23:00')
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            right: 10,
                          ),
                          child: Icon(
                            Icons.person,
                            size: 20,
                          ),
                        ),
                        DescriptionText(size: 16, text: 'Natpawee')
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            right: 10,
                          ),
                          child: Icon(
                            Icons.email,
                            size: 20,
                          ),
                        ),
                        DescriptionText(
                            size: 16, text: 'tonklalor2544@gmail.com')
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            right: 10,
                          ),
                          child: Icon(
                            Icons.call,
                            size: 20,
                          ),
                        ),
                        DescriptionText(size: 16, text: '07013432321')
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
