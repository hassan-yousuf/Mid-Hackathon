import 'package:flutter/material.dart';
import 'package:midhackathon/core/helper/snackbar.dart';
import 'package:midhackathon/features/auth/screens/login_screen.dart';
import 'package:midhackathon/services/auth_services.dart';
import 'package:midhackathon/services/firebase_services.dart';
import 'package:midhackathon/widgets/custom_button.dart';
import 'package:midhackathon/widgets/custom_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthServices _authServices = AuthServices();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_usernameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.length < 6) {
      showSnackBar(
        context,
        'Enter a username, email, and 6+ character password.',
      );
      return;
    }
    await _runAuthAction(
      () => _authServices.signup(
        context,
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  Future<void> _runAuthAction(Future<Object?> Function() action) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      await action();
    } on AuthServiceException catch (error) {
      if (mounted) showSnackBar(context, error.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f8f8),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Sign up',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 34),
                  customField(
                    type: TextInputType.name,
                    hintText: 'Username',
                    controller: _usernameController,
                  ),
                  const SizedBox(height: 12),
                  customField(
                    type: TextInputType.emailAddress,
                    hintText: 'Email',
                    controller: _emailController,
                  ),
                  const SizedBox(height: 12),
                  customField(
                    type: TextInputType.visiblePassword,
                    hintText: 'Password',
                    controller: _passwordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 26),
                  customButton(
                    onPressed: _isLoading ? () {} : _register,
                    text: _isLoading ? 'Please wait...' : 'SIGN UP',
                  ),
                  const SizedBox(height: 12),
                  customOutlinedButton(
                    gsignin: true,
                    onPressed: _isLoading
                        ? () {}
                        : () => _runAuthAction(
                            () => _authServices.signInWithGoogle(context),
                          ),
                    text: 'Continue with Google',
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    ),
                    child: const Text('Already have an account? Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
