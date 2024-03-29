import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/item/_item.dart';
import 'package:gdsctokyo/widgets/item/item_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum SortBy { cheapest, recent }

final searchTextProvider = StateProvider<String>((ref) => '');
final selectedSortByProvider = StateProvider<SortBy>((ref) => SortBy.recent);

class StreamedItemList extends StatefulHookConsumerWidget {
  final CollectionReference<Item> itemBucket;

  const StreamedItemList({super.key, required this.itemBucket});

  @override
  ConsumerState<StreamedItemList> createState() => _StreamedItemListState();
}

class _StreamedItemListState extends ConsumerState<StreamedItemList> {
  late Stream<QuerySnapshot<Item>> itemStream = widget.itemBucket.snapshots();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ref.read(searchTextProvider.notifier).update((state) => '');
        return true;
      },
      child: Column(
        children: [
          const SearchBar(),
          const OrderTab(),
          StreamBuilder(
              stream: itemStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LinearProgressIndicator();
                }

                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  // filter out bad items
                  final filtered = snapshot.data!.docs
                      .where((element) =>
                          element.data().name != null &&
                          element.data().price != null &&
                          element.data().updatedAt != null &&
                          element.data().createdAt != null)
                      .toList();

                  return SortedItemList(items: filtered);
                }

                return const Center(
                  child: Text('No items'),
                );
              }),
        ],
      ),
    );
  }
}

class SortedItemList extends HookConsumerWidget {
  final List<DocumentSnapshot<Item>> items;

  const SortedItemList({super.key, required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (ref.watch(selectedSortByProvider)) {
      case SortBy.cheapest:
        if (items[0].reference.parent.id == ApiPath.todaysItems) {
          // sort by amount
          items.sort((a, b) =>
              a.data()!.price!.amount!.compareTo(b.data()!.price!.amount!));
        } else {
          // sort by compareAtPrice
          items.sort((a, b) => a
              .data()!
              .price!
              .compareAtPrice!
              .compareTo(b.data()!.price!.compareAtPrice!));
        }

        break;
      case SortBy.recent:
        items.sort((a, b) => (b.data()!.updatedAt ?? DateTime.now())
            .compareTo((a.data()!.updatedAt ?? DateTime.now())));
        break;
    }

    return Flexible(
      child: ListView(
        children: [
          for (final item in items)
            if (item.data()!.name!.toLowerCase().replaceAll(' ', '').contains(
                ref
                    .watch(searchTextProvider)
                    .toLowerCase()
                    .replaceAll(' ', '')))
              ItemCard(key: ValueKey(item.id), snapshot: item)
        ],
      ),
    );
  }
}

class SearchBar extends StatefulHookConsumerWidget {
  const SearchBar({super.key});

  @override
  ConsumerState<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<SearchBar> {
  late final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withAlpha(50),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) =>
            ref.read(searchTextProvider.notifier).state = value,
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: const Icon(Icons.search),
          border: const OutlineInputBorder(),
          suffixIcon:
              IconButton(onPressed: _clear, icon: const Icon(Icons.clear)),
        ),

        // unfocus
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
      ),
    );
  }

  void _clear() {
    _searchController.clear();
    ref.read(searchTextProvider.notifier).state = '';
  }
}

class OrderTab extends HookConsumerWidget {
  const OrderTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [
        const Text('Order by: '),
        const SizedBox(width: 8),
        ChoiceChip(
            avatar: ref.watch(selectedSortByProvider) == SortBy.cheapest
                ? const CircleAvatar(radius: 12)
                : const CircleAvatar(
                    radius: 12,
                    child: Icon(
                      Icons.attach_money_outlined,
                      size: 12,
                    ),
                  ),
            label: const Text('Cheapest'),
            selected: ref.watch(selectedSortByProvider) == SortBy.cheapest,
            onSelected: (value) => ref
                .read(selectedSortByProvider.notifier)
                .state = SortBy.cheapest),
        const SizedBox(width: 8),
        ChoiceChip(
            avatar: ref.watch(selectedSortByProvider) == SortBy.recent
                ? const CircleAvatar(radius: 12)
                : const CircleAvatar(
                    radius: 12,
                    child: Icon(
                      Icons.access_time_outlined,
                      size: 12,
                    ),
                  ),
            label: const Text('Most Recent'),
            selected: ref.watch(selectedSortByProvider) == SortBy.recent,
            onSelected: (value) => ref
                .read(selectedSortByProvider.notifier)
                .state = SortBy.recent),
      ]),
    );
  }
}
