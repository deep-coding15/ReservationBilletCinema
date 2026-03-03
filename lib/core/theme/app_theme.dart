import 'package:flutter/material.dart';

/// Couleurs type cinéma (rouge / or / noir) + néon pour filtres.
class AppColors {
  static const Color primary = Color(0xFFc41e3a);
  static const Color primaryDark = Color(0xFF8b1529);
  static const Color accent = Color(0xFFe8b923);
  /// Couleur néon (rouge) pour filtres sélectionnés et éléments visibles.
  static const Color neon = Color(0xFFe53935);
  static const Color neonGlow = Color(0x40e53935);
  static const Color background = Color(0xFFf5f0eb);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onPrimary = Colors.white;
  static const Color onBackground = Color(0xFF1a1a1a);
  static const Color onSurfaceVariant = Color(0xFF5c5c5c);
}

/// Thème global de l'application.
class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          secondary: AppColors.accent,
          surface: AppColors.surface,
          onSurface: AppColors.onBackground,
          onSurfaceVariant: AppColors.onSurfaceVariant,
          background: AppColors.background,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: AppColors.surface,
        ),
      );

  static ThemeData get dark => ThemeData.dark(useMaterial3: true);
}
