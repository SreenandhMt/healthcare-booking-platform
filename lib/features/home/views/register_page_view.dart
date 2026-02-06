import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare_booking_platform/core/theme/app_colors.dart';
import 'package:healthcare_booking_platform/features/home/widgets/register_app_bar.dart';
import 'package:healthcare_booking_platform/features/home/widgets/labelled_text_field.dart';
import 'package:healthcare_booking_platform/features/home/widgets/labelled_dropdown_field.dart';
import 'package:healthcare_booking_platform/features/home/widgets/treatment_item_card.dart';
import 'package:healthcare_booking_platform/features/home/widgets/custom_radio_option.dart';
import 'package:healthcare_booking_platform/features/home/widgets/time_dropdown_field.dart';
import 'package:healthcare_booking_platform/features/home/widgets/add_treatment_dialog.dart';

class RegisterPageView extends StatefulWidget {
  const RegisterPageView({super.key});

  @override
  State<RegisterPageView> createState() => _RegisterPageViewState();
}

class _RegisterPageViewState extends State<RegisterPageView> {
  String? paymentOption = 'Cash';

  void _showAddTreatmentDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Add Treatment",
      pageBuilder: (context, anim1, anim2) {
        return const AddTreatmentDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const labelTextStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Color(0xFF404040),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const RegisterAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  LabelledTextField(
                    label: "Name",
                    hint: "Enter your full name",
                    labelStyle: labelTextStyle,
                  ),
                  LabelledTextField(
                    label: "Whatsapp Number",
                    hint: "Enter your Whatsapp number",
                    labelStyle: labelTextStyle,
                  ),
                  LabelledTextField(
                    label: "Address",
                    hint: "Enter your full address",
                    labelStyle: labelTextStyle,
                  ),
                  LabelledDropdownField(
                    label: "Location",
                    hint: "Choose your location",
                    labelStyle: labelTextStyle,
                  ),
                  LabelledDropdownField(
                    label: "Branch",
                    hint: "Select the branch",
                    labelStyle: labelTextStyle,
                  ),

                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Treatments",
                      style: GoogleFonts.poppins(textStyle: labelTextStyle),
                    ),
                  ),
                  const SizedBox(height: 12),

                  const TreatmentItemCard(),

                  const SizedBox(height: 16),
                  // Add Treatment Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _showAddTreatmentDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE2F0E5),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add,
                              color: Colors.black,
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Add Treatments",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  LabelledTextField(
                    label: "Total Amount",
                    hint: "",
                    labelStyle: labelTextStyle,
                  ),
                  LabelledTextField(
                    label: "Discount Amount",
                    hint: "",
                    labelStyle: labelTextStyle,
                  ),

                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Payment Option",
                      style: GoogleFonts.poppins(textStyle: labelTextStyle),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomRadioOption(
                          value: "Cash",
                          groupValue: paymentOption,
                          onChanged: (val) =>
                              setState(() => paymentOption = val),
                        ),
                        CustomRadioOption(
                          value: "Card",
                          groupValue: paymentOption,
                          onChanged: (val) =>
                              setState(() => paymentOption = val),
                        ),
                        CustomRadioOption(
                          value: "UPI",
                          groupValue: paymentOption,
                          onChanged: (val) =>
                              setState(() => paymentOption = val),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  LabelledTextField(
                    label: "Advance Amount",
                    hint: "",
                    labelStyle: labelTextStyle,
                  ),
                  LabelledTextField(
                    label: "Balance Amount",
                    hint: "",
                    labelStyle: labelTextStyle,
                  ),

                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Treatment Date",
                      style: GoogleFonts.poppins(textStyle: labelTextStyle),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 48,
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9F9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFEAEAEA)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("", style: TextStyle(color: Color(0xFF999999))),
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 18,
                          color: AppColors.primaryColor,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Treatment Time",
                      style: GoogleFonts.poppins(textStyle: labelTextStyle),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Row(
                      children: [
                        Expanded(child: TimeDropdownField(label: "Hour")),
                        SizedBox(width: 16),
                        Expanded(child: TimeDropdownField(label: "Minutes")),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
            // Bottom Save Button
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {},
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
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
