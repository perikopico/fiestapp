import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fiestapp/services/auth_service.dart';
import 'package:fiestapp/l10n/app_localizations.dart';
import '../../auth/login_screen.dart';
import '../../auth/register_screen.dart';
import '../../common/app_bar_logo.dart';

/// Muestra un diálogo flotante de autenticación al abrir la app
/// Invita al registro/inicio de sesión o permite continuar sin cuenta
class AuthBanner {
  /// Muestra el diálogo flotante de autenticación si el usuario no está autenticado
  /// IMPORTANTE: Este método solo debe llamarse DESPUÉS de que el video de splash termine
  static Future<void> showAuthDialog(BuildContext context) async {
    if (AuthService.instance.isAuthenticated) return;

    // Dar tiempo a que Supabase procese el deep link de OAuth (p. ej. retorno desde Google).
    // Así, si el usuario volvió de "Continuar con Google", no mostramos el diálogo de nuevo.
    await Future.delayed(const Duration(milliseconds: 450));
    if (!context.mounted) return;
    if (AuthService.instance.isAuthenticated) return;

    await Future.delayed(const Duration(milliseconds: 450));
    if (!context.mounted) return;
    if (AuthService.instance.isAuthenticated) return;

    await showDialog(
      context: context,
      barrierDismissible: true,
      useRootNavigator: true,
      builder: (context) => const _AuthDialog(),
    );
  }
}

class _AuthDialog extends StatefulWidget {
  const _AuthDialog();

  @override
  State<_AuthDialog> createState() => _AuthDialogState();
}

class _AuthDialogState extends State<_AuthDialog> {
  StreamSubscription<AuthState>? _authSub;

  @override
  void initState() {
    super.initState();
    _authSub = AuthService.instance.authStateChanges.listen((state) {
      if (!mounted) return;
      if (state.event == AuthChangeEvent.signedIn) {
        _authSub?.cancel();
        Navigator.of(context, rootNavigator: true).pop();
      }
    });
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final navigator = Navigator.of(context, rootNavigator: true);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo y botón cerrar (misma identidad que el resto de la app)
            Row(
              children: [
                const Expanded(child: SizedBox()),
                const Expanded(
                  flex: 2,
                  child: AppBarLogo(),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.close, color: colorScheme.onSurfaceVariant),
                      onPressed: () => navigator.pop(),
                      style: IconButton.styleFrom(
                        backgroundColor: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Título y subtítulo (colores del tema)
            Text(
              AppLocalizations.of(context)!.createAccount,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.saveFavoritesCreateEvents,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Botones (FilledButton / OutlinedButton, radio 14 como en la app)
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      navigator.pop();
                      navigator.push(
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.signUp,
                      style: theme.textTheme.labelLarge,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () {
                      navigator.pop();
                      navigator.push(
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.signIn,
                      style: theme.textTheme.labelLarge,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => navigator.pop(),
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.onSurfaceVariant,
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: Text(
                AppLocalizations.of(context)!.continueWithoutAccount,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Banner que aparece cuando el usuario no está autenticado (LEGACY - ya no se usa)
/// Invita al registro/inicio de sesión o permite continuar sin cuenta
class AuthBannerLegacy extends StatefulWidget {
  final VoidCallback? onDismiss;
  
  const AuthBannerLegacy({
    super.key,
    this.onDismiss,
  });

  @override
  State<AuthBannerLegacy> createState() => _AuthBannerLegacyState();
}

class _AuthBannerLegacyState extends State<AuthBannerLegacy> {
  bool _isDismissed = false;

  @override
  Widget build(BuildContext context) {
    // Usar StreamBuilder para escuchar cambios de autenticación
    return StreamBuilder(
      stream: AuthService.instance.authStateChanges,
      builder: (context, snapshot) {
        // Si el usuario ya está autenticado, no mostrar el banner
        if (AuthService.instance.isAuthenticated) {
          return const SizedBox.shrink();
        }

        // Si el banner fue descartado, no mostrarlo
        if (_isDismissed) {
          return const SizedBox.shrink();
        }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_add_rounded,
                color: colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Crea tu cuenta',
                      style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Guarda tus favoritos y crea eventos',
                      style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: colorScheme.onSurfaceVariant, size: 20),
                onPressed: () {
                  setState(() {
                    _isDismissed = true;
                  });
                  widget.onDismiss?.call();
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const RegisterScreen(),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Registrarse'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.tonal(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Iniciar sesión'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              setState(() {
                _isDismissed = true;
              });
              widget.onDismiss?.call();
            },
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.onSurfaceVariant,
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
            child: const Text('Continuar sin cuenta'),
          ),
        ],
      ),
      );
      },
    );
  }
}

