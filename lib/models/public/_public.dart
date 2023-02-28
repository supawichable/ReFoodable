import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '_public.g.dart';
part '_public.freezed.dart';

part 'public.dart';

class FirestoreUserPublic {
  final String id;
  final UserPublic userPublic;

  FirestoreUserPublic(this.id, this.userPublic);
}
