part of 'api.dart';

class Restaurants {
  final CollectionReference _restaurantsReference =
      FirebaseFirestore.instance.collection('restaurants');

  /* Get all restaurants
    * @param limit: limit the number of restaurants to return
    * @return: a list of restaurants
  */
  Future<List<Restaurant>> getAll({int limit = 50}) async {
    final snapshot = await _restaurantsReference
        .withConverter(
            fromFirestore: (snapshot, _) => Restaurant.fromFirestore(snapshot),
            toFirestore: (restaurant, _) => restaurant.toJson())
        .limit(limit)
        .get();

    final docs = snapshot.docs;
    return docs.map((doc) => doc.data()).toList();
  }

  /* Get a restaurant by id
    * @param id: the id of the restaurant
    * @return: a restaurant
  */
  Future<Restaurant?> getById(String id) async {
    final snapshot = await _restaurantsReference
        .withConverter(
            fromFirestore: (snapshot, _) => Restaurant.fromFirestore(snapshot),
            toFirestore: (restaurant, _) => restaurant.toJson())
        .doc(id)
        .get();

    return snapshot.data();
  }
}
