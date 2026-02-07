import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthcare_booking_platform/core/theme/app_colors.dart';
import 'package:healthcare_booking_platform/features/auth/view_models/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class SplashPageView extends StatefulWidget {
  const SplashPageView({super.key});

  @override
  State<SplashPageView> createState() => _SplashPageViewState();
}

class _SplashPageViewState extends State<SplashPageView> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Artificial delay for splash screen visibility
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    final token = await authVM.getToken();

    if (!mounted) return;

    if (token != null) {
      context.go('/');
    } else {
      context.go('/login');
    }
  }

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
              color: const Color.fromARGB(1, 4, 4, 4).withOpacity(0.4),
            ),
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            bottom: 0,
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                "assets/logo.png",
                width: 150, // Added explicit width to control logo size
                height: 150,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
