import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/util/json_converter.dart';

part '_private.g.dart';
part '_private.freezed.dart';

part 'private.dart';

class FirestoreUserPrivate {
  final String id;
  final UserPrivate userPrivate;

  FirestoreUserPrivate(this.id, this.userPrivate);
}
