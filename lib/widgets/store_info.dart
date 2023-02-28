import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.only(
        right: 10,
        left: 10,
        bottom: 10,
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          Row(
            // crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
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
          Container(
            // height: 130,
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 3),
              )
            ]),
            child: Container(
              margin: const EdgeInsets.only(
                bottom: 18,
                left: 16,
                right: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      top: 15,
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            right: 10,
                          ),
                          child: const Icon(
                            Icons.location_pin,
                            size: 20,
                          ),
                        ),
                        const DescriptionText(size: 16, text: '東京都目黒区大岡山')
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          right: 10,
                        ),
                        child: const Icon(
                          Icons.bento,
                          size: 20,
                        ),
                      ),
                      const DescriptionText(size: 16, text: 'Bento')
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          right: 10,
                        ),
                        child: const Icon(
                          Icons.schedule,
                          size: 20,
                        ),
                      ),
                      const DescriptionText(size: 16, text: '11:00-23:00')
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          right: 10,
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 20,
                        ),
                      ),
                      const DescriptionText(size: 16, text: 'Natpawee')
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          right: 10,
                        ),
                        child: const Icon(
                          Icons.email,
                          size: 20,
                        ),
                      ),
                      const DescriptionText(
                          size: 16, text: 'tonklalor2544@gmail.com')
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          right: 10,
                        ),
                        child: const Icon(
                          Icons.call,
                          size: 20,
                        ),
                      ),
                      const DescriptionText(size: 16, text: '07013432321')
                    ],
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
