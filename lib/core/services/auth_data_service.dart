import 'dart:convert';
import 'dart:developer';

import 'package:healthcare_booking_platform/features/auth/models/login_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<LoginModel> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse("https://flutter-amr.noviindus.in/api/Login"),
        body: {"username": username, "password": password},
      );

      final data = jsonDecode(response.body);
      log("Login Response: ${response.body}");

      final loginModel = LoginModel.fromJson(data);

      if (response.statusCode == 200) {
        if (loginModel.status) {
          if (loginModel.token != null) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('auth_token', loginModel.token!);
          }
          return loginModel;
        } else {
          throw Exception(loginModel.message);
        }
      } else {
        throw Exception(
          loginModel.message.isNotEmpty
              ? loginModel.message
              : "failed to login",
        );
      }
    } catch (e) {
      log("Login Error: $e");
      rethrow;
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}
