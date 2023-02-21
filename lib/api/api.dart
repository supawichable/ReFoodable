import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gdsctokyo/models/restaurant/_restaurant.dart';
import 'package:gdsctokyo/models/user/_user.dart';

part 'me.dart';
part 'restaurant.dart';

class FirebaseApi {
  static late final FirebaseApi _instance;
  late final Restaurants _restaurants;
  late final Me _me;

  FirebaseApi() {
    _instance = this;
    _restaurants = Restaurants(_instance);
    _me = Me(_instance);
  }

  final CollectionReference<Restaurant> _restaurantsReference =
      FirebaseFirestore.instance.collection('restaurants').withConverter(
          fromFirestore: (snapshot, _) => Restaurant.fromFirestore(snapshot),
          toFirestore: (restaurant, _) => restaurant.toJson());

  DocumentReference<Restaurant> _restaurantReference(String id) =>
      FirebaseFirestore.instance.doc('restaurants/$id').withConverter(
          fromFirestore: (snapshot, _) => Restaurant.fromFirestore(snapshot),
          toFirestore: (restaurant, _) => restaurant.toJson());

  final CollectionReference<PrivateUserData> _privateUsersReference =
      FirebaseFirestore.instance.collection('users').withConverter(
          fromFirestore: (snapshot, _) =>
              PrivateUserData.fromFirestore(snapshot),
          toFirestore: (user, _) => user.toJson());

  final DocumentReference<PrivateUserData> _privateUserReference =
      FirebaseFirestore
          .instance
          .doc('users/${FirebaseAuth.instance.currentUser?.uid}')
          .withConverter(
              fromFirestore: (snapshot, _) =>
                  PrivateUserData.fromFirestore(snapshot),
              toFirestore: (user, _) => user.toJson());

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static FirebaseApi get instance => _instance;
  bool get isAuthenticated => FirebaseAuth.instance.currentUser != null;
  Me get me => _me;
  Restaurants get restaurants => _restaurants;
}
