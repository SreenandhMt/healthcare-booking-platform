import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare_booking_platform/core/theme/app_colors.dart';

class TimeDropdownField extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final String? value;

  const TimeDropdownField({
    super.key,
    required this.label,
    this.onTap,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              value ?? label,
              style: GoogleFonts.poppins(
                color: value == null ? const Color(0xFFBBBBBB) : Colors.black,
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
      ),
    );
  }
}
