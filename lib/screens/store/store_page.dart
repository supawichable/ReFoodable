import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/store/_store.dart';
import 'package:gdsctokyo/providers/item_in_context.dart';
import 'package:gdsctokyo/screens/store/item_dialog_panel_widget.dart';
import 'package:gdsctokyo/util/logger.dart';
import 'package:gdsctokyo/widgets/store_page/store_info.dart';
import 'package:gdsctokyo/widgets/store_page/my_items.dart';
import 'package:gdsctokyo/widgets/store_page/today_items.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

final _pc = PanelController();

class StorePage extends HookConsumerWidget {
  final String storeId;

  const StorePage({super.key, @PathParam('storeId') required this.storeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(itemInContextProvider, (prev, next) {
      if (next != null) {
        _pc.open();
      } else {
        _pc.close();
      }
    });
    return Scaffold(
        appBar: AppBar(
          actions: [
            _BookMarkButton(storeId: storeId),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.share),
            ),
          ],
        ),
        body: Stack(
          children: [
            ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                StoreInfo(storeId: storeId),
              ],
            ),
            SlidingUpPanel(
              backdropColor: Colors.black,
              backdropEnabled: true,
              backdropOpacity: 0.5,
              backdropTapClosesPanel: true,
              onPanelClosed: () {
                ref
                    .read(itemInContextProvider.notifier)
                    .update((state) => null);
              },
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              minHeight: 0,
              maxHeight:
                  ref.watch(itemInContextProvider)?.reference.parent.id ==
                          ApiPath.myItems
                      ? 150
                      : 100,
              controller: _pc,
              panel: const ItemDialogPanelWidget(),
            ),
          ],
        ));
  }
}

class _BookMarkButton extends StatefulWidget {
  final String storeId;

  const _BookMarkButton({required this.storeId});

  @override
  State<_BookMarkButton> createState() => __BookMarkButtonState();
}

class __BookMarkButtonState extends State<_BookMarkButton> {
  late Stream<DocumentSnapshot> _bookmarkStream;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    _bookmarkStream = FirebaseFirestore.instance.users
        .doc(user.uid)
        .bookmarks
        .doc(widget.storeId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: _bookmarkStream,
        builder: (context, snapshot) {
          return IconButton(
            onPressed: () async {
              if (snapshot.data?.exists == true) {
                await FirebaseFirestore.instance.users
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .bookmarks
                    .doc(widget.storeId)
                    .delete();
              } else {
                await _addToBookmark();
              }
            },
            icon: Icon(snapshot.data?.exists == true
                ? Icons.bookmark
                : Icons.bookmark_border),
          );
        });
  }

  Future<void> _addToBookmark() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    await FirebaseFirestore.instance.users
        .doc(user.uid)
        .bookmarks
        .doc(widget.storeId)
        .set({});
  }
}

class StoreInfo extends StatefulWidget {
  final String storeId;

  const StoreInfo({super.key, required this.storeId});

  @override
  State<StoreInfo> createState() => _StoreInfoState();
}

class _StoreInfoState extends State<StoreInfo> {
  late Stream<DocumentSnapshot<Store>> _storeStream;

  @override
  void initState() {
    super.initState();
    _storeStream =
        FirebaseFirestore.instance.stores.doc(widget.storeId).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Store>>(
        stream: _storeStream,
        builder: (context, snapshot) {
          final store = snapshot.data?.data();
          return Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.width / 3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      store?.photoURL ??
                          // 100x300 placeholder image
                          'https://via.placeholder.com/100x300',
                    ),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.2), BlendMode.darken),
                  ),
                ),
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        snapshot.connectionState == ConnectionState.waiting
                            ? 'Loading...'
                            : store != null
                                ? store.name ?? '(Untitled)'
                                : 'Error fetching store',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    )),
              ),
              const SizedBox(height: 4),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    if (snapshot.connectionState == ConnectionState.waiting)
                      const LinearProgressIndicator()
                    else ...[
                      StoreCard(
                        storeId: widget.storeId,
                        store: store,
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (FirebaseAuth.instance.currentUser?.uid ==
                        store?.ownerId) ...[
                      MyItems(
                        storeId: widget.storeId,
                      ),
                      const SizedBox(height: 16)
                    ],
                    TodayItems(
                      storeId: widget.storeId,
                    ),
                  ],
                ),
              ),
              // "You're the owner of this store" => Edit Store Info
            ],
          );
        });
  }
}
