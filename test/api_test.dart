import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() {
  final _auth = MockFirebaseAuth();
  final _firestore = FakeFirebaseFirestore();

  group('User 1 Registered with Email and Password', () {
    test('User 1 can register with email and password', () async {
      final user1 = MockUser(
        email: 'user1@example.com',
      );

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: user1.email!,
        password: 'password',
      );

      expect(userCredential.user, isNotNull);
      expect(userCredential.user!.email, user1.email);
    });
  });
}
