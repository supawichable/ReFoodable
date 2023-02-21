import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:gdsctokyo/screens/edit_profile.dart';
import 'package:gdsctokyo/screens/forgot.dart';
import 'package:gdsctokyo/screens/reset.dart';
import 'package:gdsctokyo/screens/home/home.dart';
import 'package:gdsctokyo/screens/signin.dart';
import 'package:gdsctokyo/screens/splash.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: SignInPage, path: '/signin'),
    AutoRoute(page: ForgotPasswordPage, path: '/forgot'),
    AutoRoute(page: ResetPasswordPage, path: '/reset'),
    AutoRoute(page: HomePage, path: '/home'),
    AutoRoute(page: EditProfilePage, path: '/edit-profile'),
    AutoRoute(page: SplashPage, path: '/splash', initial: true),
  ],
)
class $AppRouter {}

// Naming conventions:
// - Page name must end with 'Page'