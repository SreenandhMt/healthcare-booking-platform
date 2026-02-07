import 'package:flutter/material.dart';
import 'package:healthcare_booking_platform/core/services/home_data_service.dart';
import 'package:healthcare_booking_platform/features/home/models/patient_model.dart';
import 'package:healthcare_booking_platform/features/home/models/treatment_model.dart';

class HomeViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  List<PatientModel> _allPatients = [];
  List<PatientModel> _filteredPatients = [];
  List<PatientModel> get patients => _filteredPatients;

  List<TreatmentModel> _treatments = [];
  List<TreatmentModel> get treatments => _treatments;

  String _searchQuery = "";
  String get searchQuery => _searchQuery;

  bool _isAscending = false; // Default to descending (newest first)
  bool get isAscending => _isAscending;

  DateTime? _filterDate;
  DateTime? get filterDate => _filterDate;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? value) {
    _error = value;
    notifyListeners();
  }

  Future<void> fetchPatients() async {
    setLoading(true);
    setError(null);
    try {
      _allPatients = await HomeDataServices.getPatients();
      _applyFilterAndSort();
    } catch (e) {
      setError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      setLoading(false);
    }
  }

  Future<void> fetchTreatments() async {
    try {
      _treatments = await HomeDataServices.getTreatments();
      notifyListeners();
    } catch (e) {
      // Just log or keep empty
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilterAndSort();
  }

  void toggleSortOrder() {
    _isAscending = !_isAscending;
    _applyFilterAndSort();
  }

  void setSortOrder(bool ascending) {
    _isAscending = ascending;
    _applyFilterAndSort();
  }

  void setFilterDate(DateTime? date) {
    _filterDate = date;
    _applyFilterAndSort();
  }

  void _applyFilterAndSort() {
    // 1. Filter
    _filteredPatients = _allPatients.where((p) {
      final query = _searchQuery.toLowerCase();
      if (query.isEmpty)
        return _filterDate == null || _isDateMatch(p, _filterDate!);

      final nameMatch = _fuzzyMatch(p.name.toLowerCase(), query);
      final phoneMatch = p.phone.contains(
        _searchQuery,
      ); // Phone usually needs exact substring
      final addressMatch = _fuzzyMatch(p.address.toLowerCase(), query);

      bool dateMatch = true;
      if (_filterDate != null) {
        dateMatch = _isDateMatch(p, _filterDate!);
      }

      return (nameMatch || phoneMatch || addressMatch) && dateMatch;
    }).toList();

    // Sort based on original backend order (index)
    _filteredPatients.sort((a, b) {
      final indexA = a.index ?? 0;
      final indexB = b.index ?? 0;
      return _isAscending ? indexA.compareTo(indexB) : indexB.compareTo(indexA);
    });

    notifyListeners();
  }

  void addLocalPatient(PatientModel patient) {
    final nextIndex = _allPatients.length + 1;
    _allPatients.insert(0, patient.copyWith(index: nextIndex));
    _applyFilterAndSort();
  }

  DateTime _parseDate(String dateStr) {
    try {
      // Try ISO format first
      return DateTime.parse(dateStr);
    } catch (_) {
      try {
        // Try dd/MM/yyyy-hh:mm a format
        final mainParts = dateStr.split('-');
        final datePart = mainParts[0].trim();
        final timePart = mainParts.length > 1
            ? mainParts[1].trim()
            : "12:00 AM";

        final dateParts = datePart.split('/');
        if (dateParts.length == 3) {
          int year = int.parse(dateParts[2]);
          int month = int.parse(dateParts[1]);
          int day = int.parse(dateParts[0]);

          // Handle 12-hour format time (hh:mm a)
          int hour = 0;
          int minute = 0;
          try {
            final timeRegex = RegExp(
              r"(\d+):(\d+)\s*(AM|PM)",
              caseSensitive: false,
            );
            final match = timeRegex.firstMatch(timePart);
            if (match != null) {
              hour = int.parse(match.group(1)!);
              minute = int.parse(match.group(2)!);
              final period = match.group(3)!.toUpperCase();

              if (period == "PM" && hour < 12) hour += 12;
              if (period == "AM" && hour == 12) hour = 0;
            }
          } catch (_) {}

          return DateTime(year, month, day, hour, minute);
        }
      } catch (_) {}
      return DateTime(1900); // Fallback
    }
  }

  bool _isDateMatch(PatientModel p, DateTime filterDate) {
    final patientDate = _parseDate(p.dateNdTime);
    return patientDate.year == filterDate.year &&
        patientDate.month == filterDate.month &&
        patientDate.day == filterDate.day;
  }

  bool _fuzzyMatch(String text, String query) {
    if (query.isEmpty) return true;
    if (text.isEmpty) return false;

    int queryIndex = 0;
    for (int i = 0; i < text.length; i++) {
      if (text[i] == query[queryIndex]) {
        queryIndex++;
      }
      if (queryIndex == query.length) {
        return true;
      }
    }
    return false;
  }

  Future<void> refreshData() async {
    await fetchPatients();
    await fetchTreatments();
  }
}
