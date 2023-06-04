part of '_user.dart';

@freezed
class UserPublic with _$UserPublic {
  const factory UserPublic({
    String? displayName,
    String? photoURL,
    @Default(0) double moneySaved,
    @Default(0) int foodItemSaved,
  }) = _UserPublic;

  factory UserPublic.fromJson(Map<String, dynamic> json) =>
      _$UserPublicFromJson(json);

  factory UserPublic.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return UserPublic.fromJson(snapshot.data()!);
  }
}

extension UserPublicX on UserPublic {
  Map<String, dynamic> toFirestore() => toJson();
}
