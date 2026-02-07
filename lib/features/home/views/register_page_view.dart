import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare_booking_platform/core/theme/app_colors.dart';
import 'package:healthcare_booking_platform/features/home/models/patient_model.dart';
import 'package:healthcare_booking_platform/features/home/models/treatment_model.dart';
import 'package:healthcare_booking_platform/features/home/view_models/home_viewmodel.dart';
import 'package:healthcare_booking_platform/features/home/view_models/register_viewmodel.dart';
import 'package:healthcare_booking_platform/features/home/widgets/register_app_bar.dart';
import 'package:healthcare_booking_platform/features/home/widgets/labelled_text_field.dart';
import 'package:healthcare_booking_platform/features/home/widgets/labelled_dropdown_field.dart';
import 'package:healthcare_booking_platform/features/home/widgets/treatment_item_card.dart';
import 'package:healthcare_booking_platform/features/home/widgets/custom_radio_option.dart';
import 'package:healthcare_booking_platform/features/home/widgets/time_dropdown_field.dart';
import 'package:healthcare_booking_platform/features/home/widgets/add_treatment_dialog.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RegisterPageView extends StatefulWidget {
  const RegisterPageView({super.key});

  @override
  State<RegisterPageView> createState() => _RegisterPageViewState();
}

class _RegisterPageViewState extends State<RegisterPageView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _excecutiveController = TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();
  final TextEditingController _discountAmountController =
      TextEditingController();
  final TextEditingController _advanceAmountController =
      TextEditingController();
  final TextEditingController _balanceAmountController =
      TextEditingController();

  String? paymentOption = 'Cash';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedLocation;
  BranchModel? _selectedBranch;

  String? _treatmentError;
  String? _paymentError;
  String? _dateError;
  String? _timeError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().fetchTreatments();
      context.read<RegisterViewModel>().fetchBranches();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _excecutiveController.dispose();
    _totalAmountController.dispose();
    _discountAmountController.dispose();
    _advanceAmountController.dispose();
    _balanceAmountController.dispose();
    super.dispose();
  }

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

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateError = null;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _timeError = null;
      });
    }
  }

  Future<void> _saveForm() async {
    final registerVM = context.read<RegisterViewModel>();

    setState(() {
      _treatmentError = null;
      _paymentError = null;
      _dateError = null;
      _timeError = null;
    });

    final formValid = _formKey.currentState!.validate();
    bool hasManualError = false;

    // Manual Validations for non-Form fields
    if (registerVM.selectedTreatments.isEmpty) {
      setState(() => _treatmentError = "Please add at least one treatment");
      hasManualError = true;
    }
    if (paymentOption == null) {
      setState(() => _paymentError = "Please select a payment option");
      hasManualError = true;
    }
    if (_selectedDate == null) {
      setState(() => _dateError = "Please select treatment date");
      hasManualError = true;
    }
    if (_selectedTime == null) {
      setState(() => _timeError = "Please select treatment time");
      hasManualError = true;
    }

    if (!formValid || hasManualError) return;

    final dateStr = DateFormat('dd/MM/yyyy').format(_selectedDate!);
    final format = DateFormat('hh:mm a');
    final now = DateTime.now();
    final timeStr = format.format(
      DateTime(
        now.year,
        now.month,
        now.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      ),
    );
    final dateTimeStr = "$dateStr-$timeStr";

    final success = await registerVM.registerPatient(
      name: _nameController.text,
      excecutive: _excecutiveController.text,
      payment: paymentOption ?? "Cash",
      phone: _phoneController.text,
      address: _addressController.text,
      totalAmount: double.tryParse(_totalAmountController.text) ?? 0.0,
      discountAmount: double.tryParse(_discountAmountController.text) ?? 0.0,
      advanceAmount: double.tryParse(_advanceAmountController.text) ?? 0.0,
      balanceAmount: double.tryParse(_balanceAmountController.text) ?? 0.0,
      dateAndTime: dateTimeStr,
      branch: _selectedBranch?.id.toString() ?? "",
    );

    if (success) {
      // Create local model for immediate feedback
      final newPatient = PatientModel(
        id: 0, // Temp ID
        name: _nameController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        user: _excecutiveController
            .text, // "user" seems to mapping to executive in card UI
        payment: paymentOption ?? "Cash",
        totalAmount: double.tryParse(_totalAmountController.text) ?? 0.0,
        discountAmount: double.tryParse(_discountAmountController.text) ?? 0.0,
        advanceAmount: double.tryParse(_advanceAmountController.text) ?? 0.0,
        balanceAmount: double.tryParse(_balanceAmountController.text) ?? 0.0,
        dateNdTime: dateTimeStr,
        branch: _selectedBranch,
        patientDetailsSet: registerVM.selectedTreatments
            .map(
              (e) => PatientDetailModel(
                id: 0,
                treatment: e.treatment.id,
                treatmentName: e.treatment.name,
                male: e.maleCount.toString(),
                female: e.femaleCount.toString(),
                patient: 0,
              ),
            )
            .toList(),
        isActive: true,
      );

      if (mounted) {
        context.read<HomeViewModel>().addLocalPatient(newPatient);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Patient registered successfully")),
      );
      registerVM.clearForm();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration failed: ${registerVM.error}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const labelTextStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Color(0xFF404040),
    );

    final registerVM = context.watch<RegisterViewModel>();
    final locations = registerVM.locations;
    final branches = _selectedLocation == null
        ? []
        : registerVM.branches
              .where((b) => b.location.trim() == _selectedLocation)
              .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const RegisterAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                if (registerVM.error != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      color: Colors.red[50],
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Error loading data: ${registerVM.error}",
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => registerVM.fetchBranches(),
                            child: const Text("Retry"),
                          ),
                        ],
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: registerVM.error != null ? 10 : 25),
                        LabelledTextField(
                          label: "Name",
                          hint: "Enter your full name",
                          labelStyle: labelTextStyle,
                          controller: _nameController,
                          validator: (val) =>
                              (val == null || val.trim().isEmpty)
                              ? "Name is required"
                              : null,
                        ),
                        LabelledTextField(
                          label: "Excecutive",
                          hint: "Enter excecutive name",
                          labelStyle: labelTextStyle,
                          controller: _excecutiveController,
                          validator: (val) =>
                              (val == null || val.trim().isEmpty)
                              ? "Executive name is required"
                              : null,
                        ),
                        LabelledTextField(
                          label: "Whatsapp Number",
                          hint: "Enter your Whatsapp number",
                          labelStyle: labelTextStyle,
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          validator: (val) =>
                              (val == null || val.trim().isEmpty)
                              ? "Whatsapp number is required"
                              : null,
                        ),
                        LabelledTextField(
                          label: "Address",
                          hint: "Enter your full address",
                          labelStyle: labelTextStyle,
                          controller: _addressController,
                          validator: (val) =>
                              (val == null || val.trim().isEmpty)
                              ? "Address is required"
                              : null,
                        ),
                        LabelledDropdownField<String>(
                          label: "Location",
                          hint: registerVM.isBranchLoading
                              ? "Loading..."
                              : "Choose your location",
                          labelStyle: labelTextStyle,
                          items: locations,
                          value: _selectedLocation,
                          itemLabelBuilder: (l) => l,
                          onChanged: (val) {
                            setState(() {
                              _selectedLocation = val;
                              _selectedBranch = null;
                            });
                          },
                          validator: (val) =>
                              val == null ? "Location is required" : null,
                        ),
                        LabelledDropdownField<BranchModel>(
                          label: "Branch",
                          hint: registerVM.isBranchLoading
                              ? "Loading..."
                              : (_selectedLocation == null
                                    ? "Select Location First"
                                    : "Select the branch"),
                          labelStyle: labelTextStyle,
                          items: branches.cast<BranchModel>(),
                          value: _selectedBranch,
                          itemLabelBuilder: (b) => b.name,
                          onChanged: (val) =>
                              setState(() => _selectedBranch = val),
                          validator: (val) =>
                              val == null ? "Branch is required" : null,
                        ),

                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            "Treatments",
                            style: GoogleFonts.poppins(
                              textStyle: labelTextStyle,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        if (registerVM.selectedTreatments.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F1F1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  "No treatments added yet",
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          )
                        else
                          ...registerVM.selectedTreatments.asMap().entries.map((
                            entry,
                          ) {
                            return TreatmentItemCard(
                              selected: entry.value,
                              index: entry.key,
                            );
                          }),

                        if (_treatmentError != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 8,
                            ),
                            child: Text(
                              _treatmentError!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),

                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () {
                                _showAddTreatmentDialog();
                                setState(() => _treatmentError = null);
                              },
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
                          hint: "0.0",
                          labelStyle: labelTextStyle,
                          controller: _totalAmountController,
                          keyboardType: TextInputType.number,
                          validator: (val) =>
                              (val == null || val.trim().isEmpty)
                              ? "Total amount is required"
                              : null,
                        ),
                        LabelledTextField(
                          label: "Discount Amount",
                          hint: "0.0",
                          labelStyle: labelTextStyle,
                          controller: _discountAmountController,
                          keyboardType: TextInputType.number,
                          validator: (val) =>
                              (val == null || val.trim().isEmpty)
                              ? "Discount is required"
                              : null,
                        ),

                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            "Payment Option",
                            style: GoogleFonts.poppins(
                              textStyle: labelTextStyle,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomRadioOption(
                                    value: "Cash",
                                    groupValue: paymentOption,
                                    onChanged: (val) => setState(() {
                                      paymentOption = val;
                                      _paymentError = null;
                                    }),
                                  ),
                                  CustomRadioOption(
                                    value: "Card",
                                    groupValue: paymentOption,
                                    onChanged: (val) => setState(() {
                                      paymentOption = val;
                                      _paymentError = null;
                                    }),
                                  ),
                                  CustomRadioOption(
                                    value: "UPI",
                                    groupValue: paymentOption,
                                    onChanged: (val) => setState(() {
                                      paymentOption = val;
                                      _paymentError = null;
                                    }),
                                  ),
                                ],
                              ),
                              if (_paymentError != null)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    left: 10,
                                  ),
                                  child: Text(
                                    _paymentError!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                        LabelledTextField(
                          label: "Advance Amount",
                          hint: "0.0",
                          labelStyle: labelTextStyle,
                          controller: _advanceAmountController,
                          keyboardType: TextInputType.number,
                          validator: (val) =>
                              (val == null || val.trim().isEmpty)
                              ? "Advance is required"
                              : null,
                        ),
                        LabelledTextField(
                          label: "Balance Amount",
                          hint: "0.0",
                          labelStyle: labelTextStyle,
                          controller: _balanceAmountController,
                          keyboardType: TextInputType.number,
                          validator: (val) =>
                              (val == null || val.trim().isEmpty)
                              ? "Balance is required"
                              : null,
                        ),

                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            "Treatment Date",
                            style: GoogleFonts.poppins(
                              textStyle: labelTextStyle,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: _selectDate,
                          child: Container(
                            height: 48,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9F9F9),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFFEAEAEA),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedDate == null
                                      ? "Select Date"
                                      : DateFormat(
                                          'dd/MM/yyyy',
                                        ).format(_selectedDate!),
                                  style: TextStyle(
                                    color: _selectedDate == null
                                        ? const Color(0xFF999999)
                                        : Colors.black,
                                  ),
                                ),
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 18,
                                  color: AppColors.primaryColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_dateError != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 8,
                            ),
                            child: Text(
                              _dateError!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),

                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            "Treatment Time",
                            style: GoogleFonts.poppins(
                              textStyle: labelTextStyle,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TimeDropdownField(
                                  label: "Hour",
                                  value: _selectedTime?.hourOfPeriod
                                      .toString()
                                      .padLeft(2, '0'),
                                  onTap: _selectTime,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TimeDropdownField(
                                  label: "Minutes",
                                  value: _selectedTime?.minute
                                      .toString()
                                      .padLeft(2, '0'),
                                  onTap: _selectTime,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_timeError != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 8,
                            ),
                            child: Text(
                              _timeError!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),

                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (registerVM.isLoading)
            const Center(child: CircularProgressIndicator()),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: registerVM.isLoading ? null : _saveForm,
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
          ),
        ],
      ),
    );
  }
}
