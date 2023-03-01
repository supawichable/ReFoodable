import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/store/_store.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final storeInViewProvider = FutureProvider.autoDispose
    .family<DocumentSnapshot<Store>, String>((ref, storeId) async {
  return FirebaseFirestore.instance.stores.doc(storeId).get();
});
