import 'package:healthcare_booking_platform/core/services/auth_data_service.dart';
import 'package:healthcare_booking_platform/features/auth/models/login_model.dart';

class AuthRepository {
  static Future<LoginModel> login(String username, String password) async {
    return await AuthService.login(username, password);
  }

  static Future<String?> getToken() async {
    return await AuthService.getToken();
  }

  static Future<void> logout() async {
    await AuthService.logout();
  }
}
