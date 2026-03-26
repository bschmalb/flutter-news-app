import 'package:flutter/widgets.dart';

enum AppBreakpoint {
  compact,
  medium,
  expanded;

  static AppBreakpoint fromWidth(double width) {
    if (width < 600) {
      return AppBreakpoint.compact;
    }

    if (width < 840) {
      return AppBreakpoint.medium;
    }

    return AppBreakpoint.expanded;
  }
}

extension AppBreakpointBuildContext on BuildContext {
  AppBreakpoint get breakpoint =>
      AppBreakpoint.fromWidth(MediaQuery.sizeOf(this).width);

  bool get isCompact => breakpoint == AppBreakpoint.compact;

  bool get isMedium => breakpoint == AppBreakpoint.medium;

  bool get isExpanded => breakpoint == AppBreakpoint.expanded;
}

extension AppBreakpointValues on AppBreakpoint {
  int get contentColumns => switch (this) {
    AppBreakpoint.compact => 1,
    AppBreakpoint.medium => 2,
    AppBreakpoint.expanded => 3,
  };

  double get horizontalPadding => switch (this) {
    AppBreakpoint.compact => 16,
    AppBreakpoint.medium => 24,
    AppBreakpoint.expanded => 32,
  };

  double get sectionSpacing => switch (this) {
    AppBreakpoint.compact => 12,
    AppBreakpoint.medium => 16,
    AppBreakpoint.expanded => 20,
  };

  double get maxContentWidth => switch (this) {
    AppBreakpoint.compact => double.infinity,
    AppBreakpoint.medium => 960,
    AppBreakpoint.expanded => 1280,
  };
}
