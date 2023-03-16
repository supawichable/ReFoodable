import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final currentUserProvider = StreamProvider<User?>((ref) async* {
  await for (final user in FirebaseAuth.instance.userChanges()) {
    yield user;
  }
});
