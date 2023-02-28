import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:gdsctokyo/util/json_converter.dart';

part '_item.freezed.dart';
part '_item.g.dart';

part 'item.dart';
part 'price.dart';

class FirestoreItem {
  final String id;
  final Item item;

  FirestoreItem(this.id, this.item);
}
