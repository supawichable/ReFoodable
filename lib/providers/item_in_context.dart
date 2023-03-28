import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gdsctokyo/models/item/_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final itemInContextProvider = StateProvider<DocumentSnapshot<Item>?>((ref) {
  return null;
});
