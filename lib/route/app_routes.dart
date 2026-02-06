import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthcare_booking_platform/features/auth/views/login_page_view.dart';
import 'package:healthcare_booking_platform/features/home/views/home_page_view.dart';
import 'package:healthcare_booking_platform/features/home/views/register_page_view.dart';
import 'package:healthcare_booking_platform/features/splash/views/splash_page_view.dart';

class AppRoutes {
  static GoRouter get router => _router;
  static final GoRouter _router = GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(
        path: '/splash',
        builder: (BuildContext context, GoRouterState state) {
          return SplashPageView();
        },
        routes: <RouteBase>[
          //sub pages
        ],
      ),
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePageView();
        },
        routes: <RouteBase>[
          //sub pages
        ],
      ),
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPageview();
        },
      ),
      GoRoute(
        path: '/register',
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterPageView();
        },
      ),
    ],
  );
}
