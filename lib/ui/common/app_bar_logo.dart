import 'package:flutter/material.dart';

/// Logo de QuePlan para AppBar/SliverAppBar. Mismo aspecto que en el Dashboard.
/// Si no existe assets/logo/queplan_logo.png, se muestra el texto "QuePlan".
class AppBarLogo extends StatelessWidget {
  const AppBarLogo({super.key});

  static const String _logoAsset = 'assets/logo/queplan_logo.png';
  static const double logoHeight = 48;
  static const double scale = 2.0;
  static const double width = 180;

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
                      fontSize: 20,
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
