import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gdsctokyo/models/menu/_menu.dart';
import 'package:gdsctokyo/models/store/_store.dart';

part 'query.dart';
part 'store.dart';
part 'user.dart';

enum ApiPath {
  stores,
  items,
}
