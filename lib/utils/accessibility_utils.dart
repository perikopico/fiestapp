import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Utilidades para mejorar la accesibilidad de la app
class AccessibilityUtils {
  AccessibilityUtils._();

  /// Crea un widget con etiquetas semánticas mejoradas
  static Widget withSemantics({
    required Widget child,
    String? label,
    String? hint,
    String? value,
    bool? button,
    bool? header,
    bool? image,
    bool? link,
    bool? textField,
    VoidCallback? onTap,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      value: value,
      button: button,
      header: header,
      image: image,
      link: link,
      textField: textField,
      onTap: onTap,
      child: child,
    );
  }

  /// Crea una etiqueta semántica para un botón
  static Widget buttonSemantics({
    required Widget child,
    required String label,
    String? hint,
    VoidCallback? onTap,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: true,
      onTap: onTap,
      child: child,
    );
  }

  /// Crea una etiqueta semántica para una imagen
  static Widget imageSemantics({
    required Widget child,
    required String label,
    String? hint,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      image: true,
      child: child,
    );
  }

  /// Crea una etiqueta semántica para un header/título
  static Widget headerSemantics({
    required Widget child,
    required String label,
    int? level,
  }) {
    return Semantics(
      label: label,
      header: true,
      child: child,
    );
  }

  /// Crea una etiqueta semántica para un enlace
  static Widget linkSemantics({
    required Widget child,
    required String label,
    String? hint,
    VoidCallback? onTap,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      link: true,
      onTap: onTap,
      child: child,
    );
  }
}
