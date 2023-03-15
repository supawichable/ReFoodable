part of 'firebase_extension.dart';

extension UserX on User {
  bool get isProfileCompleted => displayName != null;
}

typedef UserPublicReference = DocumentReference<UserPublic>;
typedef UserPublicsReference = CollectionReference<UserPublic>;

typedef Bookmark = Map<String, dynamic>;
typedef BookmarksReference = CollectionReference<Bookmark>;
typedef BookmarksSnapshot = QuerySnapshot<Bookmark>;

extension UserPublicReferenceX on UserPublicReference {
  /// Get a collection reference of bookmarks in a user document.
  /// This is to get all the bookmarks of the user and to add new bookmarks.
  /// This is only accessible by the user.
  ///
  /// Example (gets, get, add):
  /// ```dart
  /// final user = FirebaseFirestore.instance.users.doc('user_id');
  /// final bookmarksRef = user.bookmarks;
  ///
  /// // get all bookmarks of the user
  /// final snapshots = await bookmarksRef.get();
  ///
  /// // get a specific bookmark of the user
  /// final bookmarkRef = bookmarksRef.doc('store_id');
  /// final snapshot = await bookmarkRef.get();
  ///
  /// // add a bookmark to the user
  /// final bookmark = bookmarksRef.add(store.id);
  /// ```
  CollectionReference<Bookmark> get bookmarks => collection(ApiPath.bookmarks);
}
