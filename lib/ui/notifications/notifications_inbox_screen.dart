// lib/ui/notifications/notifications_inbox_screen.dart
// Pantalla de buzón de notificaciones (historial completo)

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../common/app_bar_logo.dart';
import '../event/event_detail_screen.dart';
import '../../services/auth_service.dart';
import '../../services/notifications_count_service.dart';
import '../../services/event_service.dart';

class NotificationsInboxScreen extends StatefulWidget {
  const NotificationsInboxScreen({super.key});

  @override
  State<NotificationsInboxScreen> createState() => _NotificationsInboxScreenState();
}

class _NotificationsInboxScreenState extends State<NotificationsInboxScreen> {
  final AuthService _authService = AuthService.instance;
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  @override
  void dispose() {
    // Actualizar conteo cuando se cierra la pantalla
    NotificationsCountService.instance.getUnreadCount();
    super.dispose();
  }

  Future<void> _loadNotifications() async {
    if (!_authService.isAuthenticated) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Debes iniciar sesión para ver tus notificaciones';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final userId = _authService.currentUserId;
      if (userId == null) {
        throw Exception('Usuario no autenticado');
      }

      // Obtener notificaciones no leídas directamente desde la tabla
      // Usar filter con operador 'is' para verificar NULL (debe ser string 'null')
      final unreadResponse = await Supabase.instance.client
          .from('notifications_history')
          .select()
          .eq('user_id', userId)
          .filter('read_at', 'is', 'null')
          .order('sent_at', ascending: false)
          .limit(100);

      // También obtener las leídas recientes (últimas 50)
      final readResponse = await Supabase.instance.client
          .from('notifications_history')
          .select()
          .eq('user_id', userId)
          .not('read_at', 'is', null)
          .order('sent_at', ascending: false)
          .limit(50);

      final unread = (unreadResponse as List).cast<Map<String, dynamic>>();
      final read = (readResponse as List).cast<Map<String, dynamic>>();

      setState(() {
        _notifications = [...unread, ...read];
        _isLoading = false;
      });
      
      // Actualizar el conteo global después de cargar
      NotificationsCountService.instance.getUnreadCount();
    } catch (e) {
      debugPrint('Error cargando notificaciones: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Error al cargar notificaciones: ${e.toString()}';
      });
    }
  }

  Future<void> _markAsRead(String notificationId) async {
    if (!_authService.isAuthenticated) return;

    try {
      final userId = _authService.currentUserId;
      if (userId == null) return;

      // Marcar como leída usando la función SQL
      await Supabase.instance.client.rpc(
        'mark_notification_as_read',
        params: {
          'p_notification_id': notificationId,
          'p_user_id': userId,
        },
      );

      // Actualizar el estado local
      setState(() {
        final index = _notifications.indexWhere((n) => n['id'] == notificationId);
        if (index != -1) {
          _notifications[index]['read_at'] = DateTime.now().toIso8601String();
        }
      });
      
      // Actualizar el conteo global
      NotificationsCountService.instance.getUnreadCount();
    } catch (e) {
      debugPrint('Error marcando como leída: $e');
    }
  }

  void _handleNotificationTap(Map<String, dynamic> notification) async {
    // Marcar como leída si no lo está
    if (notification['read_at'] == null) {
      await _markAsRead(notification['id']);
    }

    // Navegar según el tipo de notificación
    final data = notification['data'] as Map<String, dynamic>? ?? {};
    final view = data['view'] as String?;
    final eventId = data['id'] as String? ?? notification['event_id'] as String?;

    if (eventId != null && (view == 'event_detail' || notification['event_id'] != null)) {
      if (!mounted) return;
      
      // Cargar el evento antes de navegar
      try {
        final events = await EventService.instance.fetchEventsByIds([eventId]);
        if (events.isNotEmpty && mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => EventDetailScreen(event: events.first),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No se pudo cargar el evento'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        debugPrint('Error cargando evento: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al cargar el evento: ${e.toString()}'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inMinutes < 1) {
        return 'Ahora';
      } else if (difference.inHours < 1) {
        return 'Hace ${difference.inMinutes} min';
      } else if (difference.inDays < 1) {
        return 'Hace ${difference.inHours} h';
      } else if (difference.inDays < 7) {
        return 'Hace ${difference.inDays} días';
      } else {
        return DateFormat('dd/MM/yyyy HH:mm').format(date);
      }
    } catch (e) {
      return dateString;
    }
  }

  IconData _getNotificationIcon(String? type) {
    switch (type) {
      case 'event_approved':
        return Icons.check_circle;
      case 'event_rejected':
        return Icons.cancel;
      case 'favorite_reminder':
        return Icons.favorite;
      case 'critical_change':
        return Icons.warning;
      case 'new_event':
        return Icons.event;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String? type, BuildContext context) {
    final theme = Theme.of(context);
    switch (type) {
      case 'event_approved':
        return Colors.green;
      case 'event_rejected':
        return Colors.red;
      case 'favorite_reminder':
        return Colors.pink;
      case 'critical_change':
        return Colors.orange;
      case 'new_event':
        return theme.colorScheme.primary;
      default:
        return theme.colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const AppBarLogo(),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        actions: [
          if (_notifications.any((n) => n['read_at'] == null))
            TextButton.icon(
              onPressed: () async {
                // Marcar todas como leídas
                for (final notification in _notifications) {
                  if (notification['read_at'] == null) {
                    await _markAsRead(notification['id']);
                  }
                }
                await _loadNotifications();
              },
              icon: const Icon(Icons.done_all),
              label: const Text('Marcar todas'),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage ?? 'Error desconocido',
                          style: theme.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: _loadNotifications,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                )
              : _notifications.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_none,
                              size: 64,
                              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No tienes notificaciones',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Te avisaremos cuando haya novedades',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadNotifications,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _notifications.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final notification = _notifications[index];
                          final isUnread = notification['read_at'] == null;
                          final type = notification['notification_type'] as String?;
                          final icon = _getNotificationIcon(type);
                          final color = _getNotificationColor(type, context);

                          return InkWell(
                            onTap: () => _handleNotificationTap(notification),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isUnread
                                    ? color.withOpacity(0.1)
                                    : theme.colorScheme.surface,
                                border: Border.all(
                                  color: isUnread
                                      ? color.withOpacity(0.3)
                                      : theme.colorScheme.outline.withOpacity(0.2),
                                  width: isUnread ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Icono
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      icon,
                                      color: color,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Contenido
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                notification['title'] as String? ?? 'Notificación',
                                                style: theme.textTheme.titleSmall?.copyWith(
                                                  fontWeight: isUnread
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                            if (isUnread)
                                              Container(
                                                width: 8,
                                                height: 8,
                                                decoration: BoxDecoration(
                                                  color: color,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          notification['body'] as String? ?? '',
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            color: theme.colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          _formatDate(notification['sent_at'] as String?),
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: theme.colorScheme.onSurfaceVariant,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
