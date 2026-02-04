import 'package:flutter/material.dart';

/// Muestra un SnackBar en la parte superior de la pantalla para no tapar
/// la barra de navegación inferior (inicio, favoritos, notificaciones, etc.).
void showTopSnackBar(
  BuildContext context, {
  required String message,
  Duration duration = const Duration(seconds: 2),
  SnackBarAction? action,
}) {
  final media = MediaQuery.of(context);
  final bottomMargin = media.size.height - 120;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 60,
        bottom: bottomMargin,
      ),
      action: action,
    ),
  );
}
