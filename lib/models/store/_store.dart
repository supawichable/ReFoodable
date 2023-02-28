import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:gdsctokyo/util/json_converter.dart';

part '_store.freezed.dart';
part '_store.g.dart';

part 'store.dart';
part 'schedule.dart';

class FirestoreStore {
  final String id;
  final Store store;

  FirestoreStore(this.id, this.store);
}
