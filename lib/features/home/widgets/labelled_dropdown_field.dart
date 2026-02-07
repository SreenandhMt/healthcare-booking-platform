import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare_booking_platform/core/theme/app_colors.dart';

class LabelledDropdownField<T> extends StatelessWidget {
  final String label;
  final String hint;
  final TextStyle labelStyle;
  final List<T> items;
  final T? value;
  final String Function(T) itemLabelBuilder;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;

  const LabelledDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.labelStyle,
    required this.items,
    this.value,
    required this.itemLabelBuilder,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.poppins(textStyle: labelStyle)),
          const SizedBox(height: 10),
          DropdownButtonFormField<T>(
            isExpanded: true,
            hint: Text(
              hint,
              style: GoogleFonts.poppins(
                color: const Color(0xFFBBBBBB),
                fontSize: 13,
              ),
            ),
            initialValue: value,
            validator: validator,
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.primaryColor,
              size: 24,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF9F9F9),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFEAEAEA)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFEAEAEA)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.primaryColor),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red),
              ),
            ),
            items: items.map((T item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  itemLabelBuilder(item),
                  style: GoogleFonts.poppins(fontSize: 13, color: Colors.black),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
