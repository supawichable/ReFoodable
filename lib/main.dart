import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gdsctokyo/firebase_options.dart';
import 'package:gdsctokyo/home/explore.dart';
import 'package:gdsctokyo/home/my_page.dart';
import 'package:gdsctokyo/home/restaurant.dart';
import 'package:gdsctokyo/theme/color_schemes.g.dart';
import 'package:gdsctokyo/widgets/big_text.dart';

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
      print(e);
    }
  }

  runApp(Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        primaryColor: lightColorScheme.primaryContainer,
      ),
      home: const Rootpage(),
    );
  }
}

class Rootpage extends StatefulWidget {
  const Rootpage({super.key});

  @override
  State<Rootpage> createState() => _RootpageState();
}

class _RootpageState extends State<Rootpage> {
  int currentPage = 0;
  List<Widget> pages = [
    Restaurant(),
    Explore(),
    MyPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightColorScheme.primaryContainer,
        title: BigText(text: 'My Page'),
        elevation: 0,
      ),
      body: pages[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: lightColorScheme.primaryContainer,
        selectedItemColor: Colors.red[300],
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.restaurant,), label: 'Restuarant'),
          BottomNavigationBarItem(icon: Icon(Icons.explore,), label: 'Explore'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_2_rounded,), label: 'My Page'),
        ],
        onTap: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        currentIndex: currentPage,
      ),
    );
  }
}
