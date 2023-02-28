import 'package:flutter/material.dart';
import 'package:gdsctokyo/screens/home/bookmark.dart';
import 'package:gdsctokyo/screens/home/explore.dart';
import 'package:gdsctokyo/screens/home/my_page/my_page.dart';
import 'package:gdsctokyo/theme/color_schemes.dart';
import 'package:gdsctokyo/widgets/big_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  List<Widget> pages = [
    const Bookmark(),
    const Explore(),
    const MyPage(),
  ];

  List<String> titles = ['Store', 'Explore', 'My page'];

  // titles = ['Store', 'Explore', 'My Page']

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[currentPage]),
        elevation: 2,
      ),
      body: pages[currentPage],
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          backgroundColor: lightColorScheme.onInverseSurface,
          selectedItemColor: Colors.red[300],
          unselectedItemColor: Colors.grey[800],
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.store,
                ),
                label: 'Store'),
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
      ),
    );
  }
}
