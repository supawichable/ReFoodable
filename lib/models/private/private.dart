part of '_private.dart';

@freezed
class UserPrivate with _$UserPrivate {
  const factory UserPrivate({
    @Default(<String>[]) List<String> bookmarked,
    @Default(<String>[]) List<String> owned,
  }) = _UserPrivate;

  factory UserPrivate.fromJson(Map<String, dynamic> json) =>
      _$UserPrivateFromJson(json);

  factory UserPrivate.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return UserPrivate.fromJson(snapshot.data()!);
  }
}

extension UserPrivateX on UserPrivate {
  Map<String, dynamic> toFirestore() => toJson();
}
