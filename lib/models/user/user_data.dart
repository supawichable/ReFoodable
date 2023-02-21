part of '_user.dart';

@freezed
class UserData with _$UserData {
  const factory UserData({
    required String id,
    @Default(<String>[]) List<String> bookmarked,
    @Default(<String>[]) List<String> owned,
  }) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  factory UserData.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return UserData.fromJson({"uid": snapshot.id, ...snapshot.data()!});
  }

  static Map<String, dynamic> toFirestore(Profile data) =>
      data.toJson().remove('uid');
}
