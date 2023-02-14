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
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:flutter/material.dart' as _i4;

import '../screens/debug.dart' as _i2;
import '../screens/signin.dart' as _i1;

class AppRouter extends _i3.RootStackRouter {
  AppRouter([_i4.GlobalKey<_i4.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i3.PageFactory> pagesMap = {
    SignInRoute.name: (routeData) {
      return _i3.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.SignInPage(),
      );
    },
    DebugRoute.name: (routeData) {
      return _i3.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.DebugPage(),
      );
    },
  };

  @override
  List<_i3.RouteConfig> get routes => [
        _i3.RouteConfig(
          '/#redirect',
          path: '/',
          redirectTo: '/debug',
          fullMatch: true,
        ),
        _i3.RouteConfig(
          SignInRoute.name,
          path: '/signin',
        ),
        _i3.RouteConfig(
          DebugRoute.name,
          path: '/debug',
        ),
      ];
}

/// generated route for
/// [_i1.SignInPage]
class SignInRoute extends _i3.PageRouteInfo<void> {
  const SignInRoute()
      : super(
          SignInRoute.name,
          path: '/signin',
        );

  static const String name = 'SignInRoute';
}

/// generated route for
/// [_i2.DebugPage]
class DebugRoute extends _i3.PageRouteInfo<void> {
  const DebugRoute()
      : super(
          DebugRoute.name,
          path: '/debug',
        );

  static const String name = 'DebugRoute';
}
