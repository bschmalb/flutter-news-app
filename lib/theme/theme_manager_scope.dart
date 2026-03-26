import 'package:flutter/widgets.dart';
import 'package:ksta/theme/theme_manager.dart';

class ThemeManagerScope extends InheritedNotifier<ThemeManager> {
  const ThemeManagerScope({required ThemeManager themeManager, required super.child, super.key})
    : super(notifier: themeManager);

  static ThemeManager of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ThemeManagerScope>();
    assert(scope != null, 'No ThemeManagerScope found in context.');
    return scope!.notifier!;
  }

  static ThemeManager? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ThemeManagerScope>()?.notifier;
}

extension ThemeManagerContextExtension on BuildContext {
  ThemeManager get themeManager => ThemeManagerScope.of(this);
}
