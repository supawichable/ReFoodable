part of '_user.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required bool authenticated,
    required bool emailVerified,

    // if not authenticated then these are null
    String? name,
    String? email,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
