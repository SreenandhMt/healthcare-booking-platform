import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare_booking_platform/core/theme/app_colors.dart';

class BookingCardWidget extends StatelessWidget {
  const BookingCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "1.",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF333333),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Vikram Singh",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Couple Combo Package (Rejuven...)",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.primaryColor.withOpacity(0.8),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                            color: Colors.redAccent,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "31/01/2024",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: const Color(0xFF666666),
                            ),
                          ),
                          const SizedBox(width: 20),
                          const Icon(
                            Icons.people_outline,
                            size: 18,
                            color: Colors.redAccent,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Jithesh",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: const Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "View Booking details",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFF333333),
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.primaryColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
