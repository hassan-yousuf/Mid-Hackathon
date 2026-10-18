import 'package:flutter/material.dart';
import 'package:midhackathon/core/theme/app_colors.dart';

Widget customButton({required String text, required VoidCallback onPressed}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    child: Text(text, style: TextStyle(fontSize: 16, color: Colors.white)),
  );
}

Widget customOutlinedButton({
  required String text,
  required VoidCallback onPressed,
  bool gsignin = false,
}) {
  return OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      side: BorderSide(color: AppColors.primary),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    child: gsignin
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'G',
                style: TextStyle(
                  fontSize: 30,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(fontSize: 16, color: AppColors.primary),
              ),
            ],
          )
        : Text(text, style: TextStyle(fontSize: 16, color: AppColors.primary)),
  );
}
