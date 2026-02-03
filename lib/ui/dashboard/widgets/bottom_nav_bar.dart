import 'dart:ui';
import 'package:flutter/material.dart';
import '../../events/favorites_screen.dart';
import '../../events/event_wizard_screen.dart';
import '../../auth/profile_screen.dart';
import '../../notifications/notifications_screen.dart';
import '../../../services/notifications_count_service.dart';

class BottomNavBar extends StatelessWidget {
  final String? activeRoute;

  const BottomNavBar({super.key, this.activeRoute});

  String _getCurrentRoute(BuildContext context) {
    if (activeRoute != null) return activeRoute!;
    if (!Navigator.of(context).canPop()) return 'home';
    return 'home';
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = _getCurrentRoute(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 72,
      padding: const EdgeInsets.only(bottom: 12, left: 24, right: 24),
      child: Center(
        child: Container(
          height: 52,
          constraints: const BoxConstraints(maxWidth: 240),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: (isDark ? Colors.white : Colors.black).withOpacity(0.08),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 24,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      (isDark ? Colors.white : Colors.white).withOpacity(0.25),
                      (isDark ? Colors.white : Colors.white).withOpacity(0.12),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(26),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _NavBarButton(
                      icon: Icons.home_rounded,
                      semanticLabel: 'Inicio',
                      isActive: currentRoute == 'home' || currentRoute == '',
                      onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
                    ),
                    _NavBarButton(
                      icon: Icons.favorite_border_rounded,
                      semanticLabel: 'Favoritos',
                      isActive: currentRoute == 'favorites',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                      ),
                    ),
                    _NavBarButton(
                      icon: Icons.add_circle_rounded,
                      semanticLabel: 'Crear evento',
                      isActive: currentRoute == 'submit',
                      isAddButton: true,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const EventWizardScreen()),
                      ),
                    ),
                    ValueListenableBuilder<int>(
                      valueListenable: NotificationsCountService.instance.unreadCount,
                      builder: (context, count, _) => _NavBarButton(
                        icon: Icons.notifications_outlined,
                        semanticLabel: 'Notificaciones',
                        isActive: currentRoute == 'notifications',
                        badgeCount: count > 0 ? count : null,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                        ),
                      ),
                    ),
                    _NavBarButton(
                      icon: Icons.person_outline_rounded,
                      semanticLabel: 'Cuenta',
                      isActive: currentRoute == 'profile',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ProfileScreen()),
                      ),
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
  final VoidCallback onTap;
  final bool isActive;
  final bool isAddButton;
  final int? badgeCount;
  final String? semanticLabel;

  const _NavBarButton({
    required this.icon,
    required this.onTap,
    this.isActive = false,
    this.isAddButton = false,
    this.badgeCount,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isActive
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant.withOpacity(0.8);

    return Expanded(
      child: Semantics(
        label: semanticLabel,
        button: true,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Icon(
                    icon,
                    size: isAddButton ? 28 : 24,
                    color: isAddButton && !isActive ? theme.colorScheme.primary : color,
                  ),
                  if (badgeCount != null && badgeCount! > 0)
                    Positioned(
                      right: 4,
                      top: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          badgeCount! > 99 ? '99+' : badgeCount.toString(),
                          style: TextStyle(
                            color: theme.colorScheme.onError,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
