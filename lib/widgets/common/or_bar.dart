import 'package:flutter/material.dart';

class OrBar extends StatelessWidget {
  const OrBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
        child: Container(
            margin: const EdgeInsets.only(left: 10.0, right: 20.0),
            child: const Divider(
              height: 36,
            )),
      ),
      const Text('OR'),
      Expanded(
        child: Container(
            margin: const EdgeInsets.only(left: 20.0, right: 10.0),
            child: const Divider(
              height: 36,
            )),
      ),
    ]);
  }
}
