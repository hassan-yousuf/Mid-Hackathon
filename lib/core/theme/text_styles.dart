import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:midhackathon/core/theme/app_colors.dart';

abstract class TextStyles {
  static final TextStyle heading = GoogleFonts.roboto(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );
  static final TextStyle subheading = GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.text,
  );
  static final TextStyle body = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.text,
  );
}
