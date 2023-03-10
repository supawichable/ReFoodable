import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/store/_store.dart';
import 'package:gdsctokyo/providers/store_in_view.dart';
import 'package:gdsctokyo/routes/router.gr.dart';
import 'package:gdsctokyo/widgets/icon_text.dart';
import 'package:gdsctokyo/widgets/store_info.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '';

class StorePage extends StatelessWidget {
  final String storeId;

  const StorePage({super.key, @PathParam('storeId') required this.storeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bookmark_border),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          StoreInfo(storeId: storeId),
        ],
      ),
    );
  }
}

class StoreInfo extends HookConsumerWidget {
  final String storeId;

  const StoreInfo({super.key, required this.storeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeFuture = ref.watch(storeInViewProvider(storeId).future);
    return FutureBuilder<DocumentSnapshot<Store>>(
        future: storeFuture,
        builder: (context, snapshot) {
          final store = snapshot.data?.data();
          return Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.width * 2 / 6,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      store?.photoURL ??
                          // 200x300 placeholder image
                          'https://via.placeholder.com/200x300',
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
                              )),
                    )),
              ),
              const SizedBox(height: 4),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    snapshot.hasError
                        ? Text('Error: ${snapshot.error}')
                        : snapshot.hasData
                            ? StoreCard(
                                data: store,
                                edit: FirebaseAuth.instance.currentUser?.uid ==
                                    store?.ownerId)
                            : Text('Loading...')
                  ],
                ),
              ),

              // "You're the owner of this store" => Edit Store Info
              if (FirebaseAuth.instance.currentUser?.uid == store?.ownerId) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('You\'re the owner of this store!'),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            context.router.push(StoreFormRoute(
                              storeId: storeId,
                            ));
                          },
                          child: const Text('Edit Store Info'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ],
          );
        });
  }
}
