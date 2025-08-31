import 'package:trendz_customer/Services/api_services.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> loginWithEmailPassword(
      String email, String password) async {
    return await _apiService.loginWithEmailPassword(email, password);
  }
}
