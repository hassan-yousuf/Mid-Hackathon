import 'dart:async';

import 'package:flutter/material.dart';
import 'package:midhackathon/app/auth_gate.dart';
import 'package:midhackathon/core/constants/app_constants.dart';
import 'package:midhackathon/core/constants/asset_constants.dart';
import 'package:midhackathon/core/theme/text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _navigationTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const AuthGate()),
      );
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(75),
                  image: DecorationImage(
                    image: AssetImage(AssetConstants.icon),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(AppConstants.appName, style: TextStyles.heading),
              const SizedBox(height: 10),
              Text(AppConstants.appSlogan, style: TextStyles.subheading),
              const SizedBox(height: 200),
              Text(AppConstants.appVersion, style: TextStyles.body),
            ],
          ),
        ),
      ),
    );
  }
}
