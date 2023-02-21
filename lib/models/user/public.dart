part of '_user.dart';

@freezed
class Profile with _$Profile {
  const factory Profile({
    required String uid,
    required String? displayName,
    required String? photoURL,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  factory Profile.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Profile.fromJson({"uid": snapshot.id, ...snapshot.data()!});
  }

  static Map<String, dynamic> toFirestore(Profile data) =>
      data.toJson().remove('uid');
}
