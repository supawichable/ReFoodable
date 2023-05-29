import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/routes/router.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static List<String> titles = ['Saved', 'Explore', 'My Page'];

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        BookmarkRoute(),
        ExploreRoute(),
        MypageRoute(),
      ],
      transitionBuilder: (context, child, animation) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
            appBar: AppBar(
              title: Text(titles[tabsRouter.activeIndex]),
              elevation: 2,
              actions: [
                if (tabsRouter.activeIndex == 2)
                  IconButton(
                    onPressed: () {
                      context.router.push(const SettingsRoute());
                    },
                    icon: const Icon(Icons.settings_outlined),
                  ),
              ],
            ),
            body: SlideTransition(
              position: animation.drive(
                Tween(
                  begin: tabsRouter.previousIndex == tabsRouter.activeIndex
                      ? const Offset(0, 0)
                      : tabsRouter.previousIndex! > tabsRouter.activeIndex
                          ? const Offset(-1, 0)
                          : const Offset(1, 0),
                  end: const Offset(0, 0),
                ).chain(
                  CurveTween(curve: Curves.ease),
                ),
              ),
              child: child,
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: tabsRouter.activeIndex,
              onTap: (index) {
                tabsRouter.setActiveIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.bookmark_outline,
                    ),
                    label: 'Saved'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.explore_outlined,
                    ),
                    label: 'Explore'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.account_circle_outlined,
                    ),
                    label: 'My Page'),
              ],
            ));
      },
    );
  }
}
