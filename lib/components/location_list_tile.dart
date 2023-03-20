import 'package:flutter/material.dart';

class LocationListTile extends StatelessWidget {
  const LocationListTile(
      {Key? key, required this.location, required this.press})
      : super(key: key);

  final String location;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          child: ListTile(
              tileColor: Colors.white,
              onTap: press,
              horizontalTitleGap: 0,
              title: Text(
                location,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )),
        ),
        const Divider(
          height: 0,
          thickness: 1,
          color: Color(0xFFF8F8F8),
        )
      ],
    );
  }
}
