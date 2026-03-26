import 'package:flutter/material.dart';
import 'package:ksta/theme/theme_manager_scope.dart';

class ThemeModeToggleButton extends StatelessWidget {
  const ThemeModeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = context.themeManager;
    final isDarkMode = themeManager.isDarkMode;

    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 4),
      child: IconButton(
        tooltip: isDarkMode ? 'Switch to light mode' : 'Switch to dark mode',
        onPressed: themeManager.enabled ? themeManager.toggleThemeMode : null,
        icon: Icon(isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
      ),
    );
  }
}
