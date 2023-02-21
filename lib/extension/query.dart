part of 'firebase_extension.dart';

extension QueryX<Restaurant> on Query<Restaurant> {
  /// [Query] object for the restaurants owned by the user with [id].
  ///
  /// Example:
  /// ```dart
  /// final user = FirebaseAuth.instance.currentUser;
  /// final snapshots = await FirebaseFirestore.instance
  ///                   .restaurants
  ///                   .ownedByUser(user.uid)
  ///                   .get();
  /// ```
  Query<Restaurant> ownedByUser(String id) => where('owner_id', isEqualTo: id);
}
