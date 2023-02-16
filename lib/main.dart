import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gdsctokyo/firebase_options.dart';
import 'package:gdsctokyo/routes/router.gr.dart';
import 'package:gdsctokyo/theme/color_schemes.g.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode && dotenv.get("USE_EMULATOR") == 'true') {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  runApp(Main());
}

class Main extends StatelessWidget {
  Main({super.key});

  final _appRouter = AppRouter();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData(
      useMaterial3: true,
      textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Poppins'),
    );

    return MaterialApp.router(
      // See `theme/color_schemes.g.dart` for the color schemes.
      debugShowCheckedModeBanner: false,
      theme: baseTheme.copyWith(
        colorScheme: lightColorScheme,
      ),
      darkTheme: baseTheme.copyWith(
          colorScheme: darkColorScheme,
          scaffoldBackgroundColor: darkColorScheme.background),
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
    );
  }
}
