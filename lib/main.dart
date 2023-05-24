import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gdsctokyo/extension/listener.dart';
import 'package:gdsctokyo/firebase_options.dart';
import 'package:gdsctokyo/providers/theme.dart';
import 'package:gdsctokyo/routes/router.dart';
import 'package:gdsctokyo/theme/color_schemes.dart';
import 'package:gdsctokyo/util/logger.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  await dotenv.load(fileName: '.env');

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode && dotenv.get('USE_EMULATOR', fallback: 'false') == 'true') {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator(
          dotenv.get('LOCALHOST_IP', fallback: 'localhost'), 8080);
      await FirebaseAuth.instance.useAuthEmulator(
          dotenv.get('LOCALHOST_IP', fallback: 'localhost'), 9099);
      await FirebaseStorage.instance.useStorageEmulator(
          dotenv.get('LOCALHOST_IP', fallback: 'localhost'), 9199);
    } catch (e) {
      logger.e(e);
    }
  }

  FirebaseListener.initializeListener();

  runApp(ProviderScope(
    child: Main(),
  ));
}

class Main extends HookConsumerWidget {
  Main({super.key});

  final _appRouter = AppRouter();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return MaterialApp.router(
      // See `theme/color_schemes.g.dart` for the color schemes.
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
        textTheme: ThemeData.light().textTheme.apply(
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
        iconTheme: IconThemeData(color: lightColorScheme.primary),
      ),

      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
        textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
        iconTheme: IconThemeData(color: darkColorScheme.primary),
      ),
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
    );
  }
}
