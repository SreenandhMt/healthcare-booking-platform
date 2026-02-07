import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare_booking_platform/core/theme/app_colors.dart';
import 'package:healthcare_booking_platform/features/home/models/treatment_model.dart';
import 'package:healthcare_booking_platform/features/home/view_models/home_viewmodel.dart';
import 'package:healthcare_booking_platform/features/home/view_models/register_viewmodel.dart';
import 'package:provider/provider.dart';

class AddTreatmentDialog extends StatefulWidget {
  final int? editIndex;
  final SelectedTreatment? initialValue;

  const AddTreatmentDialog({super.key, this.editIndex, this.initialValue});

  @override
  State<AddTreatmentDialog> createState() => _AddTreatmentDialogState();
}

class _AddTreatmentDialogState extends State<AddTreatmentDialog> {
  late int maleCount;
  late int femaleCount;
  late TreatmentModel? selectedTreatment;
  String? treatmentError;
  String? patientError;

  @override
  void initState() {
    super.initState();
    maleCount = widget.initialValue?.maleCount ?? 0;
    femaleCount = widget.initialValue?.femaleCount ?? 0;
    selectedTreatment = widget.initialValue?.treatment;
  }

  @override
  Widget build(BuildContext context) {
    final homeVM = context.watch<HomeViewModel>();

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(24),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Choose Treatment",
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFEAEAEA)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<TreatmentModel>(
                    isExpanded: true,
                    hint: Text(
                      "Choose preferred treatment",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFBBBBBB),
                        fontSize: 13,
                      ),
                    ),
                    value: selectedTreatment,
                    // If editing, usually we don't change the treatment, but we can allow it
                    items: homeVM.treatments.map((treatment) {
                      return DropdownMenuItem(
                        value: treatment,
                        child: Text(
                          treatment.name,
                          style: GoogleFonts.poppins(fontSize: 13),
                        ),
                      );
                    }).toList(),
                    onChanged: widget.editIndex != null
                        ? null
                        : (val) {
                            setState(() {
                              selectedTreatment = val;
                              treatmentError = null;
                            });
                          },
                  ),
                ),
              ),
              if (treatmentError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 4),
                  child: Text(
                    treatmentError!,
                    style: GoogleFonts.poppins(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 24),
              Text(
                "Add Patients",
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 16),
              _PatientCountRow(
                label: "Male",
                count: maleCount,
                onIncrement: () => setState(() {
                  maleCount++;
                  patientError = null;
                }),
                onDecrement: () => setState(() {
                  maleCount = maleCount > 0 ? maleCount - 1 : 0;
                  patientError = null;
                }),
              ),
              const SizedBox(height: 16),
              _PatientCountRow(
                label: "Female",
                count: femaleCount,
                onIncrement: () => setState(() {
                  femaleCount++;
                  patientError = null;
                }),
                onDecrement: () => setState(() {
                  femaleCount = femaleCount > 0 ? femaleCount - 1 : 0;
                  patientError = null;
                }),
              ),
              if (patientError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 4),
                  child: Text(
                    patientError!,
                    style: GoogleFonts.poppins(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      treatmentError = null;
                      patientError = null;
                    });

                    if (selectedTreatment != null &&
                        (maleCount > 0 || femaleCount > 0)) {
                      if (widget.editIndex != null) {
                        context.read<RegisterViewModel>().updateTreatment(
                          widget.editIndex!,
                          maleCount,
                          femaleCount,
                        );
                      } else {
                        context.read<RegisterViewModel>().addTreatment(
                          selectedTreatment!,
                          maleCount,
                          femaleCount,
                        );
                      }
                      Navigator.pop(context);
                    } else {
                      setState(() {
                        if (selectedTreatment == null) {
                          treatmentError = "Please select a treatment";
                        }
                        if (maleCount == 0 && femaleCount == 0) {
                          patientError = "Please add at least one patient";
                        }
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Save",
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PatientCountRow extends StatelessWidget {
  final String label;
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _PatientCountRow({
    required this.label,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F1F1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFEAEAEA)),
            ),
            child: Text(
              label,
              style: GoogleFonts.poppins(
                color: const Color(0xFF333333),
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        _CircleButton(icon: Icons.remove, onTap: onDecrement),
        const SizedBox(width: 12),
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E2E2)),
          ),
          child: Text(
            count.toString(),
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        _CircleButton(icon: Icons.add, onTap: onIncrement),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: AppColors.primaryColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x1F000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}
