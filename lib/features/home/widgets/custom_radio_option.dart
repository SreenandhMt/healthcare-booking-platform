import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare_booking_platform/core/theme/app_colors.dart';

class CustomRadioOption extends StatelessWidget {
  final String value;
  final String? groupValue;
  final ValueChanged<String?> onChanged;

  const CustomRadioOption({
    super.key,
    required this.value,
    this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: value,
          side: const BorderSide(width: 0.8),
          groupValue: groupValue,
          activeColor: AppColors.primaryColor,
          onChanged: onChanged,
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: const Color(0xFF333333),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
