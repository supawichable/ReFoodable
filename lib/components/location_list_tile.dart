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
              tileColor: Theme.of(context).colorScheme.surface,
              onTap: press,
              horizontalTitleGap: 0,
              title: Text(
                location,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )),
        ),
        Divider(
          height: 0,
          thickness: 1,
          color: Theme.of(context).dividerColor,
        )
      ],
    );
  }
}
