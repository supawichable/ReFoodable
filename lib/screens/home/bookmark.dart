import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/store/_store.dart';
import 'package:gdsctokyo/widgets/store_card.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  late final Stream<QuerySnapshot<Bookmark>> _bookmarkStream = FirebaseFirestore
      .instance.users
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .bookmarks
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      children: [
        if (FirebaseAuth.instance.currentUser == null)
          const Text('Please sign in to use bookmark feature.'),
        if (FirebaseAuth.instance.currentUser != null)
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
