import 'package:flutter/material.dart';
import 'package:healthcare_booking_platform/features/auth/models/login_model.dart';
import 'package:healthcare_booking_platform/features/auth/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _isError;
  String? get isError => _isError;

  UserDetailsModel? _user;
  UserDetailsModel? get user => _user;

  setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  setError(String? message) {
    _isError = message;
    notifyListeners();
  }

  clearError() {
    _isError = null;
    notifyListeners();
  }

  Future<bool> loadData(String username, String password) async {
    setLoading(true);
    clearError();
    try {
      LoginModel response = await AuthRepository.login(username, password);
      _user = response.userDetails;
      setLoading(false);
      return response.status;
    } catch (e) {
      String errorMessage = e.toString().replaceFirst('Exception: ', '');
      setError(errorMessage);
      setLoading(false);
      return false;
    }
  }

  Future<String?> getToken() async {
    return await AuthRepository.getToken();
  }

  Future<void> logout() async {
    await AuthRepository.logout();
    _user = null;
    notifyListeners();
  }
}
