import 'dart:convert';
import 'dart:developer';
import 'package:healthcare_booking_platform/core/services/auth_data_service.dart';
import 'package:healthcare_booking_platform/features/home/models/patient_model.dart';
import 'package:healthcare_booking_platform/features/home/models/treatment_model.dart';
import 'package:http/http.dart' as http;

class HomeDataServices {
  static Future<List<TreatmentModel>> getTreatments() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        log("HomeDataServices: No token found");
        throw Exception("Auth token not found");
      }

      final response = await http.get(
        Uri.parse("https://flutter-amr.noviindus.in/api/TreatmentList"),
        headers: {'Authorization': 'Bearer $token'},
      );

      log("Treatment List Response: ${response.statusCode}");

      final List<dynamic> data = jsonDecode(response.body)["treatments"];
      final modelList = data.map((e) => TreatmentModel.fromJson(e)).toList();

      if (response.statusCode == 200) {
        return modelList;
      } else {
        throw Exception("Failed to fetch treatments");
      }
    } catch (e) {
      log("HomeDataServices Error: $e");
      rethrow;
    }
  }

  static Future<List<PatientModel>> getPatients() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception("Auth token not found");

      final response = await http.get(
        Uri.parse("https://flutter-amr.noviindus.in/api/PatientList"),
        headers: {'Authorization': 'Bearer $token'},
      );

      log("Patient List Response: ${response.statusCode}");
      log("Patient List Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)["patient"];
        final List<PatientModel> patientList = [];
        int index = 1;
        for (var e in data) {
          patientList.add(PatientModel.fromJson(e, index));
          index++;
        }
        return patientList;
      } else {
        throw Exception("Failed to fetch patients");
      }
    } catch (e) {
      log("getPatients Error: $e");
      rethrow;
    }
  }

  static Future<List<BranchModel>> getBranches() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception("Auth token not found");

      final response = await http.get(
        Uri.parse("https://flutter-amr.noviindus.in/api/BranchList"),
        headers: {'Authorization': 'Bearer $token'},
      );

      log("Branch List Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        log(decoded.toString());
        final List<dynamic> data = decoded["branches"] ?? [];
        return data.map((e) => BranchModel.fromJson(e)).toList();
      } else {
        log("Branch List Error: ${response.body}");
        throw Exception("Failed to load branches: ${response.statusCode}");
      }
    } catch (e) {
      log("getBranches Error: $e");
      rethrow;
    }
  }

  static Future<void> updatePatient(Map<String, dynamic> data) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception("Auth token not found");

      final body = data.map((key, value) => MapEntry(key, value.toString()));
      log("Updating patient with body: $body");

      final response = await http.post(
        Uri.parse("https://flutter-amr.noviindus.in/api/PatientUpdate"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      log("Patient Update Response: ${response.statusCode}");
      log("Response Body: ${response.body}");

      final Map<String, dynamic> decoded = jsonDecode(response.body);
      if (response.statusCode == 200 &&
          (decoded['status'] == true || decoded['status'] == "success")) {
        return;
      } else {
        throw Exception(decoded['message'] ?? "Failed to update patient");
      }
    } catch (e) {
      log("updatePatient Error: $e");
      rethrow;
    }
  }
}
