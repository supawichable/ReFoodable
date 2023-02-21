part of '_user.dart';

@freezed
class PrivateUserData with _$PrivateUserData {
  const factory PrivateUserData({
    required String id,
    @Default(<String>[]) List<String> bookmarked,
    @Default(<String>[]) List<String> owned,
  }) = _PrivateUserData;

  factory PrivateUserData.fromJson(Map<String, dynamic> json) =>
      _$PrivateUserDataFromJson(json);

  factory PrivateUserData.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return PrivateUserData.fromJson({"id": snapshot.id, ...snapshot.data()!});
  }
}
