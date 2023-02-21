part of 'firebase_extension.dart';

extension UserX on User {
  bool get isProfileCompleted => displayName != null;
}
