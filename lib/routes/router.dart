import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:gdsctokyo/routes/guard.dart';
import 'package:gdsctokyo/screens/auth/forgot.dart';
import 'package:gdsctokyo/screens/my_store_page.dart';
import 'package:gdsctokyo/screens/my_stores.dart';
import 'package:gdsctokyo/screens/auth/reset.dart';
import 'package:gdsctokyo/screens/home/home.dart';
import 'package:gdsctokyo/screens/auth/signin.dart';
import 'package:gdsctokyo/screens/splash.dart';
import 'package:gdsctokyo/screens/store_page.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: SignInPage, path: '/signin'),
    AutoRoute(page: ForgotPasswordPage, path: '/forgot'),
    AutoRoute(page: ResetPasswordPage, path: '/reset'),
    AutoRoute(page: HomePage, path: '/home'),
    AutoRoute(page: SplashPage, path: '/splash', initial: true),
    AutoRoute(page: MyStoresPage, path: '/my-stores', guards: [AuthGuard]),
    AutoRoute(page: MyStorePage, path: '/store/:storeId', guards: [AuthGuard]),
    AutoRoute(page: StorePage, path: '/store/:storeId'),
  ],
)
class $AppRouter {}

// Naming conventions:
// - Page name must end with 'Page'