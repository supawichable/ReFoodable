import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/extension/listener.dart';

void main() {
  final auth = MockFirebaseAuth();
  final firestore = FakeFirebaseFirestore();

  final mockUser = MockUser(
      isAnonymous: false,
      uid: '123',
      email: 'stonk@example.com',
      displayName: 'Stonk');

  setUpAll(() async {
    FirebaseListener.initializeListener(auth: auth, firestore: firestore);

    await auth.createUserWithEmailAndPassword(
        email: mockUser.email!, password: 'st0nk');
    await auth.currentUser!.updateDisplayName(mockUser.displayName!);
  });

  group('runUserPublicUpdate test', () {
    test('initial user', () async {
      // check if user_public is created
      final userPublicRef = firestore.users.doc(auth.currentUser!.uid);
      final userPublicSnapshot = await userPublicRef.get();

      expect(userPublicSnapshot.exists, true);
      expect(userPublicSnapshot.data()!.displayName, mockUser.displayName);
    });

    test('User update', () async {
      await auth.currentUser!.updateDisplayName('Stonk2');
      expect(auth.currentUser!.displayName, 'Stonk2');

      // check if user_public is updated
      final userPublicRef = firestore.users.doc(auth.currentUser!.uid);
      final userPublicSnapshot = await userPublicRef.get();

      expect(userPublicSnapshot.exists, true);
      expect(userPublicSnapshot.data()!.displayName, 'Stonk2');
    }, skip: 'updateDisplayName is not triggering listener');
  });
}
