part of 'app_test.dart';

void runInstanceTest() {
  group('firebase instance', () {
    test('auth instance works properly', () {
      expect(FirebaseAuth.instance, isNotNull);
    });

    test('firestore instance works properly', () {
      expect(FirebaseFirestore.instance, isNotNull);
    });
  });
}
