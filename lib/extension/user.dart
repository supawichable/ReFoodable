import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gdsctokyo/extension/references.dart';
import 'package:gdsctokyo/models/restaurant/_restaurant.dart';

extension UserX on User {
  /// [Query] object for the current user's owned restaurants.
  ///
  /// Example:
  /// ```dart
  /// final user = FirebaseAuth.instance.currentUser;
  /// final snapshots = await user.ownedRestaurantsRef.get();
  /// final docs = snapshots.docs;
  /// final List<Restaurant> restaurants = docs.map((doc) => doc.data());
  /// ```
  Query<Restaurant> get ownedRestaurantsRef =>
      FirebaseFirestore.instance.restaurants.where('owner_id', isEqualTo: uid);

  /// Add a restaurant by this current user.
  ///
  /// Example:
  /// ```dart
  /// final user = FirebaseAuth.instance.currentUser;
  /// final restaurant = Restaurant(
  ///  name: 'Restaurant Name',
  ///  location: GeoPoint(0, 0),
  ///  ownerId: user.uid,
  /// );
  /// await user.addRestaurant(restaurant);
  /// ```
  Future<DocumentReference<Restaurant>> addRestaurant(
      Restaurant restaurant) async {
    return await FirebaseFirestore.instance.restaurants
        .add(restaurant.copyWith(ownerId: uid));
  }
}
