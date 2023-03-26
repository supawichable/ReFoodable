import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/widgets/common/icon_text.dart';

class PanelWidget extends StatelessWidget {
  final List storeLst;

  const PanelWidget({
    Key? key,
    required this.storeLst,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: List<Widget>.generate(
        storeLst.length,
        (index) => Padding(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
            top: 5,
            bottom: 5,
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              context.router.pushNamed('/store/${storeLst[index]["id"]}');
            },
            child: Container(
              height: 130,
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
                    margin: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(
                              top: 10,
                            ),
                            child: Text(storeLst[index]["data"]["name"])),
                        Container(
                          margin: const EdgeInsets.only(
                            top: 15,
                          ),
                          child: IconText(
                              icon: Icons.location_pin,
                              iconColor: Colors.red[300],
                              text: storeLst[index]["distance"] != null &&
                                      storeLst[index]["distance"].status == "OK"
                                  ? storeLst[index]["distance"].text +
                                      " from here"
                                  : "no detected route"),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 2),
                            child: IconText(
                                icon: Icons.bento,
                                iconColor: Colors.red[300],
                                text: storeLst[index]["data"]["category"]
                                    .join(", "))),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          right: 20,
                        ),
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('lib/assets/images/tomyum.jpg'),
                          fit: BoxFit.cover,
                        )),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          top: 10,
                          right: 20,
                        ),
                        child: IconText(
                            icon: Icons.schedule,
                            iconColor: Colors.red[300],
                            text: 'close 23:00'),
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
