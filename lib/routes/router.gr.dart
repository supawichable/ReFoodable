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
import 'package:auto_route/auto_route.dart' as _i10;
import 'package:flutter/material.dart' as _i11;

import '../models/restaurant/_restaurant.dart' as _i13;
import '../screens/edit_profile.dart' as _i5;
import '../screens/forgot.dart' as _i2;
import '../screens/home/home.dart' as _i4;
import '../screens/my_store_page.dart' as _i8;
import '../screens/my_stores.dart' as _i7;
import '../screens/reset.dart' as _i3;
import '../screens/signin.dart' as _i1;
import '../screens/splash.dart' as _i6;
import '../screens/store_page.dart' as _i9;
import 'guard.dart' as _i12;

class AppRouter extends _i10.RootStackRouter {
  AppRouter({
    _i11.GlobalKey<_i11.NavigatorState>? navigatorKey,
    required this.authGuard,
  }) : super(navigatorKey);

  final _i12.AuthGuard authGuard;

  @override
  final Map<String, _i10.PageFactory> pagesMap = {
    SignInRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.SignInPage(),
      );
    },
    ForgotPasswordRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.ForgotPasswordPage(),
      );
    },
    ResetPasswordRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i3.ResetPasswordPage(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i4.HomePage(),
      );
    },
    EditProfileRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i5.EditProfilePage(),
      );
    },
    SplashRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i6.SplashPage(),
      );
    },
    MyStoresRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i7.MyStoresPage(),
      );
    },
    MyStoreRoute.name: (routeData) {
      final args = routeData.argsAs<MyStoreRouteArgs>();
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i8.MyStorePage(
          key: args.key,
          restaurant: args.restaurant,
        ),
      );
    },
    StoreRoute.name: (routeData) {
      final args = routeData.argsAs<StoreRouteArgs>();
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i9.StorePage(
          key: args.key,
          restaurant: args.restaurant,
        ),
      );
    },
  };

  @override
  List<_i10.RouteConfig> get routes => [
        _i10.RouteConfig(
          '/#redirect',
          path: '/',
          redirectTo: '/splash',
          fullMatch: true,
        ),
        _i10.RouteConfig(
          SignInRoute.name,
          path: '/signin',
        ),
        _i10.RouteConfig(
          ForgotPasswordRoute.name,
          path: '/forgot',
        ),
        _i10.RouteConfig(
          ResetPasswordRoute.name,
          path: '/reset',
        ),
        _i10.RouteConfig(
          HomeRoute.name,
          path: '/home',
        ),
        _i10.RouteConfig(
          EditProfileRoute.name,
          path: '/edit-profile',
        ),
        _i10.RouteConfig(
          SplashRoute.name,
          path: '/splash',
        ),
        _i10.RouteConfig(
          MyStoresRoute.name,
          path: '/my-stores',
          guards: [authGuard],
        ),
        _i10.RouteConfig(
          MyStoreRoute.name,
          path: '/store/:storeId',
          guards: [authGuard],
        ),
        _i10.RouteConfig(
          StoreRoute.name,
          path: '/store/:storeId',
        ),
      ];
}

/// generated route for
/// [_i1.SignInPage]
class SignInRoute extends _i10.PageRouteInfo<void> {
  const SignInRoute()
      : super(
          SignInRoute.name,
          path: '/signin',
        );

  static const String name = 'SignInRoute';
}

/// generated route for
/// [_i2.ForgotPasswordPage]
class ForgotPasswordRoute extends _i10.PageRouteInfo<void> {
  const ForgotPasswordRoute()
      : super(
          ForgotPasswordRoute.name,
          path: '/forgot',
        );

  static const String name = 'ForgotPasswordRoute';
}

/// generated route for
/// [_i3.ResetPasswordPage]
class ResetPasswordRoute extends _i10.PageRouteInfo<void> {
  const ResetPasswordRoute()
      : super(
          ResetPasswordRoute.name,
          path: '/reset',
        );

  static const String name = 'ResetPasswordRoute';
}

/// generated route for
/// [_i4.HomePage]
class HomeRoute extends _i10.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '/home',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i5.EditProfilePage]
class EditProfileRoute extends _i10.PageRouteInfo<void> {
  const EditProfileRoute()
      : super(
          EditProfileRoute.name,
          path: '/edit-profile',
        );

  static const String name = 'EditProfileRoute';
}

/// generated route for
/// [_i6.SplashPage]
class SplashRoute extends _i10.PageRouteInfo<void> {
  const SplashRoute()
      : super(
          SplashRoute.name,
          path: '/splash',
        );

  static const String name = 'SplashRoute';
}

/// generated route for
/// [_i7.MyStoresPage]
class MyStoresRoute extends _i10.PageRouteInfo<void> {
  const MyStoresRoute()
      : super(
          MyStoresRoute.name,
          path: '/my-stores',
        );

  static const String name = 'MyStoresRoute';
}

/// generated route for
/// [_i8.MyStorePage]
class MyStoreRoute extends _i10.PageRouteInfo<MyStoreRouteArgs> {
  MyStoreRoute({
    _i11.Key? key,
    required _i13.Restaurant restaurant,
  }) : super(
          MyStoreRoute.name,
          path: '/store/:storeId',
          args: MyStoreRouteArgs(
            key: key,
            restaurant: restaurant,
          ),
        );

  static const String name = 'MyStoreRoute';
}

class MyStoreRouteArgs {
  const MyStoreRouteArgs({
    this.key,
    required this.restaurant,
  });

  final _i11.Key? key;

  final _i13.Restaurant restaurant;

  @override
  String toString() {
    return 'MyStoreRouteArgs{key: $key, restaurant: $restaurant}';
  }
}

/// generated route for
/// [_i9.StorePage]
class StoreRoute extends _i10.PageRouteInfo<StoreRouteArgs> {
  StoreRoute({
    _i11.Key? key,
    required _i13.Restaurant restaurant,
  }) : super(
          StoreRoute.name,
          path: '/store/:storeId',
          args: StoreRouteArgs(
            key: key,
            restaurant: restaurant,
          ),
        );

  static const String name = 'StoreRoute';
}

class StoreRouteArgs {
  const StoreRouteArgs({
    this.key,
    required this.restaurant,
  });

  final _i11.Key? key;

  final _i13.Restaurant restaurant;

  @override
  String toString() {
    return 'StoreRouteArgs{key: $key, restaurant: $restaurant}';
  }
}
