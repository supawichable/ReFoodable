import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/routes/router.gr.dart';

class WidgetDebugCard extends StatelessWidget {
  const WidgetDebugCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.router.push(const MyStoresRoute());
      },
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: const [
            Icon(Icons.store, size: 48),
            SizedBox(width: 16),
            Text('Manage My Stores'),
            Spacer(),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      )),
    );
  }
}
