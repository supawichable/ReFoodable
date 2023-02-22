// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:flutter/material.dart' as _i10;

import '../models/store/_store.dart' as _i12;
import '../screens/auth/forgot.dart' as _i2;
import '../screens/auth/reset.dart' as _i3;
import '../screens/auth/signin.dart' as _i1;
import '../screens/home/home.dart' as _i4;
import '../screens/my_store_page.dart' as _i7;
import '../screens/my_stores.dart' as _i6;
import '../screens/splash.dart' as _i5;
import '../screens/store_page.dart' as _i8;
import 'guard.dart' as _i11;

class AppRouter extends _i9.RootStackRouter {
  AppRouter({
    _i10.GlobalKey<_i10.NavigatorState>? navigatorKey,
    required this.authGuard,
  }) : super(navigatorKey);

  final _i11.AuthGuard authGuard;

  @override
  final Map<String, _i9.PageFactory> pagesMap = {
    SignInRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.SignInPage(),
      );
    },
    ForgotPasswordRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.ForgotPasswordPage(),
      );
    },
    ResetPasswordRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i3.ResetPasswordPage(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i4.HomePage(),
      );
    },
    SplashRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i5.SplashPage(),
      );
    },
    MyStoresRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i6.MyStoresPage(),
      );
    },
    MyStoreRoute.name: (routeData) {
      final args = routeData.argsAs<MyStoreRouteArgs>();
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i7.MyStorePage(
          key: args.key,
          store: args.store,
        ),
      );
    },
    StoreRoute.name: (routeData) {
      final args = routeData.argsAs<StoreRouteArgs>();
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i8.StorePage(
          key: args.key,
          store: args.store,
        ),
      );
    },
  };

  @override
  List<_i9.RouteConfig> get routes => [
        _i9.RouteConfig(
          '/#redirect',
          path: '/',
          redirectTo: '/splash',
          fullMatch: true,
        ),
        _i9.RouteConfig(
          SignInRoute.name,
          path: '/signin',
        ),
        _i9.RouteConfig(
          ForgotPasswordRoute.name,
          path: '/forgot',
        ),
        _i9.RouteConfig(
          ResetPasswordRoute.name,
          path: '/reset',
        ),
        _i9.RouteConfig(
          HomeRoute.name,
          path: '/home',
        ),
        _i9.RouteConfig(
          SplashRoute.name,
          path: '/splash',
        ),
        _i9.RouteConfig(
          MyStoresRoute.name,
          path: '/my-stores',
          guards: [authGuard],
        ),
        _i9.RouteConfig(
          MyStoreRoute.name,
          path: '/store/:storeId',
          guards: [authGuard],
        ),
        _i9.RouteConfig(
          StoreRoute.name,
          path: '/store/:storeId',
        ),
      ];
}

/// generated route for
/// [_i1.SignInPage]
class SignInRoute extends _i9.PageRouteInfo<void> {
  const SignInRoute()
      : super(
          SignInRoute.name,
          path: '/signin',
        );

  static const String name = 'SignInRoute';
}

/// generated route for
/// [_i2.ForgotPasswordPage]
class ForgotPasswordRoute extends _i9.PageRouteInfo<void> {
  const ForgotPasswordRoute()
      : super(
          ForgotPasswordRoute.name,
          path: '/forgot',
        );

  static const String name = 'ForgotPasswordRoute';
}

/// generated route for
/// [_i3.ResetPasswordPage]
class ResetPasswordRoute extends _i9.PageRouteInfo<void> {
  const ResetPasswordRoute()
      : super(
          ResetPasswordRoute.name,
          path: '/reset',
        );

  static const String name = 'ResetPasswordRoute';
}

/// generated route for
/// [_i4.HomePage]
class HomeRoute extends _i9.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '/home',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i5.SplashPage]
class SplashRoute extends _i9.PageRouteInfo<void> {
  const SplashRoute()
      : super(
          SplashRoute.name,
          path: '/splash',
        );

  static const String name = 'SplashRoute';
}

/// generated route for
/// [_i6.MyStoresPage]
class MyStoresRoute extends _i9.PageRouteInfo<void> {
  const MyStoresRoute()
      : super(
          MyStoresRoute.name,
          path: '/my-stores',
        );

  static const String name = 'MyStoresRoute';
}

/// generated route for
/// [_i7.MyStorePage]
class MyStoreRoute extends _i9.PageRouteInfo<MyStoreRouteArgs> {
  MyStoreRoute({
    _i10.Key? key,
    required _i12.Store store,
  }) : super(
          MyStoreRoute.name,
          path: '/store/:storeId',
          args: MyStoreRouteArgs(
            key: key,
            store: store,
          ),
        );

  static const String name = 'MyStoreRoute';
}

class MyStoreRouteArgs {
  const MyStoreRouteArgs({
    this.key,
    required this.store,
  });

  final _i10.Key? key;

  final _i12.Store store;

  @override
  String toString() {
    return 'MyStoreRouteArgs{key: $key, store: $store}';
  }
}

/// generated route for
/// [_i8.StorePage]
class StoreRoute extends _i9.PageRouteInfo<StoreRouteArgs> {
  StoreRoute({
    _i10.Key? key,
    required _i12.Store store,
  }) : super(
          StoreRoute.name,
          path: '/store/:storeId',
          args: StoreRouteArgs(
            key: key,
            store: store,
          ),
        );

  static const String name = 'StoreRoute';
}

class StoreRouteArgs {
  const StoreRouteArgs({
    this.key,
    required this.store,
  });

  final _i10.Key? key;

  final _i12.Store store;

  @override
  String toString() {
    return 'StoreRouteArgs{key: $key, store: $store}';
  }
}
