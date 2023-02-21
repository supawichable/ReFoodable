import 'package:flutter/material.dart';
import 'package:gdsctokyo/home/explore.dart';
import 'package:gdsctokyo/home/my_page.dart';
import 'package:gdsctokyo/home/restaurant.dart';
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
    RestaurantPage(),
    Explore(),
    MyPage(),
  ];

  // titles = ['Restaurant', 'Explore', 'My Page']

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
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('lib/assets/images/sushi.png'),
                    fit: BoxFit.cover,
                  )),
                ),
                Positioned(
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

            StoreInfo(),
            TodayItems(),
            MyItems(),
          ],
        ),
      ),
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
