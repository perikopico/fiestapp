import 'package:flutter/material.dart';

import '../../main.dart' show appThemeMode;

/// Botón reutilizable para alternar entre modo claro y oscuro.
class ThemeModeToggleAction extends StatelessWidget {
  const ThemeModeToggleAction({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Theme.of(context).brightness == Brightness.dark
            ? Icons.wb_sunny_outlined
            : Icons.nightlight_round,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      onPressed: () {
        // Alternar entre claro y oscuro
        if (appThemeMode.value == ThemeMode.dark) {
          appThemeMode.value = ThemeMode.light;
        } else {
          appThemeMode.value = ThemeMode.dark;
        }
      },
    );
  }
}
