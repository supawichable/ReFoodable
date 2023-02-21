part of 'api.dart';

class Me {
  final DocumentReference _meReference = FirebaseFirestore.instance
      .doc('users/${FirebaseAuth.instance.currentUser?.uid}');

  final CollectionReference _restaurantsReference =
      FirebaseFirestore.instance.collection('restaurants');

  Future<List<Restaurant>> getMyRestaurants() async {
    final snapshots = await _restaurantsReference
        .withConverter(
            fromFirestore: (snapshot, _) => Restaurant.fromFirestore(snapshot),
            toFirestore: (restaurant, _) => restaurant.toJson())
        .where('ownerId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();

    final docs = snapshots.docs;
    return docs.map((doc) => doc.data()).toList();
  }
}
