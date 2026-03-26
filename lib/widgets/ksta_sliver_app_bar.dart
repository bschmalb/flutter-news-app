import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ksta/theme/app_colors.dart';
import 'package:ksta/utils/common/image_assets.dart';
import 'package:ksta/widgets/theme_mode_toggle_button.dart';

class KstaSliverAppBar extends StatelessWidget {
  const KstaSliverAppBar({super.key, this.floating = false, this.snap = false, this.automaticallyImplyLeading = false});

  static const _fadeHeightFactor = 0.3;
  static const _logoHeightFactor = 0.38;

  final bool floating;
  final bool snap;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final toolbarHeight = _toolbarHeight(theme);
    final logoColor = _foregroundColor(theme);

    return SliverAppBar(
      floating: floating,
      snap: snap,
      automaticallyImplyLeading: automaticallyImplyLeading,
      toolbarHeight: toolbarHeight,
      expandedHeight: toolbarHeight * (1 + _fadeHeightFactor),
      backgroundColor: AppColors.transparent,
      elevation: 0,
      surfaceTintColor: AppColors.transparent,
      actions: const [ThemeModeToggleButton()],
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
                    theme.scaffoldBackgroundColor,
                    theme.scaffoldBackgroundColor,
                    theme.scaffoldBackgroundColor.withValues(alpha: 0),
                  ],
                  stops: const [0, 0.5, 1],
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top,
            left: 0,
            right: 0,
            height: toolbarHeight,
            child: Center(
              child: SvgPicture.asset(
                ImageAssets.kstaIcon,
                height: toolbarHeight * _logoHeightFactor,
                semanticsLabel: 'KSTA',
                colorFilter: ColorFilter.mode(logoColor, .srcIn),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _toolbarHeight(ThemeData theme) => theme.appBarTheme.toolbarHeight ?? kToolbarHeight;

  Color _foregroundColor(ThemeData theme) => theme.appBarTheme.foregroundColor ?? theme.colorScheme.onSurface;
}
