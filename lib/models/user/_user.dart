import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '_user.g.dart';
part '_user.freezed.dart';

part 'public.dart';

class FirestoreUserPublic {
  final String id;
  final UserPublic userPublic;
  double? moneySaved;
  int? foodItemSaved;

  FirestoreUserPublic(
      this.id, this.userPublic, this.foodItemSaved, this.moneySaved);
}
