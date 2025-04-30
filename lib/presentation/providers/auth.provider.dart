import 'package:flutter/material.dart';
import 'package:pakapp/data/services/auth.service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();

      final data = await AuthService.login(email, password);

      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error de login')));
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
