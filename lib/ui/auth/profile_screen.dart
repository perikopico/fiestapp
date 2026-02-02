import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/url_helper.dart';
import 'package:fiestapp/services/auth_service.dart';
import '../../services/account_deletion_service.dart';
import '../../services/data_export_service.dart';
import '../common/app_bar_logo.dart';
import '../admin/pending_events_screen.dart';
import '../admin/pending_venues_screen.dart';
import '../admin/venue_ownership_requests_screen.dart';
import '../admin/event_ingestion_screen.dart';
import '../events/favorites_screen.dart';
import '../events/my_events_screen.dart';
import '../venues/owner_events_screen.dart';
import '../venues/request_venue_ownership_screen.dart';
import '../venues/enter_verification_code_screen.dart';
import '../venues/my_venues_screen.dart';
import '../legal/gdpr_consent_screen.dart';
import '../legal/about_screen.dart';
import '../../services/venue_ownership_service.dart';
import '../../services/favorites_local_service.dart';
import '../notifications/alerts_screen.dart';
import '../notifications/notification_settings_screen.dart';
import '../../main.dart' show appThemeMode;
import 'login_screen.dart';
import 'register_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService.instance;
  bool _isLoading = false;
  bool _isAdmin = false;
  bool _isVenueOwner = false;
  int _favoriteCount = 0;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
    _checkVenueOwnerStatus();
    _loadFavoriteCount();
  }

  Future<void> _loadFavoriteCount() async {
    final ids = await FavoritesLocalService.instance.getFavoriteIds();
    if (mounted) setState(() => _favoriteCount = ids.length);
  }

  Future<void> _checkAdminStatus() async {
    final admin = await _authService.isAdmin();
    if (mounted) {
      setState(() {
        _isAdmin = admin;
      });
    }
  }

  Future<void> _checkVenueOwnerStatus() async {
    if (!_authService.isAuthenticated) return;

    try {
      final myVenues = await VenueOwnershipService.instance.getMyVenues();
      if (mounted) {
        setState(() {
          _isVenueOwner = myVenues.isNotEmpty;
        });
      }
    } catch (e) {
      // Silenciar errores, solo no mostrar la opción
    }
  }

  Future<void> _handleSignOut() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      await _authService.signOut();
      if (!mounted) return;

      // Navegar al dashboard y mostrar mensaje
      Navigator.of(context).popUntil((route) => route.isFirst);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Sesión cerrada')));
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cerrar sesión: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _openAdminPanel() async {
    // Verificar que el usuario es admin antes de abrir el panel
    final isAdmin = await _authService.isAdmin();
    if (!isAdmin) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No tienes permisos de administrador'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Si es admin, abrir directamente el panel
    if (!mounted) return;
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const PendingEventsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    final isAuthenticated = _authService.isAuthenticated;

    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const AppBarLogo(),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  // Si no está autenticado, mostrar opciones de login/registro
                  if (!isAuthenticated) ...[
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            child: Icon(
                              Icons.person,
                              size: 48,
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Inicia sesión o regístrate',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Crea una cuenta para guardar tus favoritos y crear eventos',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Botones de registro e inicio de sesión
                    FilledButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.person_add),
                      label: const Text('Registrarse'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.login),
                      label: const Text('Iniciar sesión'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Información y legal (también visible sin cuenta)
                    _buildSection(context, 'Información', [
                      _buildListItem(
                        context,
                        icon: Icons.info_outline,
                        title: 'Sobre QuePlan',
                        subtitle: 'Versión, descripción y enlaces',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const AboutScreen(),
                            ),
                          );
                        },
                      ),
                      _buildListItem(
                        context,
                        icon: Icons.privacy_tip,
                        title: 'Política de Privacidad',
                        subtitle: 'Cómo protegemos tus datos',
                        onTap: () => _openPrivacyPolicy(),
                      ),
                      _buildListItem(
                        context,
                        icon: Icons.description,
                        title: 'Términos y Condiciones',
                        subtitle: 'Términos de uso de la app',
                        onTap: () => _openTerms(),
                      ),
                    ]),
                  ] else ...[
                    // Contenido cuando está autenticado
                    Builder(
                      builder: (context) {
                        final email = user?.email ?? 'Usuario';
                        return Column(
                          children: [
                            // Avatar y email
                            Center(
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 48,
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                                    child: Icon(
                                      Icons.person,
                                      size: 48,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    email,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  if (user?.emailConfirmedAt == null) ...[
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.errorContainer,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.warning_amber_rounded,
                                            size: 16,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onErrorContainer,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Email no verificado',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onErrorContainer,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
                            // Sección de acciones
                            _buildSection(context, 'Cuenta', [
                              // Toggle de tema oscuro/claro
                              ValueListenableBuilder<ThemeMode>(
                                valueListenable: appThemeMode,
                                builder: (context, mode, _) {
                                  final isDark =
                                      mode == ThemeMode.dark ||
                                      (mode == ThemeMode.system &&
                                          MediaQuery.of(
                                                context,
                                              ).platformBrightness ==
                                              Brightness.dark);
                                  final modeText = mode == ThemeMode.system
                                      ? 'Automático'
                                      : (mode == ThemeMode.dark
                                            ? 'Oscuro'
                                            : 'Claro');

                                  return _buildListItem(
                                    context,
                                    icon: isDark
                                        ? Icons.dark_mode
                                        : Icons.light_mode,
                                    title: 'Tema',
                                    subtitle: modeText,
                                    onTap: () {
                                      // Si está en system, cambiar a dark. Si está en dark, cambiar a light. Si está en light, cambiar a system
                                      if (mode == ThemeMode.system) {
                                        appThemeMode.value = ThemeMode.dark;
                                      } else if (mode == ThemeMode.dark) {
                                        appThemeMode.value = ThemeMode.light;
                                      } else {
                                        appThemeMode.value = ThemeMode.system;
                                      }
                                    },
                                  );
                                },
                              ),
                              // Preferencias de Notificaciones
                              _buildListItem(
                                context,
                                icon: Icons.notifications_outlined,
                                title: 'Preferencias de Notificaciones',
                                subtitle: 'Configurar ciudades y categorías',
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const NotificationSettingsScreen(),
                                    ),
                                  );
                                },
                              ),
                              // Mis Alertas
                              _buildListItem(
                                context,
                                icon: Icons.notifications_active_outlined,
                                title: 'Mis Alertas',
                                subtitle: 'Notificaciones por categoría de eventos',
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const AlertsScreen(),
                                    ),
                                  );
                                },
                              ),
                              if (_isAdmin) ...[
                                _buildListItem(
                                  context,
                                  icon: Icons.admin_panel_settings,
                                  title: 'Panel de administración',
                                  subtitle: 'Gestionar eventos pendientes',
                                  onTap: _openAdminPanel,
                                ),
                                _buildListItem(
                                  context,
                                  icon: Icons.upload_file,
                                  title: 'Ingesta de eventos JSON',
                                  subtitle: 'Subir/modificar eventos desde JSON',
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const EventIngestionScreen(),
                                      ),
                                    );
                                  },
                                ),
                                _buildListItem(
                                  context,
                                  icon: Icons.place,
                                  title: 'Lugares pendientes',
                                  subtitle: 'Aprobar o rechazar lugares',
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const PendingVenuesScreen(),
                                      ),
                                    );
                                  },
                                ),
                                _buildListItem(
                                  context,
                                  icon: Icons.verified_user,
                                  title: 'Solicitudes de propiedad',
                                  subtitle: 'Gestionar solicitudes de locales',
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const VenueOwnershipRequestsScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                              if (_isVenueOwner) ...[
                                _buildListItem(
                                  context,
                                  icon: Icons.store,
                                  title: 'Mis locales',
                                  subtitle: 'Ver y gestionar mis locales',
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => const MyVenuesScreen(),
                                      ),
                                    );
                                  },
                                ),
                                _buildListItem(
                                  context,
                                  icon: Icons.business,
                                  title: 'Mis eventos de venues',
                                  subtitle: 'Eventos de tus locales pendientes de aprobar',
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const OwnerEventsScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                              _buildListItem(
                                context,
                                icon: Icons.favorite,
                                title: 'Mis favoritos',
                                subtitle: _favoriteCount == 0
                                    ? 'Eventos que guardas para ver después'
                                    : '$_favoriteCount evento${_favoriteCount == 1 ? '' : 's'} guardado${_favoriteCount == 1 ? '' : 's'}',
                                onTap: () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const FavoritesScreen(),
                                    ),
                                  );
                                  _loadFavoriteCount();
                                },
                              ),
                              _buildListItem(
                                context,
                                icon: Icons.event_note,
                                title: 'Mis eventos creados',
                                subtitle: 'Eventos que tú has publicado',
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const MyEventsScreen(),
                                    ),
                                  );
                                },
                              ),
                              _buildListItem(
                                context,
                                icon: Icons.business_center,
                                title: 'Solicitar ser propietario',
                                subtitle: 'Reclamar tu negocio o lugar en la app',
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const RequestVenueOwnershipScreen(),
                                    ),
                                  );
                                },
                              ),
                              _buildListItem(
                                context,
                                icon: Icons.vpn_key,
                                title: 'Verificar código de propiedad',
                                subtitle: 'Código que te envía el equipo tras solicitar un local',
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const EnterVerificationCodeScreen(),
                                    ),
                                  );
                                },
                              ),
                            ]),
                            const SizedBox(height: 24),
                            // Legal y Privacidad
                            _buildSection(context, 'Legal y Privacidad', [
                              _buildListItem(
                                context,
                                icon: Icons.privacy_tip,
                                title: 'Política de Privacidad',
                                subtitle: 'Cómo protegemos tus datos',
                                onTap: () => _openPrivacyPolicy(),
                              ),
                              _buildListItem(
                                context,
                                icon: Icons.description,
                                title: 'Términos y Condiciones',
                                subtitle: 'Términos de uso de la app',
                                onTap: () => _openTerms(),
                              ),
                              _buildListItem(
                                context,
                                icon: Icons.settings,
                                title: 'Gestionar consentimientos',
                                subtitle: 'Aceptar o cambiar permisos de datos (RGPD)',
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const GDPRConsentScreen(),
                                    ),
                                  );
                                },
                              ),
                              _buildListItem(
                                context,
                                icon: Icons.download,
                                title: 'Exportar mis datos',
                                subtitle: 'Descargar una copia de tus datos (derecho RGPD)',
                                onTap: _exportUserData,
                              ),
                            ]),
                            const SizedBox(height: 24),
                            // Información
                            _buildSection(context, 'Información', [
                              _buildListItem(
                                context,
                                icon: Icons.info_outline,
                                title: 'Sobre QuePlan',
                                subtitle: 'Versión, descripción y contacto',
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const AboutScreen(),
                                    ),
                                  );
                                },
                              ),
                              _buildListItem(
                                context,
                                icon: Icons.badge,
                                title: 'ID de usuario',
                                subtitle: 'Para soporte técnico',
                                onTap: () {
                                  final id = user?.id ?? 'N/A';
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('ID: $id'),
                                      duration: const Duration(seconds: 3),
                                      action: id != 'N/A'
                                          ? SnackBarAction(
                                              label: 'Copiar',
                                              onPressed: () {
                                                Clipboard.setData(ClipboardData(text: id));
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text('ID copiado al portapapeles'),
                                                    duration: Duration(seconds: 1),
                                                  ),
                                                );
                                              },
                                            )
                                          : null,
                                    ),
                                  );
                                },
                              ),
                            ]),
                            const SizedBox(height: 32),
                            // Cerrar sesión y Eliminar cuenta
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton.icon(
                                        onPressed: _handleSignOut,
                                        icon: const Icon(Icons.logout, size: 20),
                                        label: const Text('Cerrar sesión'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Theme.of(
                                            context,
                                          ).colorScheme.error,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 14,
                                          ),
                                          minimumSize: const Size(double.infinity, 48),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          side: BorderSide(
                                            color: Theme.of(context).colorScheme.error,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton.icon(
                                        onPressed: _showDeleteAccountDialog,
                                        icon: const Icon(Icons.delete_forever, size: 20),
                                        label: const Text('Eliminar cuenta'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.red,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 14,
                                          ),
                                          minimumSize: const Size(double.infinity, 48),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          side: const BorderSide(color: Colors.red),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1)
                  Divider(
                    height: 1,
                    indent: 56,
                    endIndent: 16,
                    color: theme.dividerColor.withOpacity(0.5),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 22, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openPrivacyPolicy() async {
    await UrlHelper.launchUrlSafely(
      context,
      'https://queplan-app.com/privacy',
      errorMessage: 'No se pudo abrir la política de privacidad',
    );
  }

  Future<void> _openTerms() async {
    await UrlHelper.launchUrlSafely(
      context,
      'https://queplan-app.com/terms',
      errorMessage: 'No se pudo abrir los términos y condiciones',
    );
  }

  Future<void> _exportUserData() async {
    setState(() => _isLoading = true);

    try {
      // Obtener sharePositionOrigin para iOS
      Rect? sharePositionOrigin;
      if (mounted) {
        final RenderBox? box = context.findRenderObject() as RenderBox?;
        if (box != null && box.hasSize) {
          final screenSize = MediaQuery.of(context).size;
          // Usar el centro de la pantalla como posición de origen
          sharePositionOrigin = Rect.fromLTWH(
            screenSize.width / 2,
            screenSize.height / 2,
            0,
            0,
          );
        }
      }

      await DataExportService.instance.exportUserData(
        sharePositionOrigin: sharePositionOrigin ?? Rect.zero,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Datos exportados correctamente'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al exportar datos: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _showDeleteAccountDialog() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Eliminar cuenta'),
        content: const Text(
          'Esta acción no se puede deshacer. Se eliminarán de forma permanente:\n\n'
          '• Tus favoritos y preferencias\n'
          '• Tus consentimientos de privacidad\n'
          '• Tus datos asociados a eventos (los eventos públicos se mantendrán pero sin vincularse a tu usuario)\n\n'
          'Tu identificador técnico en el sistema podrá conservarse durante un tiempo limitado solo para fines legales y de seguridad.\n\n'
          '¿Estás seguro de que quieres solicitar la eliminación de tu cuenta?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar cuenta'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // Confirmación final
    final finalConfirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Última confirmación'),
        content: const Text(
          'Esta es tu última oportunidad. ¿Realmente quieres eliminar tu cuenta permanentemente?\n\n'
          'Todos tus datos serán eliminados y no podrás recuperarlos.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('SÍ, ELIMINAR'),
          ),
        ],
      ),
    );

    if (finalConfirm != true) return;

    setState(() => _isLoading = true);

    try {
      await AccountDeletionService.instance.deleteAccount();

      if (!mounted) return;

      Navigator.of(context).popUntil((route) => route.isFirst);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cuenta eliminada correctamente'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar cuenta: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}
