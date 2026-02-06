import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthcare_booking_platform/features/auth/views/login_page_view.dart';
import 'package:healthcare_booking_platform/features/splash/views/splash_page_view.dart';

class AppRoutes {
  static GoRouter get router => _router;
  static final GoRouter _router = GoRouter(
    initialLocation: "/splash",
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
          return const SplashPageView();
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
        routes: <RouteBase>[
          //sub pages
        ],
      ),
    ],
  );
}
