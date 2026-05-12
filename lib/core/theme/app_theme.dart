import 'package:flutter/material.dart';

// ─────────────────────────────────────────
// DekkaPOS — Design Tokens
// ─────────────────────────────────────────
class AppColors {
  AppColors._();

  // Brand purple ramp
  static const Color sidebarBg      = Color(0xFF1E1340);
  static const Color headerBg       = Color(0xFF251852);
  static const Color accent         = Color(0xFF6C56F5);
  static const Color accentLight    = Color(0xFFEDE9FF);
  static const Color accentMid      = Color(0xFF9B8BF8);
  static const Color accentDark     = Color(0xFF4B3BBF);

  // Surfaces
  static const Color mainBg         = Color(0xFFF5F4FB);
  static const Color panelBg        = Color(0xFFFFFFFF);
  static const Color tableRowEven   = Color(0xFFFAFAFE);
  static const Color tableHeader    = Color(0xFFF0EEFF);

  // Text
  static const Color textPrimary    = Color(0xFF1A1535);
  static const Color textSecondary  = Color(0xFF6B6886);
  static const Color textMuted      = Color(0xFFA09DBE);

  // Borders / dividers
  static const Color divider        = Color(0x1A6C56F5);
  static const Color border         = Color(0x1F6C56F5);

  // Tags
  static const Color tagBg          = Color(0xFFEDE9FF);
  static const Color tagText        = Color(0xFF4B3BBF);

  // Status
  static const Color danger         = Color(0xFFE24B4A);
  static const Color dangerBg       = Color(0xFFFDEAEA);
}

class AppTheme {
  AppTheme._();

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppColors.mainBg,
    fontFamily: 'Roboto',
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 0.5,
    ),
  );
}

// ─────────────────────────────────────────
// Text Styles
// ─────────────────────────────────────────
class AppTextStyles {
  AppTextStyles._();

  static const TextStyle sidebarLabel = TextStyle(
    fontSize: 8, fontWeight: FontWeight.w600,
    color: Color(0xFF9B8BF8), letterSpacing: 1.5,
  );

  static const TextStyle navLabel = TextStyle(
    fontSize: 8, fontWeight: FontWeight.w500,
    color: Colors.white54,
  );

  static const TextStyle topBarTitle = TextStyle(
    fontSize: 15, fontWeight: FontWeight.w600,
    color: Colors.white, letterSpacing: -0.2,
  );

  static const TextStyle topBarBadge = TextStyle(
    fontSize: 10, fontWeight: FontWeight.w600,
    color: AppColors.accentMid, letterSpacing: 0.5,
  );

  static const TextStyle topBarClock = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w400,
    color: Colors.white54, fontFamily: 'monospace',
  );

  static const TextStyle adminName = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static const TextStyle adminEmail = TextStyle(
    fontSize: 9, color: Colors.white54,
  );

  static const TextStyle panelTitle = TextStyle(
    fontSize: 13, fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle productName = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle productCode = TextStyle(
    fontSize: 9, color: AppColors.textMuted,
    fontFamily: 'monospace',
  );

  static const TextStyle productPrice = TextStyle(
    fontSize: 13, fontWeight: FontWeight.w600,
    color: AppColors.accent,
  );

  static const TextStyle tableHeader = TextStyle(
    fontSize: 10, fontWeight: FontWeight.w600,
    color: AppColors.textSecondary, letterSpacing: 0.4,
  );

  static const TextStyle tableCell = TextStyle(
    fontSize: 12, color: AppColors.textPrimary,
  );

  static const TextStyle tableCellMono = TextStyle(
    fontSize: 11, color: AppColors.textMuted,
    fontFamily: 'monospace',
  );

  static const TextStyle tableCellPrice = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w600,
    color: AppColors.accent, fontFamily: 'monospace',
  );

  static const TextStyle totalLabel = TextStyle(
    fontSize: 11, color: AppColors.textSecondary,
  );

  static const TextStyle totalValue = TextStyle(
    fontSize: 11, color: AppColors.textSecondary,
  );

  static const TextStyle grandTotalLabel = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle grandTotalValue = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle currencyLabel = TextStyle(
    fontSize: 9, fontWeight: FontWeight.w600,
    color: AppColors.textMuted, letterSpacing: 0.5,
  );

  static const TextStyle currencyValue = TextStyle(
    fontSize: 11, fontWeight: FontWeight.w600,
    color: AppColors.textSecondary, fontFamily: 'monospace',
  );
}
