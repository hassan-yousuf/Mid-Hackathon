import 'package:flutter/material.dart';
import 'package:midhackathon/core/theme/app_colors.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
  textTheme: const TextTheme(bodyMedium: TextStyle(color: AppColors.text)),
);
