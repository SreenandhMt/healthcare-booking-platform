import 'package:flutter/material.dart';
import 'package:healthcare_booking_platform/core/theme/app_theme.dart';
import 'package:healthcare_booking_platform/features/auth/view_models/auth_viewmodel.dart';
import 'package:healthcare_booking_platform/features/home/view_models/home_viewmodel.dart';
import 'package:healthcare_booking_platform/features/home/view_models/register_viewmodel.dart';
import 'package:healthcare_booking_platform/route/app_routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
      ],
      child: MaterialApp.router(
        title: 'test',
        theme: AppTheme.lightTheme,
        routerConfig: AppRoutes.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
