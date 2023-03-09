import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/store/_store.dart';
import 'package:gdsctokyo/util/logger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final currentUserProvider = StreamProvider<User?>((ref) async* {
  await for (final user in FirebaseAuth.instance.userChanges()) {
    logger.i('user changed: $user');
    yield user;
  }
});

final ownedStoresProvider =
    FutureProvider.autoDispose<QuerySnapshot<Store>>((ref) async {
  final user = ref.watch(currentUserProvider).value;
  final snapshot =
      await FirebaseFirestore.instance.stores.ownedByUser(user!.uid).get();
  return snapshot;
});
