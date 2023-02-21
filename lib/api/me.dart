part of 'api.dart';

class Me {
  late FirebaseApi _api;

  Me(FirebaseApi api) : _api = api;

  Future<List<Restaurant>> getOwnedRestaurants() async {
    if (!_api.isAuthenticated) return Future.value(<Restaurant>[]);

    final snapshots = await _api._restaurantsReference
        .where('ownerId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();

    final docs = snapshots.docs;
    return docs.map((doc) => doc.data()).toList();
  }

  Future<List<Restaurant>> getBookmarkedRestaurants() async {
    List<String> bookmarked;

    if (!_api.isAuthenticated) {
      final data = await _api._storage.read(key: 'bookmarked');
      if (data == null) return Future.value(<Restaurant>[]);

      bookmarked = data.split(',');
    } else {
      final snapshot = await _api._privateUserReference.get();

      final data = snapshot.data();
      if (data == null) return Future.value(<Restaurant>[]);

      bookmarked = data.bookmarked;
      if (bookmarked.isEmpty) return Future.value(<Restaurant>[]);
    }

    final snapshots = await _api._restaurantsReference
        .where(FieldPath.documentId, whereIn: bookmarked)
        .get();

    final docs = snapshots.docs;
    return docs.map((doc) => doc.data()).toList();
  }
}
