import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ksta/theme/app_colors.dart';

final darkTheme = _buildDarkTheme();

ThemeData _buildDarkTheme() {
  const colorScheme = ColorScheme.dark(
    primary: AppColors.boneWarm,
    onPrimary: AppColors.charcoal,
    primaryContainer: AppColors.slate,
    onPrimaryContainer: AppColors.paperWarm,
    secondary: AppColors.stone,
    onSecondary: AppColors.charcoal,
    secondaryContainer: AppColors.slateDark,
    onSecondaryContainer: AppColors.bone,
    tertiary: AppColors.stoneDark,
    onTertiary: AppColors.ink,
    tertiaryContainer: AppColors.coalSoft,
    onTertiaryContainer: AppColors.linenSoft,
    error: AppColors.dangerSoft,
    onError: AppColors.dangerInk,
    errorContainer: AppColors.dangerDark,
    onErrorContainer: AppColors.dangerContainer,
    onSurface: AppColors.linen,
    onSurfaceVariant: AppColors.stoneDark,
    outline: AppColors.dust,
    outlineVariant: AppColors.iron,
    shadow: AppColors.black,
    scrim: AppColors.black,
    inverseSurface: AppColors.stoneLight,
    onInverseSurface: AppColors.ink,
    inversePrimary: AppColors.coalSoft,
    surfaceTint: AppColors.boneWarm,
  );

  final baseTheme = ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
  );

  final textTheme = _buildEditorialTextTheme(baseTheme.textTheme).apply(
    bodyColor: colorScheme.onSurface,
    displayColor: colorScheme.onSurface,
  );

  return baseTheme.copyWith(
    scaffoldBackgroundColor: AppColors.obsidian,
    textTheme: textTheme,
    primaryTextTheme: _buildEditorialTextTheme(baseTheme.primaryTextTheme).apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.transparent,
      surfaceTintColor: AppColors.transparent,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
  );
}

TextTheme _buildEditorialTextTheme(TextTheme base) {
  final sans = GoogleFonts.sourceSans3TextTheme(base);

  TextStyle serif(
    TextStyle? style, {
    required FontWeight fontWeight,
    required double height,
    double? letterSpacing,
  }) {
    return GoogleFonts.merriweather(
      textStyle: style?.copyWith(
        fontWeight: fontWeight,
        height: height,
        letterSpacing: letterSpacing,
      ),
    );
  }

  return sans.copyWith(
    displayLarge: serif(
      sans.displayLarge,
      fontWeight: FontWeight.w700,
      height: 1.04,
      letterSpacing: -1.2,
    ),
    displayMedium: serif(
      sans.displayMedium,
      fontWeight: FontWeight.w700,
      height: 1.06,
      letterSpacing: -0.9,
    ),
    displaySmall: serif(
      sans.displaySmall,
      fontWeight: FontWeight.w700,
      height: 1.08,
      letterSpacing: -0.6,
    ),
    headlineLarge: serif(
      sans.headlineLarge,
      fontWeight: FontWeight.w700,
      height: 1.1,
      letterSpacing: -0.45,
    ),
    headlineMedium: serif(
      sans.headlineMedium,
      fontWeight: FontWeight.w700,
      height: 1.12,
      letterSpacing: -0.35,
    ),
    headlineSmall: serif(
      sans.headlineSmall,
      fontWeight: FontWeight.w700,
      height: 1.16,
      letterSpacing: -0.2,
    ),
    titleLarge: GoogleFonts.sourceSans3(
      textStyle: sans.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.15,
      ),
    ),
    titleMedium: serif(
      sans.titleMedium,
      fontWeight: FontWeight.w700,
      height: 1.22,
      letterSpacing: -0.15,
    ),
    titleSmall: GoogleFonts.sourceSans3(
      textStyle: sans.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
    ),
    bodyLarge: GoogleFonts.sourceSans3(
      textStyle: sans.bodyLarge?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        height: 1.75,
        letterSpacing: 0.1,
      ),
    ),
    bodyMedium: GoogleFonts.sourceSans3(
      textStyle: sans.bodyMedium?.copyWith(
        fontWeight: FontWeight.w400,
        height: 1.55,
        letterSpacing: 0.1,
      ),
    ),
    bodySmall: GoogleFonts.sourceSans3(
      textStyle: sans.bodySmall?.copyWith(
        fontWeight: FontWeight.w400,
        height: 1.45,
        letterSpacing: 0.1,
      ),
    ),
    labelLarge: GoogleFonts.sourceSans3(
      textStyle: sans.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: 0.35,
      ),
    ),
    labelMedium: GoogleFonts.sourceSans3(
      textStyle: sans.labelMedium?.copyWith(
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: 0.45,
      ),
    ),
    labelSmall: GoogleFonts.sourceSans3(
      textStyle: sans.labelSmall?.copyWith(
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: 0.45,
      ),
    ),
  );
}
