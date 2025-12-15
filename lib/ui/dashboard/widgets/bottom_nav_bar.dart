import 'package:flutter/material.dart';
import '../../events/favorites_screen.dart';
import '../../events/event_wizard_screen.dart';
import '../../notifications/notifications_screen.dart';
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
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Botón Casa (Dashboard)
              _NavBarButton(
                icon: Icons.home,
                isActive: currentRoute == 'home' || currentRoute == '',
                onTap: () {
                  // Navegar al dashboard principal
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
              // Botón Favoritos
              _NavBarButton(
                icon: Icons.favorite_border,
                isActive: currentRoute == 'favorites',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const FavoritesScreen(),
                    ),
                  );
                },
              ),
              // Botón Crear Evento
              _NavBarButton(
                icon: Icons.add_circle,
                isActive: currentRoute == 'submit',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const EventWizardScreen(),
                    ),
                  );
                },
              ),
              // Botón Modo Oscuro
              ValueListenableBuilder<ThemeMode>(
                valueListenable: appThemeMode,
                builder: (context, mode, _) {
                  return _NavBarButton(
                    icon: mode == ThemeMode.dark
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    isActive: false, // El tema no es una pantalla activa
                    onTap: () {
                      // Toggle entre claro y oscuro
                      appThemeMode.value = mode == ThemeMode.dark
                          ? ThemeMode.light
                          : ThemeMode.dark;
                    },
                  );
                },
              ),
              // Botón Notificaciones
              _NavBarButton(
                icon: Icons.notifications_outlined,
                isActive: currentRoute == 'notifications',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const NotificationsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;
  final bool isDisabled;

  const _NavBarButton({
    required this.icon,
    required this.onTap,
    this.isActive = false,
    this.isDisabled = false,
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
          borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: isActive
                  ? BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    )
                  : null,
              child: Center(
                child: Icon(
                  icon,
                  size: 24,
                  color: color,
                ),
              ),
            ),
        ),
      ),
    );
  }
}

