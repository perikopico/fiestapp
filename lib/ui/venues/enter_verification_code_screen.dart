// lib/ui/venues/enter_verification_code_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import '../../services/venue_ownership_service.dart';
import '../../services/auth_service.dart';

/// Pantalla para que el usuario introduzca el código de verificación
/// que recibió del administrador
class EnterVerificationCodeScreen extends StatefulWidget {
  const EnterVerificationCodeScreen({super.key});

  @override
  State<EnterVerificationCodeScreen> createState() => _EnterVerificationCodeScreenState();
}

class _EnterVerificationCodeScreenState extends State<EnterVerificationCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  bool _isLoading = false;
  bool _isLoadingRequests = true;
  String? _error;
  bool _isVerified = false;
  List<VenueOwnershipRequest> _pendingRequests = [];
  VenueOwnershipRequest? _selectedRequest;

  @override
  void initState() {
    super.initState();
    _loadPendingRequests();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _loadPendingRequests() async {
    if (!AuthService.instance.isAuthenticated) {
      setState(() {
        _isLoadingRequests = false;
      });
      return;
    }

    setState(() {
      _isLoadingRequests = true;
      _error = null;
    });

    try {
      final allRequests = await VenueOwnershipService.instance.getMyRequests();
      // Filtrar solo las pendientes y no expiradas
      _pendingRequests = allRequests
          .where((r) => r.isPending && !r.isExpired)
          .toList();
      
      debugPrint('📋 Solicitudes pendientes encontradas: ${_pendingRequests.length}');
      
      // Si solo hay una solicitud, seleccionarla automáticamente
      if (_pendingRequests.length == 1) {
        _selectedRequest = _pendingRequests.first;
      }
    } catch (e) {
      debugPrint('❌ Error al cargar solicitudes: $e');
      setState(() {
        _error = 'Error al cargar tus solicitudes: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoadingRequests = false;
      });
    }
  }

  Future<void> _verifyCode() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedRequest == null) {
      setState(() {
        _error = 'Debes seleccionar una solicitud primero';
      });
      return;
    }

    // Verificar autenticación
    if (!AuthService.instance.isAuthenticated) {
      setState(() {
        _error = 'Debes iniciar sesión para verificar el código';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Verificar el ownership usando el código directamente
      // La función SQL buscará automáticamente la solicitud del usuario con ese código
      await VenueOwnershipService.instance.verifyOwnershipByUser(
        verificationCode: _codeController.text.trim(),
      );

      setState(() {
        _isVerified = true;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Propiedad de "${_selectedRequest!.venue?.name ?? 'el local'}" verificada correctamente!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
        
        // Recargar solicitudes y volver a la lista
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            _loadPendingRequests();
            setState(() {
              _isVerified = false;
              _selectedRequest = null;
              _codeController.clear();
            });
          }
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _selectRequest(VenueOwnershipRequest request) {
    setState(() {
      _selectedRequest = request;
      _codeController.clear();
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!AuthService.instance.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Verificar código de propiedad'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                size: 64,
                color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'Debes iniciar sesión para verificar el código',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificar código de propiedad'),
      ),
      body: _isLoadingRequests
          ? const Center(child: CircularProgressIndicator())
          : _isVerified
              ? _buildSuccessView()
              : _pendingRequests.isEmpty
                  ? _buildNoRequestsView()
                  : _selectedRequest == null
                      ? _buildRequestList()
                      : _buildCodeInput(),
    );
  }

  Widget _buildNoRequestsView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No tienes solicitudes pendientes',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Cuando solicites ser propietario de un local, aparecerá aquí para que puedas verificar el código.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Información
          Card(
            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Selecciona el local',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tienes ${_pendingRequests.length} solicitud${_pendingRequests.length > 1 ? 'es' : ''} pendiente${_pendingRequests.length > 1 ? 's' : ''}. '
                    'Selecciona el local para el que recibiste el código de verificación.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Lista de solicitudes
          ..._pendingRequests.map((request) => _buildRequestCard(request)),
        ],
      ),
    );
  }

  Widget _buildRequestCard(VenueOwnershipRequest request) {
    final venueName = request.venue?.name ?? 'Local desconocido';
    final isExpired = request.isExpired;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: isExpired ? Colors.grey[200] : null,
      child: InkWell(
        onTap: isExpired ? null : () => _selectRequest(request),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icono
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isExpired 
                      ? Colors.grey[300]
                      : Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.business,
                  color: isExpired
                      ? Colors.grey[600]
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              
              // Información
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      venueName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isExpired ? Colors.grey[600] : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Método: ${_getMethodLabel(request.verificationMethod)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isExpired ? Colors.grey[600] : null,
                      ),
                    ),
                    if (isExpired)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Expirada',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.orange[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Flecha
              if (!isExpired)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCodeInput() {
    final venueName = _selectedRequest!.venue?.name ?? 'el local';
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Botón para volver
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _selectedRequest = null;
                  _codeController.clear();
                  _error = null;
                });
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Volver a la lista'),
            ),
            
            const SizedBox(height: 16),
            
            // Información del local seleccionado
            Card(
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.business,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Local seleccionado',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            venueName,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Información
            Card(
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Introduce el código de verificación',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'El administrador te ha contactado y te ha proporcionado un código de verificación para "$venueName". '
                      'Introduce ese código aquí para completar la verificación de propiedad.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Campo de código
            TextFormField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: 'Código de verificación',
                hintText: '000000',
                prefixIcon: const Icon(Icons.vpn_key),
                border: const OutlineInputBorder(),
                helperText: 'El código tiene 6 dígitos',
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                letterSpacing: 8,
                fontWeight: FontWeight.bold,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Introduce el código de verificación';
                }
                if (value.length != 6) {
                  return 'El código debe tener 6 dígitos';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 32),
            
            // Mensaje de error
            if (_error != null)
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            const SizedBox(height: 16),
            
            // Botón de verificación
            ElevatedButton(
              onPressed: _isLoading ? null : _verifyCode,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Verificar código'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessView() {
    final venueName = _selectedRequest?.venue?.name ?? 'el local';
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 24),
            Text(
              '¡Propiedad verificada correctamente!',
              style: TextStyle(
                color: Colors.green[800],
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Ahora eres el propietario de "$venueName" y puedes gestionar sus eventos.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
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
        return method;
    }
  }
}
