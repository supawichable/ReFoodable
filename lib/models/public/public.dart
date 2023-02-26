part of '_public.dart';

@freezed
class UserPublic with _$UserPublic {
  const factory UserPublic({
    String? displayName,
    String? photoURL,
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
