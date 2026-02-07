import 'package:flutter/material.dart';
import 'package:healthcare_booking_platform/core/services/home_data_service.dart';
import 'package:healthcare_booking_platform/features/home/models/treatment_model.dart';

class SelectedTreatment {
  final TreatmentModel treatment;
  int maleCount;
  int femaleCount;

  SelectedTreatment({
    required this.treatment,
    this.maleCount = 0,
    this.femaleCount = 0,
  });

  SelectedTreatment copyWith({
    TreatmentModel? treatment,
    int? maleCount,
    int? femaleCount,
  }) {
    return SelectedTreatment(
      treatment: treatment ?? this.treatment,
      maleCount: maleCount ?? this.maleCount,
      femaleCount: femaleCount ?? this.femaleCount,
    );
  }
}

class RegisterViewModel extends ChangeNotifier {
  final List<SelectedTreatment> _selectedTreatments = [];
  List<SelectedTreatment> get selectedTreatments => _selectedTreatments;

  List<BranchModel> _branches = [];
  List<BranchModel> get branches => _branches;

  List<String> get locations =>
      _branches
          .map((e) => e.location.trim())
          .where((l) => l.isNotEmpty)
          .toSet()
          .toList()
        ..sort();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isBranchLoading = false;
  bool get isBranchLoading => _isBranchLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchBranches() async {
    _isBranchLoading = true;
    _error = null;
    notifyListeners();
    try {
      _branches = await HomeDataServices.getBranches();
      debugPrint("Fetched ${_branches.length} branches");
      _isBranchLoading = false;
      notifyListeners();
    } catch (e) {
      _isBranchLoading = false;
      _error = e.toString();
      debugPrint("Error fetching branches: $e");
      notifyListeners();
    }
  }

  void addTreatment(TreatmentModel treatment, int male, int female) {
    final index = _selectedTreatments.indexWhere(
      (e) => e.treatment.id == treatment.id,
    );
    if (index != -1) {
      _selectedTreatments[index].maleCount += male;
      _selectedTreatments[index].femaleCount += female;
    } else {
      _selectedTreatments.add(
        SelectedTreatment(
          treatment: treatment,
          maleCount: male,
          femaleCount: female,
        ),
      );
    }
    notifyListeners();
  }

  void updateTreatment(int index, int male, int female) {
    if (index >= 0 && index < _selectedTreatments.length) {
      _selectedTreatments[index].maleCount = male;
      _selectedTreatments[index].femaleCount = female;
      notifyListeners();
    }
  }

  void removeTreatment(int id) {
    _selectedTreatments.removeWhere((e) => e.treatment.id == id);
    notifyListeners();
  }

  void clearForm() {
    _selectedTreatments.clear();
    notifyListeners();
  }

  Future<bool> registerPatient({
    required String name,
    required String excecutive,
    required String payment,
    required String phone,
    required String address,
    required double totalAmount,
    required double discountAmount,
    required double advanceAmount,
    required double balanceAmount,
    required String dateAndTime,
    required String branch,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final maleDetails = _selectedTreatments
          .where((e) => e.maleCount > 0)
          .map((e) => e.treatment.id.toString())
          .join(',');
      final femaleDetails = _selectedTreatments
          .where((e) => e.femaleCount > 0)
          .map((e) => e.treatment.id.toString())
          .join(',');
      final treatmentIds = _selectedTreatments
          .map((e) => e.treatment.id.toString())
          .join(',');

      final Map<String, dynamic> data = {
        "name": name,
        "excecutive": excecutive,
        "payment": payment,
        "phone": phone,
        "address": address,
        "total_amount": totalAmount,
        "discount_amount": discountAmount,
        "advance_amount": advanceAmount,
        "balance_amount": balanceAmount,
        "date_nd_time": dateAndTime,
        "male": maleDetails,
        "female": femaleDetails,
        "branch": branch,
        "treatments": treatmentIds,
      };

      await HomeDataServices.updatePatient(data);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
