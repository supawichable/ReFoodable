import 'package:flutter_test/flutter_test.dart';
import 'package:gdsctokyo/models/user/_user.dart';

// will later on use Firebase Emulators
void main() {
  group('User', () {
    test('Parsing not authenticated user', () {
      const json = {
        "id": "12345",
        "authenticated": false,
        "email_verified": false
      };

      final user = User.fromJson(json);
      expect(user.id, "12345");
      expect(user.authenticated, false);
      expect(user.emailVerified, false);
    });
  });
}
