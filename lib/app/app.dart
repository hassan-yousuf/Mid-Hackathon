import 'package:flutter/material.dart';
import 'package:midhackathon/app/splash_screen.dart';
import 'package:midhackathon/core/constants/app_constants.dart';
import 'package:midhackathon/core/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: theme,
      home: SplashScreen(),
    );
  }
}
