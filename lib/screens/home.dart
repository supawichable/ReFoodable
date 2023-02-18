import 'package:flutter/material.dart';
import 'package:gdsctokyo/home/explore.dart';
import 'package:gdsctokyo/home/my_page.dart';
import 'package:gdsctokyo/home/restaurant.dart';
import 'package:gdsctokyo/theme/color_schemes.g.dart';
import 'package:gdsctokyo/widgets/big_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  List<Widget> pages = [
    Restaurant(),
    Explore(),
    MyPage(),
  ];

  // titles = ['Restaurant', 'Explore', 'My Page']

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BigText(text: 'My Page'),
        elevation: 2,
      ),
      body: pages[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: lightColorScheme.primaryContainer,
        selectedItemColor: Colors.red[300],
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.restaurant,
              ),
              label: 'Restaurant'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.explore,
              ),
              label: 'Explore'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person_2_rounded,
              ),
              label: 'My Page'),
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
