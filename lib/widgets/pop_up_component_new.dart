import 'dart:ffi';

import 'package:flutter/material.dart';

class NewPopUpComponent extends StatefulWidget {
  const NewPopUpComponent({super.key});
  

  @override
  State<NewPopUpComponent> createState() => NewPopUpComponentState();
}

class NewPopUpComponentState extends State<NewPopUpComponent> {
  late TextEditingController _controllerMenuName;
  late TextEditingController _controllerNormalPrice;
  late TextEditingController _controllerDiscountedPrice;

  String? menuName = '';
  String? normalPrice = '';
  String? discountedPrice = '';

  @override
  void initState() {
    super.initState();

    _controllerMenuName = TextEditingController();
    _controllerNormalPrice = TextEditingController();
    _controllerDiscountedPrice = TextEditingController();
  }

  @override
  void dispose() {
    _controllerMenuName.dispose();
    _controllerNormalPrice.dispose();
    _controllerDiscountedPrice.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Text(menuName!),
          Text(normalPrice!),
          Text(discountedPrice!),
          
          
          ElevatedButton(
            child: Text('add menu'),
            onPressed: () async {
              final menuContent = await openDialog();

              menuName = menuContent!['menuName'];
              normalPrice = menuContent['normalPrice'];
              discountedPrice = menuContent['discountedPrice'];

              if (menuName == null ||
                  normalPrice == null ||
                  discountedPrice == null) {
                return;
              }

              setState(() {
                this.menuName = menuName;
                this.normalPrice = normalPrice;
                this.discountedPrice = discountedPrice;

              });
            })]);
  }

  Future<Map<String, String>?> openDialog() => showDialog<Map<String, String>>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('some title'),
          content: Column(
            children: [
              TextField(
                autofocus: true,
                controller: _controllerMenuName,
              ),
              Flex(
                direction: Axis.horizontal,
                children: [
                  TextField(
                    autofocus: true,
                    controller: _controllerNormalPrice,
                  ),
                  TextField(
                    autofocus: true,
                    controller: _controllerDiscountedPrice,
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop({
                    'menuName': _controllerMenuName.text,
                    'normalPrice': _controllerNormalPrice.text,
                    'discountedPrice': _controllerDiscountedPrice.text
                  });
                },
                child: Text('submit'))
          ],
        ),
      );
}