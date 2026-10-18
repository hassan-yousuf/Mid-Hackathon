import 'package:flutter/material.dart';
import 'package:midhackathon/core/helper/snackbar.dart';
import 'package:midhackathon/features/auth/screens/register_screen.dart';
import 'package:midhackathon/services/auth_services.dart';
import 'package:midhackathon/services/firebase_services.dart';
import 'package:midhackathon/widgets/custom_button.dart';
import 'package:midhackathon/widgets/custom_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthServices _authServices = AuthServices();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    await _runAuthAction(() => _authServices.signInWithGoogle(context));
  }

  Future<void> _signInWithEmail() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await _runAuthAction(
      () => _authServices.login(
        context,
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  Future<void> _runAuthAction(Future<Object?> Function() action) async {
    if (_isLoading) {
      return;
    }
    setState(() => _isLoading = true);
    try {
      await action();
    } on AuthServiceException catch (error) {
      if (mounted) {
        showSnackBar(context, error.message);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
              padding: const EdgeInsets.fromLTRB(32, 40, 32, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Welcome back',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 42),
                    customField(
                      hintText: 'Email',
                      controller: _emailController,
                      type: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    customField(
                      hintText: 'Password',
                      controller: _passwordController,
                      type: TextInputType.visiblePassword,
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () async {
                          if (_emailController.text.trim().isEmpty) {
                            showSnackBar(context, 'Enter your email first.');
                            return;
                          }
                          try {
                            await _authServices.sendPasswordResetEmail(
                              _emailController.text,
                            );
                          } catch (_) {
                            if (mounted) {
                              showSnackBar(
                                context,
                                'Unable to send reset email. Check the address and try again.',
                              );
                            }
                          }
                        },
                        child: const Text('Forgot Password?'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 54,
                      child: customButton(
                        onPressed: () async {
                          _isLoading ? null : await _signInWithEmail();
                        },
                        text: 'LOGIN',
                      ),
                    ),
                    const SizedBox(height: 12),
                    customOutlinedButton(
                      gsignin: true,
                      onPressed: () async {
                        _isLoading ? null : await _signInWithGoogle();
                      },
                      text: 'Continue with Google',
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text('Don\'t have an account? Register'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
