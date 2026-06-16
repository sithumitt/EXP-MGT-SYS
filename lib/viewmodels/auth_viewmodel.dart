import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/database_service.dart';

// Purpose: Viewmodel for AuthScreen handling authentication state and logic.
class AuthViewModel extends ChangeNotifier {
  final _dbService = DatabaseService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLogin => _isLogin;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Toggles the authentication mode (Login / Sign Up)
  void toggleAuthMode() {
    _isLogin = !_isLogin;
    _errorMessage = null;
    notifyListeners();
  }

  // Submits the form credentials to log in or sign up.
  // Returns true on success, false on failure.
  Future<bool> submit() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_isLogin) {
        await _dbService.signIn(email, password);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        await _dbService.signUp(email, password);
        _isLogin = true; // Automatically toggle to login screen after successful signup
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
