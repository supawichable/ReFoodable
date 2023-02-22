import 'package:flutter/material.dart';
import 'package:gdsctokyo/screens/home/bookmark.dart';
import 'package:gdsctokyo/screens/home/my_page/my_page.dart';
import 'package:gdsctokyo/screens/home/explore.dart';
import 'package:gdsctokyo/theme/color_schemes.g.dart';
import 'package:gdsctokyo/widgets/big_text.dart';
import 'package:gdsctokyo/widgets/my_items.dart';
import 'package:gdsctokyo/widgets/store_info.dart';
import 'package:gdsctokyo/widgets/today_items.dart';

class RestaurantMyPage extends StatefulWidget {
  const RestaurantMyPage({super.key});

  @override
  State<RestaurantMyPage> createState() => _RestaurantMyPageState();
}

class _RestaurantMyPageState extends State<RestaurantMyPage> {
  int currentPage = 0;
  List<Widget> pages = [
    const Bookmark(),
    const Explore(),
    const MyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BigText(text: 'My Basket Himonya'),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              // fit: StackFit.expand,
              children: [
                Container(
                  width: double.infinity,
                  height: 160,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('lib/assets/images/sushi.png'),
                    fit: BoxFit.cover,
                  )),
                ),
                const Positioned(
                  left: 16.0,
                  bottom: 4.0,
                  child: Text(
                    'Delicious sushi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            // Container(
            //   width: double.infinity,
            //   height: 200,
            //   decoration: BoxDecoration(
            //       image: DecorationImage(
            //     image: AssetImage('lib/assets/images/sushi.png'),
            //     fit: BoxFit.cover,
            //   )),
            // ),

            const StoreInfo(),
            const TodayItems(),
            const MyItems(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: lightColorScheme.primaryContainer,
        selectedItemColor: Colors.red[300],
        items: [
          const BottomNavigationBarItem(
              icon: Icon(
                Icons.store,
              ),
              label: 'Store'),
          const BottomNavigationBarItem(
              icon: Icon(
                Icons.explore,
              ),
              label: 'Explore'),
          const BottomNavigationBarItem(
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
