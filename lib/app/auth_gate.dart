import 'package:flutter/material.dart';
import 'package:midhackathon/features/auth/screens/login_screen.dart';
import 'package:midhackathon/features/dashboard/screens/dashboard_screen.dart';
import 'package:midhackathon/services/auth_services.dart';
import 'package:midhackathon/widgets/loader.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final AuthServices _authServices = AuthServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _authServices.authStateChanges,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loader();
          } else if (snapshot.hasData) {
            return DashboardScreen();
          } else {
            return LoginScreen();
          }
        }),
      ),
    );
  }
}
