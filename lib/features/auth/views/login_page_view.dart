import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare_booking_platform/core/theme/app_colors.dart';

class LoginPageview extends StatelessWidget {
  const LoginPageview({super.key});

  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Image with Logo Overlay (Exact Match)
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.27,
                          width: double.infinity,
                          child: Image.asset(
                            "assets/auth_page.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Heavy Blur and Semi-transparent Overlay
                        Positioned.fill(
                          child: ClipRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 5.0,
                                sigmaY: 5.0,
                              ),
                              child: Container(
                                color: Colors.black.withOpacity(0.12),
                              ),
                            ),
                          ),
                        ),
                        Image.asset(
                          "assets/logo.png",
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              "Login Or Register To Book\nYour Appointments",
                              style: GoogleFonts.poppins(
                                fontSize: 27,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF333333),
                                height: 1.25,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              "Email",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Color(0xFF4F4F4F),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              decoration: InputDecoration(
                                hintText: "Enter your email",
                                hintStyle: GoogleFonts.poppins(
                                  color: Color(0xFF9E9E9E),
                                  fontSize: 14,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF2F2F2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 13,
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),

                            // Password Field
                            Text(
                              "Password",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Color(0xFF4F4F4F),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: "Enter password",
                                hintStyle: GoogleFonts.poppins(
                                  color: Color(0xFF9E9E9E),
                                  fontSize: 14,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF2F2F2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 13,
                                ),
                              ),
                            ),

                            if (isKeyboardOpen)
                              const SizedBox(height: 20)
                            else
                              const Spacer(flex: 2),
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  "Login",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            if (isKeyboardOpen)
                              const SizedBox(height: 20)
                            else
                              const Spacer(flex: 3),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 0.0,
                                ),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: GoogleFonts.poppins(
                                      color: Color(0xFF4F4F4F),
                                      fontSize: 12.5,
                                      height: 1.5,
                                    ),
                                    children: [
                                      const TextSpan(
                                        text:
                                            "By creating or logging into an account you are agreeing\nwith our ",
                                      ),
                                      TextSpan(
                                        text: "Terms and Conditions",
                                        style: GoogleFonts.poppins(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const TextSpan(text: " and "),
                                      TextSpan(
                                        text: "Privacy Policy.",
                                        style: GoogleFonts.poppins(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20), // Bottom padding
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
