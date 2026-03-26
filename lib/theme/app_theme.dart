import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

const _lightScaffoldBackground = Color(0xFFF5F3EE);
const _darkScaffoldBackground = Color(0xFF121212);

ThemeData buildAppTheme({
  required Brightness brightness,
}) {
  final colorScheme = _buildColorScheme(brightness);

  final baseTheme = ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
  );

  final textTheme = _buildEditorialTextTheme(baseTheme.textTheme).apply(
    bodyColor: colorScheme.onSurface,
    displayColor: colorScheme.onSurface,
  );

  return baseTheme.copyWith(
    scaffoldBackgroundColor: brightness == Brightness.dark ? _darkScaffoldBackground : _lightScaffoldBackground,
    textTheme: textTheme,
    primaryTextTheme: _buildEditorialTextTheme(baseTheme.primaryTextTheme).apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      systemOverlayStyle: brightness == Brightness.dark
          ? const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            )
          : const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            ),
    ),
  );
}

ColorScheme _buildColorScheme(Brightness brightness) {
  return switch (brightness) {
    Brightness.light => const ColorScheme.light(
      primary: Color(0xFF2F2F2F),
      primaryContainer: Color(0xFFE2DED6),
      onPrimaryContainer: Color(0xFF1B1B1B),
      secondary: Color(0xFF5B5B5B),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFE8E5DE),
      onSecondaryContainer: Color(0xFF202020),
      tertiary: Color(0xFF707070),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFF0ECE5),
      onTertiaryContainer: Color(0xFF242424),
      error: Color(0xFFBA1A1A),
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),
      surface: _lightScaffoldBackground,
      onSurface: Color(0xFF1C1B1A),
      onSurfaceVariant: Color(0xFF5F5B57),
      outline: Color(0xFF7B7671),
      outlineVariant: Color(0xFFCDC6BF),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF31302E),
      onInverseSurface: Color(0xFFF4F0EB),
      inversePrimary: Color(0xFFE7E2DA),
      surfaceTint: Color(0xFF2F2F2F),
    ),
    Brightness.dark => const ColorScheme.dark(
      primary: Color(0xFFE8E3DB),
      onPrimary: Color(0xFF1D1D1D),
      primaryContainer: Color(0xFF2A2A2A),
      onPrimaryContainer: Color(0xFFF5F1EA),
      secondary: Color(0xFFD2CDC5),
      onSecondary: Color(0xFF1D1D1D),
      secondaryContainer: Color(0xFF262626),
      onSecondaryContainer: Color(0xFFEDE8E0),
      tertiary: Color(0xFFC8C3BC),
      onTertiary: Color(0xFF1C1C1C),
      tertiaryContainer: Color(0xFF303030),
      onTertiaryContainer: Color(0xFFF2EEE7),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      onSurface: Color(0xFFF2EFE9),
      onSurfaceVariant: Color(0xFFC9C4BD),
      outline: Color(0xFF938E87),
      outlineVariant: Color(0xFF494642),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFE7E2DA),
      onInverseSurface: Color(0xFF1C1B1A),
      inversePrimary: Color(0xFF303030),
      surfaceTint: Color(0xFFE8E3DB),
    ),
  };
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
