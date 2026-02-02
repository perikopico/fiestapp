// lib/ui/notifications/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../../services/fcm_token_service.dart';
import '../common/app_bar_logo.dart';
import 'notification_settings_screen.dart';
import 'notifications_inbox_screen.dart';
import '../dashboard/widgets/bottom_nav_bar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTab = 0; // 0 = Buzón, 1 = Debug

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      _tabController = TabController(length: 2, vsync: this);
      _tabController.addListener(() {
        setState(() {
          _currentTab = _tabController.index;
        });
      });
    }
  }

  @override
  void dispose() {
    if (kDebugMode) {
      _tabController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const AppBarLogo(),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const NotificationSettingsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
            label: const Text('Configurar'),
          ),
        ],
        bottom: kDebugMode
            ? TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Buzón'),
                  Tab(text: 'Debug'),
                ],
              )
            : null,
      ),
      body: kDebugMode && _currentTab == 1
          ? _buildDebugTab(context)
          : const NotificationsInboxScreen(),
      bottomNavigationBar: const BottomNavBar(activeRoute: 'notifications'),
    );
  }

  Widget _buildDebugTab(BuildContext context) {
    String? _fcmToken;
    bool _isLoadingToken = true;
    String? _errorMessage;

    void _loadFCMToken() async {
      setState(() {
        _isLoadingToken = true;
        _errorMessage = null;
      });

      try {
        final token = await FCMTokenService.instance.getCurrentToken();
        
        if (mounted) {
          setState(() {
            _fcmToken = token;
            _isLoadingToken = false;
            if (token == null) {
              _errorMessage = 'No se pudo obtener el token. Verifica que Firebase esté inicializado y los permisos concedidos.';
            }
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _fcmToken = null;
            _isLoadingToken = false;
            _errorMessage = 'Error: ${e.toString()}';
          });
        }
      }
    }

    _loadFCMToken();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _buildFCMTokenDebugSection(context, _fcmToken, _isLoadingToken, _errorMessage, _loadFCMToken),
    );
  }

  Widget _buildFCMTokenDebugSection(
    BuildContext context,
    String? fcmToken,
    bool isLoadingToken,
    String? errorMessage,
    VoidCallback loadFCMToken,
  ) {
    final theme = Theme.of(context);
    
    return Card(
      color: theme.colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.bug_report,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Debug: FCM Token',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (isLoadingToken)
              const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else if (fcmToken != null) ...[
              Text(
                'Token:',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              SelectableText(
                fcmToken,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: fcmToken));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Token copiado al portapapeles'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.copy, size: 16),
                label: const Text('Copiar'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ] else ...[
              Icon(
                Icons.error_outline,
                size: 20,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage ?? 'No se pudo obtener el token FCM',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: loadFCMToken,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Reintentar'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

