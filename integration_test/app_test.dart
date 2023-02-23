import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gdsctokyo/firebase_options.dart';
import 'package:gdsctokyo/main.dart';
import 'package:integration_test/integration_test.dart';

part 'instance_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await dotenv.load(fileName: '.env');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseFirestore.instance.useFirestoreEmulator(
        dotenv.get('LOCALHOST_IP', fallback: 'localhost'), 8080);
    await FirebaseAuth.instance.useAuthEmulator(
        dotenv.get('LOCALHOST_IP', fallback: 'localhost'), 9099);

    runApp(Main());
  });

  runInstanceTest();
}
