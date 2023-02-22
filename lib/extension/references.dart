part of 'firebase_extension.dart';

extension FirestoreX on FirebaseFirestore {
  CollectionReference<Store> get stores => collection('stores').withConverter(
      fromFirestore: (snapshot, _) => Store.fromFirestore(snapshot),
      toFirestore: (store, _) => store.toJson());

  DocumentReference<Store> store(String id) => doc('stores/$id').withConverter(
      fromFirestore: (snapshot, _) => Store.fromFirestore(snapshot),
      toFirestore: (store, _) => store.toJson());

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
