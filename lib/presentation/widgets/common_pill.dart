import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart' hide AppTheme;

class TextPill extends StatelessWidget {
  final Color textColor;
  final Color background;
  final String text;
  TextPill({
    super.key,
    this.textColor = AppColors.tagText,
    this.background = AppColors.tagBg,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
      ),
    );
  }
}
