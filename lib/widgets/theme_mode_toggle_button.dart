import 'package:flutter/material.dart';
import 'package:ksta/theme/theme_manager_scope.dart';

class ThemeModeToggleButton extends StatelessWidget {
  const ThemeModeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 4),
      child: IconButton(
        tooltip: context.themeManager.isDarkMode ? 'Switch to light mode' : 'Switch to dark mode',
        onPressed: context.themeManager.enabled ? context.themeManager.toggleThemeMode : null,
        icon: Icon(context.themeManager.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
      ),
    );
  }
}
