import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gdsctokyo/routes/guard.dart';
import 'package:gdsctokyo/screens/settings.dart';
import 'package:gdsctokyo/screens/store/store_form.dart';
import 'package:gdsctokyo/screens/auth/forgot.dart';
import 'package:gdsctokyo/screens/home/bookmark.dart';
import 'package:gdsctokyo/screens/home/explore.dart';
import 'package:gdsctokyo/screens/home/my_page.dart';
import 'package:gdsctokyo/screens/store/my_stores.dart';
import 'package:gdsctokyo/screens/auth/reset.dart';
import 'package:gdsctokyo/screens/home/home.dart';
import 'package:gdsctokyo/screens/auth/signin.dart';
import 'package:gdsctokyo/screens/splash.dart';
import 'package:gdsctokyo/screens/store/store_location.dart';
import 'package:gdsctokyo/screens/store/store_page.dart';
import 'package:gdsctokyo/screens/store/store_page_my_item.dart';
import 'package:gdsctokyo/screens/store/store_page_today_item.dart';
import 'package:gdsctokyo/screens/store/store_verification_form.dart';

part 'router.gr.dart';

@AutoRouterConfig(
  replaceInRouteName: 'Page,Route',
)
class AppRouter extends _$AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SignInRoute.page, path: '/signin'),
        AutoRoute(page: ForgotPasswordRoute.page, path: '/forgot'),
        AutoRoute(page: ResetPasswordRoute.page, path: '/reset'),
        AutoRoute(page: SettingsRoute.page, path: '/settings'),
        AutoRoute(page: HomeRoute.page, path: '/home', children: [
          AutoRoute(page: BookmarkRoute.page, path: 'bookmark'),
          AutoRoute(
            page: ExploreRoute.page,
            path: '',
          ),
          AutoRoute(page: MypageRoute.page, path: 'my-page'),
        ]),
        AutoRoute(page: SplashRoute.page, path: '/'),
        AutoRoute(
            page: MyStoresRoute.page,
            path: '/my-stores',
            guards: [AuthGuard()]),
        AutoRoute(
            page: StoreFormRoute.page,
            path: '/store-form/:storeId',
            guards: [AuthGuard()]),
        AutoRoute(page: StoreRoute.page, path: '/store/:storeId'),
        AutoRoute(
            page: StoreTodayItemRoute.page, path: '/store/:storeId/today-item'),
        AutoRoute(page: StoreMyItemRoute.page, path: '/store/:storeId/my-item'),
        AutoRoute(page: StoreLocationRoute.page, path: '/store-location'),
        AutoRoute(
            page: StoreVerificationFormRoute.page,
            path: '/store/:storeId/verify'),
      ];
}

// Naming conventions:
// - Page name must end with 'Page'
