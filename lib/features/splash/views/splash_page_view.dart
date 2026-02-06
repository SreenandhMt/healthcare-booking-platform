import 'package:flutter/material.dart';
import 'package:healthcare_booking_platform/core/theme/app_colors.dart';

class SplashPageView extends StatelessWidget {
  const SplashPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/splash_screen_bk.png",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.3),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(1, 4, 4, 4).withOpacity(0.4),
            ),
          ),
          Positioned(
            bottom: 0,
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset("assets/logo.png"),
          ),
        ],
      ),
    );
  }
}
