// lib/ui/venues/request_venue_ownership_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import '../../models/venue.dart';
import '../../services/venue_service.dart';
import '../../services/venue_ownership_service.dart';
import '../../services/auth_service.dart';
import '../../services/city_service.dart' show City, CityService;
import 'claim_venue_screen.dart';
import '../common/venue_search_field.dart';

/// Pantalla para que un usuario solicite ser propietario de un venue
/// Permite buscar venues existentes o crear uno nuevo
class RequestVenueOwnershipScreen extends StatefulWidget {
  const RequestVenueOwnershipScreen({super.key});

  @override
  State<RequestVenueOwnershipScreen> createState() => _RequestVenueOwnershipScreenState();
}

class _RequestVenueOwnershipScreenState extends State<RequestVenueOwnershipScreen> {
  final VenueService _venueService = VenueService.instance;
  final CityService _cityService = CityService.instance;
  final AuthService _authService = AuthService.instance;
  
  List<City> _cities = [];
  City? _selectedCity;
  Venue? _selectedVenue;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  Future<void> _loadCities() async {
    try {
      final cities = await _cityService.fetchCities();
      if (mounted) {
        setState(() {
          _cities = cities;
          if (cities.isNotEmpty) {
            _selectedCity = cities.first;
          }
        });
      }
    } catch (e) {
      debugPrint('Error al cargar ciudades: $e');
      if (mounted) {
        setState(() {
          _error = 'Error al cargar ciudades';
        });
      }
    }
  }

  Future<void> _handleVenueSelected(Venue? venue) async {
    setState(() {
      _selectedVenue = venue;
    });
  }

  Future<void> _claimSelectedVenue() async {
    if (_selectedVenue == null) return;

    // Verificar si el venue ya tiene dueño
    final hasOwner = await VenueOwnershipService.instance.venueHasOwner(_selectedVenue!.id);
    if (hasOwner) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Este venue ya tiene un dueño verificado'),
          backgroundColor: Colors.orange,
        ),
      );
      setState(() {
        _selectedVenue = null;
      });
      return;
    }

    // Navegar a la pantalla de reclamar venue
    if (!mounted) return;
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ClaimVenueScreen(venue: _selectedVenue!),
      ),
    );

    // Si se completó la solicitud, volver atrás
    if (result == true && mounted) {
      Navigator.of(context).pop(true);
    } else if (mounted) {
      // Si canceló, resetear la selección
      setState(() {
        _selectedVenue = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_authService.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Solicitar ser propietario'),
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
                'Debes iniciar sesión para solicitar ser propietario',
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
        title: const Text('Reclamar un lugar'),
      ),
      body: SingleChildScrollView(
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
                            '¿Qué es ser propietario de un lugar?',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.business,
                      'Si eres dueño de un negocio, puedes solicitar ser su propietario',
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.verified,
                      'Después de verificar tu identidad, podrás gestionar los eventos de tu local',
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.admin_panel_settings,
                      'Los eventos de tu local requerirán tu aprobación antes de publicarse',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Seleccionar ciudad
            if (_cities.isNotEmpty) ...[
              Text(
                'Selecciona la ciudad',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<City>(
                value: _selectedCity,
                decoration: const InputDecoration(
                  labelText: 'Ciudad',
                  border: OutlineInputBorder(),
                ),
                items: _cities.map((city) {
                  return DropdownMenuItem<City>(
                    value: city,
                    child: Text(city.name),
                  );
                }).toList(),
                onChanged: (city) {
                  setState(() {
                    _selectedCity = city;
                    _selectedVenue = null; // Reset venue al cambiar ciudad
                  });
                },
              ),
              const SizedBox(height: 24),
            ],

            // Buscar venue
            if (_selectedCity != null) ...[
              Text(
                'Busca el lugar',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              VenueSearchField(
                cityId: _selectedCity!.id,
                cityName: _selectedCity!.name,
                labelText: 'Nombre del lugar',
                onVenueSelected: _handleVenueSelected,
              ),
              const SizedBox(height: 16),
              Text(
                'Si el lugar no existe, puedes crearlo y luego solicitar ser su propietario. El lugar se creará con estado "Pendiente" y requerirá aprobación del administrador.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              
              // Mostrar venue seleccionado y botón para reclamar
              if (_selectedVenue != null) ...[
                const SizedBox(height: 24),
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
                              Icons.business,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _selectedVenue!.name,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_selectedVenue!.cityName != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            _selectedVenue!.cityName!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                        if (_selectedVenue!.address != null && _selectedVenue!.address!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            _selectedVenue!.address!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _claimSelectedVenue,
                            icon: const Icon(Icons.person_add),
                            label: const Text('Solicitar ser propietario'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],

            if (_error != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
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
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

