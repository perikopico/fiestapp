import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:intl/intl.dart';
import '../../services/venue_ownership_service.dart';
import '../../services/auth_service.dart';
import '../venues/verify_ownership_screen.dart';

class VenueOwnershipRequestsScreen extends StatefulWidget {
  const VenueOwnershipRequestsScreen({super.key});

  @override
  State<VenueOwnershipRequestsScreen> createState() => _VenueOwnershipRequestsScreenState();
}

class _VenueOwnershipRequestsScreenState extends State<VenueOwnershipRequestsScreen> {
  bool _isLoading = true;
  String? _error;
  List<VenueOwnershipRequest> _requests = [];
  final DateFormat _dateFormat = DateFormat('d MMM yyyy, HH:mm');

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Verificar que el usuario es admin
      final isAdmin = await AuthService.instance.isAdmin();
      if (!isAdmin) {
        setState(() {
          _error = 'No tienes permisos de administrador';
          _isLoading = false;
        });
        return;
      }
      
      debugPrint('🔍 Cargando solicitudes de propiedad...');
      _requests = await VenueOwnershipService.instance.getPendingRequests();
      debugPrint('✅ Solicitudes cargadas: ${_requests.length}');
      
      if (_requests.isEmpty) {
        debugPrint('ℹ️ No hay solicitudes pendientes');
      }
    } catch (e) {
      debugPrint('❌ Error al cargar solicitudes: $e');
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _verifyRequest(VenueOwnershipRequest request) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerifyOwnershipScreen(requestId: request.id),
      ),
    );

    if (result == true) {
      _loadRequests();
    }
  }

  Future<void> _rejectRequest(VenueOwnershipRequest request) async {
    String? reason;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final reasonController = TextEditingController();
        return AlertDialog(
          title: const Text('Rechazar solicitud'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('¿Estás seguro de que quieres rechazar la solicitud de "${request.venue?.name ?? 'venue'}"?'),
              const SizedBox(height: 16),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  labelText: 'Razón del rechazo (opcional)',
                  hintText: 'Ej: No se pudo verificar la identidad',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) => reason = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Rechazar'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await VenueOwnershipService.instance.rejectOwnership(
        requestId: request.id,
        reason: reason?.trim().isEmpty == true ? null : reason?.trim(),
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Solicitud rechazada')),
        );
        _loadRequests();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al rechazar solicitud: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitudes de Propiedad'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadRequests,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadRequests,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : _requests.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 64,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No hay solicitudes pendientes',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Todas las solicitudes han sido procesadas',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadRequests,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _requests.length,
                        itemBuilder: (context, index) {
                          final request = _requests[index];
                          return _buildRequestCard(request);
                        },
                      ),
                    ),
    );
  }

  Widget _buildRequestCard(VenueOwnershipRequest request) {
    final isExpired = request.isExpired;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: isExpired ? Colors.grey[200] : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Row(
              children: [
                Expanded(
                  child: Text(
                    request.venue?.name ?? 'Venue desconocido',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                if (isExpired)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'EXPIRADO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Información de contacto
            _buildInfoRow(
              Icons.person,
              'Usuario',
              request.userId ?? 'Desconocido',
            ),
            
            _buildInfoRow(
              _getMethodIcon(request.verificationMethod),
              _getMethodLabel(request.verificationMethod),
              request.contactInfo,
            ),
            
            _buildInfoRow(
              Icons.vpn_key,
              'Código de verificación',
              request.verificationCode,
              isCode: true,
            ),
            
            _buildInfoRow(
              Icons.calendar_today,
              'Fecha de solicitud',
              _dateFormat.format(request.createdAt),
            ),
            
            _buildInfoRow(
              Icons.timer,
              'Expira',
              _dateFormat.format(request.expiresAt),
              isExpired: isExpired,
            ),
            
            const SizedBox(height: 16),
            
            // Botones de acción
            if (!isExpired)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _rejectRequest(request),
                      icon: const Icon(Icons.close),
                      label: const Text('Rechazar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _verifyRequest(request),
                      icon: const Icon(Icons.check),
                      label: const Text('Verificar'),
                    ),
                  ),
                ],
              )
            else
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange[800]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Esta solicitud ha expirado',
                        style: TextStyle(
                          color: Colors.orange[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {bool isCode = false, bool isExpired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 2),
                if (isCode)
                  SelectableText(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      color: isExpired ? Colors.grey : Theme.of(context).colorScheme.primary,
                    ),
                  )
                else
                  Text(
                    value,
                    style: TextStyle(
                      color: isExpired ? Colors.grey : null,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getMethodIcon(String method) {
    switch (method) {
      case 'email':
        return Icons.email;
      case 'phone':
        return Icons.phone;
      case 'social_media':
        return Icons.public;
      default:
        return Icons.contact_mail;
    }
  }

  String _getMethodLabel(String method) {
    switch (method) {
      case 'email':
        return 'Email';
      case 'phone':
        return 'Teléfono';
      case 'social_media':
        return 'Redes Sociales';
      default:
        return 'Contacto';
    }
  }
}

