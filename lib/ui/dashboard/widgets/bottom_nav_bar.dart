import 'dart:ui';
import 'package:flutter/material.dart';
import '../../events/favorites_screen.dart';
import '../../events/event_wizard_screen.dart';
import '../../auth/profile_screen.dart';
import '../../../main.dart' show appThemeMode;

class BottomNavBar extends StatelessWidget {
  final String? activeRoute;
  
  const BottomNavBar({super.key, this.activeRoute});

  // Detectar qué pantalla está activa
  String _getCurrentRoute(BuildContext context) {
    // Si se proporciona explícitamente, usarlo
    if (activeRoute != null) return activeRoute!;
    
    // Intentar detectar por el contexto
    // Si no podemos hacer pop, estamos en el dashboard (primera pantalla)
    if (!Navigator.of(context).canPop()) {
      return 'home';
    }
    
    // Por defecto, asumir que estamos en el dashboard
    return 'home';
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = _getCurrentRoute(context);
    final theme = Theme.of(context);
    
    // Contenedor completamente transparente - sin fondo
    // El Scaffold ya tiene extendBody: true, así que el fondo se extiende detrás
    return Container(
      // Contenedor completamente transparente - sin fondo
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      height: 90, // Altura suficiente para la galleta flotante
      padding: const EdgeInsets.only(bottom: 8),
      child: Center(
        child: Container(
          height: 70,
          constraints: const BoxConstraints(maxWidth: 320), // Ancho máximo de la galleta
          decoration: BoxDecoration(
            // Sin fondo - solo borde y sombra para definir la isla flotante
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.15),
              width: 0.5,
            ),
            // Efecto glassmorphism (blur)
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
            // Sin fondo de color - completamente transparente
            color: Colors.transparent,
          ),
          // BackdropFilter para el efecto de vidrio (glassmorphism)
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30), // Efecto de vidrio esmerilado
              child: Container(
                // Fondo semitransparente para el efecto glassmorphism
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withOpacity(0.7), // Fondo semitransparente
                  borderRadius: BorderRadius.circular(32),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Botón Casa (Inicio)
                    _NavBarButton(
                      icon: Icons.home,
                      label: 'Inicio',
                      isActive: currentRoute == 'home' || currentRoute == '',
                      onTap: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                    ),
                    // Botón Favoritos
                    _NavBarButton(
                      icon: Icons.favorite_border,
                      label: 'Fav',
                      isActive: currentRoute == 'favorites',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const FavoritesScreen(),
                          ),
                        );
                      },
                    ),
                    // Botón Crear Evento (más grande y destacado)
                    _NavBarButton(
                      icon: Icons.add_circle,
                      label: 'Crear',
                      isActive: currentRoute == 'submit',
                      isAddButton: true,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const EventWizardScreen(),
                          ),
                        );
                      },
                    ),
                    // Botón Cuenta (integrado en la barra)
                    _NavBarButton(
                      icon: Icons.person,
                      label: 'Cuenta',
                      isActive: currentRoute == 'profile',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ProfileScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;
  final bool isDisabled;
  final bool isAddButton;

  const _NavBarButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
    this.isDisabled = false,
    this.isAddButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isDisabled
        ? theme.colorScheme.onSurfaceVariant.withOpacity(0.4)
        : (isActive
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurfaceVariant);

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            decoration: isActive
                ? BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20),
                  )
                : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: isAddButton ? 26 : 22,
                  color: isAddButton && !isActive
                      ? theme.colorScheme.primary
                      : color,
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    color: isDisabled
                        ? theme.colorScheme.onSurfaceVariant.withOpacity(0.4)
                        : (isActive
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
