part of '_user.dart';

@Deprecated("Should use Firebase's User class instead")
@freezed
class AccountUser with _$AccountUser {
  const factory AccountUser({
    required String id,
    required bool authenticated,
    required bool emailVerified,

    // if not authenticated then these are null
    String? name,
    String? email,
  }) = _AccountUser;

  factory AccountUser.fromJson(Map<String, dynamic> json) =>
      _$AccountUserFromJson(json);
}
