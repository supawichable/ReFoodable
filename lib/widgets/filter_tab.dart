import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FilterTab extends StatefulWidget {
  const FilterTab({super.key});

  @override
  State<FilterTab> createState() => FilterTabState();
}

class FilterTabState extends State<FilterTab> {
  final List<bool> _selections = List.generate(2, (index) => false);

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      selectedColor: Colors.orange,
      renderBorder: false,
      isSelected: _selections,

      onPressed: ((int index) {
        setState(() {
          _selections[index] != _selections[index];

          
        });

        if (_selections == [true, false]) {
          FirebaseFirestore.instance.collection('todays_items').orderBy('amount').snapshots();
        }
        if (_selections == [false, true]) {
           FirebaseFirestore.instance.collection('todays_items').orderBy('amount').snapshots();
        }

        
      }),
      children: const [
        Text('cheapest'),
        Text('nearest'),
      ]);
  }
}
