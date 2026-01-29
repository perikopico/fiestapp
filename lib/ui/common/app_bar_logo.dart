import 'package:flutter/material.dart';

/// Logo de QuePlan para AppBar/SliverAppBar. Mismo aspecto que en el Dashboard.
/// Si no existe assets/logo/queplan_logo.png, se muestra el texto "QuePlan".
class AppBarLogo extends StatelessWidget {
  const AppBarLogo({super.key});

  static const String _logoAsset = 'assets/logo/queplan_logo.png';
  static const double logoHeight = 62;   // 48 * 1.3
  static const double scale = 2.6;       // 2.0 * 1.3
  static const double width = 234;       // 180 * 1.3

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: logoHeight,
        width: width,
        child: ClipRect(
          child: Center(
            child: Transform.scale(
              scale: scale,
              child: Image.asset(
                _logoAsset,
                height: logoHeight,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) {
                  return Text(
                    'QuePlan',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
