import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/store/_store.dart';
import 'package:gdsctokyo/widgets/common/icon_text.dart';

class FutureStoreCard extends StatefulWidget {
  final String storeId;
  final StoreCardImageShow imageShow;
  const FutureStoreCard(this.storeId,
      {super.key, this.imageShow = StoreCardImageShow.coverPhoto});

  @override
  State<FutureStoreCard> createState() => _FutureStoreCardState();
}

class _FutureStoreCardState extends State<FutureStoreCard> {
  late final Stream<DocumentSnapshot<Store>> _storeStream =
      FirebaseFirestore.instance.stores.doc(widget.storeId).snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Store>>(
        stream: _storeStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (!snapshot.data!.exists) {
              return Card(
                child: ListTile(
                    title: const Text('Store was deleted. Remove from list?'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await FirebaseFirestore.instance.users
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .bookmarks
                            .doc(widget.storeId)
                            .delete();
                      },
                    )),
              );
            }
            return StoreCard(widget.storeId, snapshot.data!.data()!,
                imageShow: widget.imageShow);
          }
          return const Card(child: ListTile(title: Text('Loading...')));
        });
  }
}

enum StoreCardImageShow { coverPhoto, featuredMenu }

class StoreCard extends StatelessWidget {
  final String storeId;
  final Store? store;
  final StoreCardImageShow imageShow;

  const StoreCard(this.storeId, this.store,
      {super.key, this.imageShow = StoreCardImageShow.coverPhoto});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.router.pushNamed('/store/$storeId'),
      child: Card(
        margin: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (imageShow == StoreCardImageShow.coverPhoto)
                      _CoverPhoto(store: store),
                    const SizedBox(
                      height: 8,
                    ),
                    _StoreTitle(store?.name),
                    const SizedBox(
                      height: 8,
                    ),
                    IconText(
                        icon: Icons.location_pin,
                        iconColor: Colors.red[300],
                        text: '500m from here'),
                    Container(
                        margin: const EdgeInsets.only(top: 2),
                        child: IconText(
                            icon: Icons.bento,
                            iconColor: Colors.red[300],
                            text: 'bento (food type)')),
                    Container(
                        margin: const EdgeInsets.only(
                          top: 15,
                        ),
                        child: IconText(
                            icon: Icons.discount,
                            iconColor: Colors.red[300],
                            text: '40% - 80% Discounted')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CoverPhoto extends StatelessWidget {
  final Store? store;
  const _CoverPhoto({this.store});

  @override
  Widget build(BuildContext context) {
    if (store!.photoURL != null) {
      return Container(
        clipBehavior: Clip.antiAlias,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width / 3,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(store!.photoURL!),
              fit: BoxFit.cover,
            )),
      );
    } else {
      return Container(
        clipBehavior: Clip.antiAlias,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width / 3,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.grey[300]),
      );
    }
  }
}

class _StoreTitle extends StatelessWidget {
  final String? data;
  const _StoreTitle(this.data);

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      // show blank container as placeholder
      return Container(
        height: 20,
        width: 200,
        color: Colors.grey[300],
      );
    } else {
      return Text(data ?? '(Untitled)',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ));
    }
  }
}
