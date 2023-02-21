import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gdsctokyo/models/restaurant/_restaurant.dart';
import 'package:gdsctokyo/models/user/_user.dart';

extension FirestoreX on FirebaseFirestore {
  CollectionReference<Restaurant> get restaurants =>
      collection('restaurants').withConverter(
          fromFirestore: (snapshot, _) => Restaurant.fromFirestore(snapshot),
          toFirestore: (restaurant, _) => restaurant.toJson());

  DocumentReference<Restaurant> restaurant(String id) =>
      doc('restaurants/$id').withConverter(
          fromFirestore: (snapshot, _) => Restaurant.fromFirestore(snapshot),
          toFirestore: (restaurant, _) => restaurant.toJson());

  // CollectionReference<Profile> get profiles =>
  //     collection('profiles').withConverter(
  //         fromFirestore: (snapshot, _) => Profile.fromFirestore(snapshot),
  //         toFirestore: (user, _) => user.toJson());

  // DocumentReference<Profile> profile(String id) =>
  //     doc('profiles/$id').withConverter(
  //         fromFirestore: (snapshot, _) => Profile.fromFirestore(snapshot),
  //         toFirestore: (user, _) => user.toJson());

  // CollectionReference<List<DocumentReference>> get bookmarks =>
  //     collection('bookmarks').withConverter(
  //         fromFirestore: (snapshot, _) => UserData.fromFirestore(snapshot),
  //         toFirestore: (user, _) => user.toJson());

  // DocumentReference<List<DocumentReference>> bookmark(String id) =>
  //     doc('bookmarks/$id').withConverter(
  //         fromFirestore: (snapshot, _) => UserData.fromFirestore(snapshot),
  //         toFirestore: (user, _) => user.toJson());
}
