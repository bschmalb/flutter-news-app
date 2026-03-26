import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ksta/theme/app_colors.dart';
import 'package:ksta/theme/theme_manager_scope.dart';

class KstaSliverAppBar extends StatelessWidget {
  const KstaSliverAppBar({super.key, this.floating = false, this.snap = false, this.automaticallyImplyLeading = false});

  final bool floating;
  final bool snap;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeManager = context.themeManager;
    final isDarkMode = themeManager.isDarkMode;
    final topPadding = MediaQuery.paddingOf(context).top;
    final toolbarHeight = theme.appBarTheme.toolbarHeight ?? kToolbarHeight;
    final fadeHeight = toolbarHeight * 0.3;
    final logoHeight = toolbarHeight * 0.38;
    final appBarColor = theme.scaffoldBackgroundColor;
    final transparentAppBarColor = appBarColor.withValues(alpha: 0);
    final logoColor = theme.colorScheme.onSurface;

    return SliverAppBar(
      floating: floating,
      snap: snap,
      automaticallyImplyLeading: automaticallyImplyLeading,
      toolbarHeight: toolbarHeight,
      expandedHeight: toolbarHeight + fadeHeight,
      backgroundColor: AppColors.transparent,
      elevation: 0,
      surfaceTintColor: AppColors.transparent,
      foregroundColor: logoColor,
      iconTheme: IconThemeData(color: logoColor),
      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 4),
          child: IconButton(
            tooltip: isDarkMode ? 'Switch to light mode' : 'Switch to dark mode',
            onPressed: themeManager.enabled ? themeManager.toggleThemeMode : null,
            icon: Icon(
              isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            ),
          ),
        ),
      ],
      flexibleSpace: Stack(
        fit: StackFit.expand,
        children: [
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: .topCenter,
                  end: .bottomCenter,
                  colors: [
                    appBarColor,
                    appBarColor,
                    transparentAppBarColor,
                  ],
                  stops: const [0, 0.5, 1],
                ),
              ),
            ),
          ),
          Positioned(
            top: topPadding,
            left: 0,
            right: 0,
            height: toolbarHeight,
            child: Center(
              child: SvgPicture.asset(
                'assets/logos/ksta_icon.svg',
                height: logoHeight,
                semanticsLabel: 'KSTA',
                colorFilter: ColorFilter.mode(
                  logoColor,
                  .srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
