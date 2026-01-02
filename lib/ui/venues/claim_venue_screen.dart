import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/venue.dart';
import '../../services/venue_ownership_service.dart';
import '../../services/auth_service.dart';

class ClaimVenueScreen extends StatefulWidget {
  final Venue venue;
  
  const ClaimVenueScreen({
    super.key,
    required this.venue,
  });

  @override
  State<ClaimVenueScreen> createState() => _ClaimVenueScreenState();
}

class _ClaimVenueScreenState extends State<ClaimVenueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contactInfoController = TextEditingController();
  String _selectedMethod = 'email';
  bool _isLoading = false;
  String? _error;
  String? _successMessage;
  String? _requestId;

  @override
  void dispose() {
    _contactInfoController.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    // Verificar autenticación
    if (!AuthService.instance.isAuthenticated) {
      setState(() {
        _error = 'Debes iniciar sesión para solicitar ser propietario';
      });
      return;
    }

    // Verificar si el venue ya tiene dueño
    final hasOwner = await VenueOwnershipService.instance
        .venueHasOwner(widget.venue.id);
    
    if (hasOwner) {
      setState(() {
        _error = 'Este venue ya tiene un dueño verificado';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _successMessage = null;
    });

    try {
      final requestId = await VenueOwnershipService.instance.requestOwnership(
        venueId: widget.venue.id,
        verificationMethod: _selectedMethod,
        contactInfo: _contactInfoController.text.trim(),
      );

      setState(() {
        _requestId = requestId;
        _successMessage = 'Solicitud enviada correctamente. '
            'Los administradores se pondrán en contacto contigo para verificar tu identidad.';
        _isLoading = false;
      });
    } catch (e) {
      String errorMessage = e.toString().replaceAll('Exception: ', '');
      
      // Mejorar mensaje de error para solicitud duplicada
      if (errorMessage.contains('Ya existe una solicitud activa')) {
        errorMessage = 'Ya tienes una solicitud pendiente para este local. '
            'Los administradores se pondrán en contacto contigo pronto.';
      } else if (errorMessage.contains('PostgrestException')) {
        // Extraer solo el mensaje útil del error de Postgrest
        final match = RegExp(r'message: ([^,]+)').firstMatch(errorMessage);
        if (match != null) {
          errorMessage = match.group(1) ?? errorMessage;
        }
      }
      
      setState(() {
        _error = errorMessage;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitar Propiedad'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Información del venue
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Local a reclamar',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.venue.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (widget.venue.cityName != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          widget.venue.cityName!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Explicación
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
                            'Proceso de verificación',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Para verificar que eres el dueño del negocio, los administradores se pondrán en contacto contigo a través del método que elijas. Te enviarán un código de verificación que deberás introducir en la app.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Método de verificación
              Text(
                'Método de contacto',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              
              RadioListTile<String>(
                title: const Text('Email'),
                subtitle: const Text('Te contactaremos por correo electrónico'),
                value: 'email',
                groupValue: _selectedMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedMethod = value!;
                  });
                },
              ),
              
              RadioListTile<String>(
                title: const Text('Teléfono'),
                subtitle: const Text('Te contactaremos por WhatsApp o SMS'),
                value: 'phone',
                groupValue: _selectedMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedMethod = value!;
                  });
                },
              ),
              
              RadioListTile<String>(
                title: const Text('Redes Sociales'),
                subtitle: const Text('Instagram, Facebook, Twitter, etc.'),
                value: 'social_media',
                groupValue: _selectedMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedMethod = value!;
                  });
                },
              ),
              
              const SizedBox(height: 24),
              
              // Campo de contacto
              TextFormField(
                controller: _contactInfoController,
                decoration: InputDecoration(
                  labelText: _selectedMethod == 'email'
                      ? 'Email'
                      : _selectedMethod == 'phone'
                          ? 'Teléfono'
                          : 'Handle de redes sociales',
                  hintText: _selectedMethod == 'email'
                      ? 'ejemplo@email.com'
                      : _selectedMethod == 'phone'
                          ? '+34 600 000 000'
                          : '@usuario o nombre de perfil',
                  prefixIcon: Icon(
                    _selectedMethod == 'email'
                        ? Icons.email
                        : _selectedMethod == 'phone'
                            ? Icons.phone
                            : Icons.public,
                  ),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: _selectedMethod == 'email'
                    ? TextInputType.emailAddress
                    : _selectedMethod == 'phone'
                        ? TextInputType.phone
                        : TextInputType.text,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Este campo es obligatorio';
                  }
                  if (_selectedMethod == 'email' && !value.contains('@')) {
                    return 'Introduce un email válido';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 32),
              
              // Mensajes de error/éxito
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
              
              if (_successMessage != null)
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _successMessage!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_requestId != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            'ID de solicitud: $_requestId',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              
              const SizedBox(height: 16),
              
              // Botón de envío
              ElevatedButton(
                onPressed: _isLoading ? null : _submitRequest,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Enviar solicitud'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

