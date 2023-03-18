import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/models/item/_item.dart';
import 'package:gdsctokyo/util/logger.dart';
import 'package:gdsctokyo/widgets/item_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final searchTextProvider = StateProvider<String>((ref) => '');

class StreamedItemList extends HookConsumerWidget {
  final Stream<QuerySnapshot<Item>> itemStream;

  const StreamedItemList({super.key, required this.itemStream});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const SearchBar(),
        StreamBuilder(
            stream: itemStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LinearProgressIndicator();
              }

              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: ListView(
                    children: [
                      for (final item in snapshot.data!.docs)
                        if (item.data().name?.toLowerCase().contains(
                                ref.watch(searchTextProvider).toLowerCase()) ??
                            false)
                          ItemCard(key: ValueKey(item.id), snapshot: item)
                    ],
                  ),
                );
              }

              return const Center(
                child: Text('No items'),
              );
            }),
      ],
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
          hintText: 'Filter',
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

  void _clear() {}
}
