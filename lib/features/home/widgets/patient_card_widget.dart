import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare_booking_platform/core/theme/app_colors.dart';
import 'package:healthcare_booking_platform/features/home/models/patient_model.dart';
import 'package:intl/intl.dart';

class PatientCardWidget extends StatelessWidget {
  final PatientModel patient;
  final int index;

  const PatientCardWidget({
    super.key,
    required this.patient,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    // Format date for display
    String formattedDate = "N/A";
    if (patient.dateNdTime.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(patient.dateNdTime);
        formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
      } catch (_) {
        // Fallback for non-ISO formats: just take the date part
        formattedDate = patient.dateNdTime.split('-').first.trim();
        if (formattedDate.contains('T')) {
          formattedDate = formattedDate.split('T').first.trim();
        }
      }
    }

    // Improved treatment display logic
    String treatmentsStr = "No treatment details found";

    // Filter out items with empty treatment names
    final validTreatments = patient.patientDetailsSet
        .where((e) => e.treatmentName.trim().isNotEmpty)
        .toList();

    if (validTreatments.isNotEmpty) {
      if (validTreatments.length > 1) {
        // User requested to show "Couple Combo Package (treatments...)" if multiple
        final treatmentNames = validTreatments
            .map((e) => e.treatmentName)
            .join(', ');
        treatmentsStr = "Couple Combo Package ($treatmentNames)";
      } else {
        treatmentsStr = validTreatments.first.treatmentName;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${patient.index}.",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient.name.isNotEmpty
                            ? patient.name
                            : "Unknown Patient",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        treatmentsStr,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 16,
                                color: Color(0xFFFF5722),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                formattedDate,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: const Color(0xFF707070),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.people_outline,
                                  size: 20,
                                  color: Color(0xFFFF5722),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    patient.user.isNotEmpty
                                        ? patient.user
                                        : "N/A",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: const Color(0xFF707070),
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
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
          const Divider(height: 1, thickness: 1, color: Color(0xFFD9D9D9)),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 14.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "View Booking details",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.primaryColor,
                  size: 24,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
