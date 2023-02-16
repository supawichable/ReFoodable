import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gdsctokyo/firebase_options.dart';
import 'package:gdsctokyo/routes/router.gr.dart';
import 'package:gdsctokyo/theme/color_schemes.g.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator(
          dotenv.get('LOCALHOST_IP', fallback: 'localhost'), 8080);
      await FirebaseAuth.instance.useAuthEmulator(
          dotenv.get('LOCALHOST_IP', fallback: 'localhost'), 9099);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Define baseTheme here
    final baseTheme = ThemeData(
      useMaterial3: true,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
    );

    return MaterialApp.router(
      // See `theme/color_schemes.g.dart` for the color schemes.
      theme: baseTheme.copyWith(
        colorScheme: lightColorScheme,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: lightColorScheme.onBackground,
                displayColor: lightColorScheme.onBackground,
              ),
        ),
      ),

      darkTheme: baseTheme.copyWith(
          colorScheme: darkColorScheme,
          scaffoldBackgroundColor: darkColorScheme.background,
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme.apply(
                  bodyColor: darkColorScheme.onBackground,
                  displayColor: darkColorScheme.onBackground,
                ),
          )),
      themeMode: ThemeMode.light,
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
    );
  }
}
