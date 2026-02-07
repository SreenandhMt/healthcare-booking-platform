import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare_booking_platform/core/theme/app_colors.dart';
import 'package:healthcare_booking_platform/features/home/view_models/register_viewmodel.dart';
import 'package:healthcare_booking_platform/features/home/widgets/add_treatment_dialog.dart';
import 'package:provider/provider.dart';

class TreatmentItemCard extends StatelessWidget {
  final SelectedTreatment selected;
  final int index;

  const TreatmentItemCard({
    super.key,
    required this.selected,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1F1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "${index + 1}.",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: const Color(0xFF333333),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    selected.treatment.name,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: const Color(0xFF333333),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context.read<RegisterViewModel>().removeTreatment(
                      selected.treatment.id,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF8A8A),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const SizedBox(width: 25),
                Text(
                  "Male",
                  style: GoogleFonts.poppins(
                    color: AppColors.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 10),
                _CountBox(count: selected.maleCount.toString()),
                const Spacer(),
                Text(
                  "Female",
                  style: GoogleFonts.poppins(
                    color: AppColors.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 10),
                _CountBox(count: selected.femaleCount.toString()),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: "Edit Treatment",
                      pageBuilder: (context, anim1, anim2) {
                        return AddTreatmentDialog(
                          editIndex: index,
                          initialValue: selected,
                        );
                      },
                    );
                  },
                  child: const Icon(
                    Icons.edit_outlined,
                    size: 20,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CountBox extends StatelessWidget {
  final String count;
  const _CountBox({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Text(
        count,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: const Color(0xFF333333),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
