import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/item/_item.dart';
import 'package:gdsctokyo/widgets/add_item_dialog.dart';
import 'package:gdsctokyo/widgets/item_card.dart';

class StoreTodayItemPage extends StatefulWidget {
  final String storeId;

  const StoreTodayItemPage(
      {Key? key, @PathParam('storeId') required this.storeId})
      : super(key: key);

  @override
  _StoreTodayItemPageState createState() => _StoreTodayItemPageState();
}

class _StoreTodayItemPageState extends State<StoreTodayItemPage> {
  bool _isCheapestSelected = false;
  bool _isNearestSelected = false;

  void _onFilterSelectionChanged(List<bool> selections) {
    setState(() {
      _isCheapestSelected = selections[0];
      _isNearestSelected = selections[1];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
            context: context,
            builder: (context) => AddItemDialog(
                  storeId: widget.storeId,
                )),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Today Items'),
        centerTitle: true,
        actions: [],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          FilterTab(
            storeId: widget.storeId,
            onSelectionChanged: _onFilterSelectionChanged,
          ),
          const SizedBox(height: 10,),
          Expanded(
            child: TodayItemsList(
              storeId: widget.storeId,
              isCheapestSelected: _isCheapestSelected,
              isNearestSelected: _isNearestSelected,
            ),
          ),
        ],
      ),
    );
  }
}

class TodayItemsList extends StatefulWidget {
  final String storeId;
  final bool isCheapestSelected;
  final bool isNearestSelected;

  const TodayItemsList({
    Key? key,
    required this.storeId,
    required this.isCheapestSelected,
    required this.isNearestSelected,
  }) : super(key: key);

  @override
  State<TodayItemsList> createState() => _TodayItemsListState();
}

class _TodayItemsListState extends State<TodayItemsList> {
  late Stream<QuerySnapshot<Item>> _todaysStream;

  @override
  void initState() {
    super.initState();
    _updateQuery();
  }

  @override
  void didUpdateWidget(TodayItemsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCheapestSelected != oldWidget.isCheapestSelected ||
        widget.isNearestSelected != oldWidget.isNearestSelected) {
      _updateQuery();
    }
  }

  void _updateQuery() {
    Query<Item> query =
        FirebaseFirestore.instance.stores.doc(widget.storeId).todaysItems;

    if (widget.isCheapestSelected) {
      query = query.orderBy('price.amount');
    } else if (widget.isNearestSelected) {
      query = query.orderBy('updated_at', descending: true,);
    }

    _todaysStream = query.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Item>>(
  stream: _todaysStream,
  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Item>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const LinearProgressIndicator();
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView(
        children: snapshot.data!.docs.map((snapshot) => ItemCard(
          key: ValueKey(snapshot.id),
          snapshot: snapshot,
        )).toList(),
      ),
    );
  },
);

    // return StreamBuilder(
    //     stream: _todaysStream,
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return const LinearProgressIndicator();
    //       }

    //       return SizedBox(
    //         height: MediaQuery.of(context).size.height,
    //         child: ListView(
    //             children: snapshot.data!.docs
    //                 .map((snapshot) => ItemCard(
    //                     key: ValueKey(snapshot.id), snapshot: snapshot))
    //                 .toList()),
    //       );
    //     });
  }
}

class FilterTab extends StatefulWidget {
  final void Function(List<bool>) onSelectionChanged;
  final String storeId;

  const FilterTab(
      {Key? key, required this.storeId, required this.onSelectionChanged})
      : super(key: key);

  @override
  State<FilterTab> createState() => FilterTabState();
}

class FilterTabState extends State<FilterTab> {
  final List<bool> _selections = List.generate(2, (index) => false);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ToggleButtons(
          renderBorder: false,
          isSelected: _selections,
          onPressed: ((int index) {
            setState(() {
              _selections[index] = !_selections[index];
      
              for (int i = 0;  i < _selections.length; i += 1) {
                if (i != index) {
                  _selections[i] = false;
                }
              }
            });
            widget.onSelectionChanged(_selections);
          }),
          children: const [
            SizedBox(width: 80, child: Center(child: Text('cheapest'))),
            SizedBox(width: 100, child: Center(child: Text('most recent'))),
          ],
        ),
        
        ]
      ),
    );
  }
}
