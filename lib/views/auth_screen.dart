// Purpose: Handles user login and sign up using MVVM pattern.
import 'package:flutter/material.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'category_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late final AuthViewModel _viewModel;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _viewModel = AuthViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  // Validates form and signs in or signs up the user.
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final wasLogin = _viewModel.isLogin;
      final success = await _viewModel.submit();

      if (success) {
        if (wasLogin) {
          _navigateToCategory();
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Sign up successful! You can now log in.'),
              ),
            );
          }
        }
      } else {
        if (mounted && _viewModel.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_viewModel.errorMessage!)),
          );
        }
      }
    }
  }

  // Moves the user to the category selection screen.
  void _navigateToCategory() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const CategoryScreen()),
    );
  }

  @override
  // Builds the login/signup form UI reactive to ViewModel updates.
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(title: Text(_viewModel.isLogin ? "Login" : "Sign Up")),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _viewModel.emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _viewModel.passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (val) => val!.isEmpty ? 'Enter a password' : null,
                  ),
                  const SizedBox(height: 24),
                  if (_viewModel.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else ...[
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: Text(
                        _viewModel.isLogin ? "Login" : "Sign Up",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    TextButton(
                      onPressed: _viewModel.toggleAuthMode,
                      child: Text(
                        _viewModel.isLogin
                            ? "Create an account"
                            : "I already have an account",
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
