import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare_booking_platform/core/theme/app_colors.dart';

class TimeDropdownField extends StatelessWidget {
  final String label;

  const TimeDropdownField({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: const Color(0xFFBBBBBB),
              fontSize: 13,
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.primaryColor,
            size: 24,
          ),
        ],
      ),
    );
  }
}
