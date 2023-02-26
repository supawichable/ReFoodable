part of 'firebase_extension.dart';

extension UserX on User {
  bool get isProfileCompleted => displayName != null;
}

typedef UserPrivateReference = DocumentReference<UserPrivate>;
typedef UserPrivatesReference = CollectionReference<UserPrivate>;

typedef UserPublicReference = DocumentReference<UserPublic>;
typedef UserPublicsReference = CollectionReference<UserPublic>;
