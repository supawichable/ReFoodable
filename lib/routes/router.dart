import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:gdsctokyo/routes/guard.dart';
import 'package:gdsctokyo/screens/store_form.dart';
import 'package:gdsctokyo/screens/auth/forgot.dart';
import 'package:gdsctokyo/screens/home/bookmark.dart';
import 'package:gdsctokyo/screens/home/explore.dart';
import 'package:gdsctokyo/screens/home/my_page.dart';
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
    AutoRoute(page: HomePage, path: '/home', children: [
      AutoRoute(page: BookmarkPage, path: 'bookmark'),
      AutoRoute(page: ExplorePage, path: 'explore', initial: true),
      AutoRoute(page: MypagePage, path: 'my-page'),
    ]),
    AutoRoute(page: SplashPage, path: '/', initial: true),
    AutoRoute(page: MyStoresPage, path: '/my-stores', guards: [AuthGuard]),
    AutoRoute(
        page: StoreFormPage,
        path: '/store-form/:storeId',
        guards: [AuthGuard, StoreOwnerGuard]),
    AutoRoute(page: StorePage, path: '/store/:storeId'),
  ],
)
class $AppRouter {}

// Naming conventions:
// - Page name must end with 'Page'