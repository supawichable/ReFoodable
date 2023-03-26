import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/providers/current_user.dart';
import 'package:gdsctokyo/widgets/store_page/store_card.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BookmarkPage extends StatefulHookConsumerWidget {
  const BookmarkPage({super.key});

  @override
  ConsumerState<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends ConsumerState<BookmarkPage> {
  late final uid = ref.watch(currentUserProvider).value?.uid;
  late final Stream<QuerySnapshot<Bookmark>> _bookmarkStream =
      FirebaseFirestore.instance.users.doc(uid).bookmarks.snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      children: [
        if (uid == null) const Text('Please sign in to use bookmark feature.'),
        if (uid != null)
          StreamBuilder<QuerySnapshot<Bookmark>>(
              stream: _bookmarkStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return const Text('No bookmarked stores');
                }
                return Expanded(
                    child: ListView.separated(
                  itemCount: snapshot.data!.docs.length + 1,
                  itemBuilder: (context, index) {
                    if (index == snapshot.data!.docs.length) {
                      return const SizedBox(
                        height: 100,
                      );
                    }
                    final bookmark = snapshot.data!.docs[index];
                    return FutureStoreCard(bookmark.id);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider();
                  },
                ));
              }),
      ],
    )));
  }
}
