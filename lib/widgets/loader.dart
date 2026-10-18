import 'package:flutter/material.dart';
import 'package:midhackathon/core/theme/app_colors.dart';

class Loader extends StatefulWidget {
  const new({super.key});

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(color: AppColors.primary));
  }
}
