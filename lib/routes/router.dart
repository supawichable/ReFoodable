import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:gdsctokyo/screens/home.dart';
import 'package:gdsctokyo/screens/signin.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: SignInPage, path: '/signin'),
    AutoRoute(page: HomePage, path: '/home', initial: true)
  ],
)
class $AppRouter {}

// Naming conventions:
// - Page name must end with 'Page'