// lib/ui/admin/pending_venues_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/venue.dart';
import '../../services/venue_service.dart';

class PendingVenuesScreen extends StatefulWidget {
  const PendingVenuesScreen({super.key});

  @override
  State<PendingVenuesScreen> createState() => _PendingVenuesScreenState();
}

class _PendingVenuesScreenState extends State<PendingVenuesScreen> {
  final VenueService _venueService = VenueService.instance;
  bool _isLoading = true;
  String? _error;
  List<Venue> _pendingVenues = [];
  final DateFormat _dateFormat = DateFormat('d MMM yyyy, HH:mm');

  @override
  void initState() {
    super.initState();
    _loadPendingVenues();
  }

  Future<void> _loadPendingVenues() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final venues = await _venueService.getPendingVenues();
      if (mounted) {
        setState(() {
          _pendingVenues = venues;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _approveVenue(Venue venue) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Aprobar lugar'),
        content: Text('¿Aprobar el lugar "${venue.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Aprobar'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _venueService.approveVenue(venue.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lugar "${venue.name}" aprobado'),
            backgroundColor: Colors.green,
          ),
        );
        _loadPendingVenues(); // Recargar lista
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al aprobar lugar: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _rejectVenue(Venue venue) async {
    final reasonController = TextEditingController();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rechazar lugar'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('¿Rechazar el lugar "${venue.name}"?'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Razón del rechazo (opcional)',
                hintText: 'Ej: Lugar duplicado, información incorrecta...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Rechazar'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final reason = reasonController.text.trim().isEmpty
        ? null
        : reasonController.text.trim();

    try {
      await _venueService.rejectVenue(venue.id, reason: reason);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lugar "${venue.name}" rechazado'),
            backgroundColor: Colors.orange,
          ),
        );
        _loadPendingVenues(); // Recargar lista
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al rechazar lugar: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lugares Pendientes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPendingVenues,
            tooltip: 'Recargar',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
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
              'Error al cargar lugares',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPendingVenues,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_pendingVenues.isEmpty) {
      return Center(
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
              'No hay lugares pendientes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Todos los lugares están aprobados o rechazados',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPendingVenues,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _pendingVenues.length,
        itemBuilder: (context, index) {
          final venue = _pendingVenues[index];
          return _buildVenueCard(venue);
        },
      ),
    );
  }

  Widget _buildVenueCard(Venue venue) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nombre del lugar
            Text(
              venue.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            // Lugares similares (si existen)
            _buildSimilarVenuesSection(venue),
            const SizedBox(height: 8),
            // Información del lugar
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  venue.cityName ?? 'Ciudad ID: ${venue.cityId}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            if (venue.address != null && venue.address!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                venue.address!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
            if (venue.lat != null && venue.lng != null) ...[
              const SizedBox(height: 4),
              Text(
                '📍 ${venue.lat}, ${venue.lng}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
            const SizedBox(height: 8),
            // Fecha de creación
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  'Creado: ${_dateFormat.format(venue.createdAt)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _rejectVenue(venue),
                  icon: const Icon(Icons.cancel),
                  label: const Text('Rechazar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _approveVenue(venue),
                  icon: const Icon(Icons.check),
                  label: const Text('Aprobar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimilarVenuesSection(Venue venue) {
    return FutureBuilder<List<Venue>>(
      future: _venueService.findSimilarVenues(
        name: venue.name,
        cityId: venue.cityId,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 40,
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return const SizedBox.shrink();
        }

        final similarVenues = snapshot.data ?? [];
        
        // Filtrar el lugar actual de los similares
        final otherSimilarVenues = similarVenues
            .where((v) => v.id != venue.id)
            .toList();

        if (otherSimilarVenues.isEmpty) {
          return Card(
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'No se encontraron lugares similares',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Card(
          color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 18,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Lugares similares encontrados (${otherSimilarVenues.length})',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.error,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Se encontraron lugares similares en la misma ciudad. Revisa antes de aprobar para evitar duplicados:',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 8),
                    ...otherSimilarVenues.take(3).map((similarVenue) {
                      final statusColor = similarVenue.isApproved
                          ? Colors.green
                          : similarVenue.isPending
                              ? Colors.orange
                              : Colors.red;
                      final statusText = similarVenue.isApproved
                          ? 'Aprobado'
                          : similarVenue.isPending
                              ? 'Pendiente'
                              : 'Rechazado';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    similarVenue.name,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  if (similarVenue.address != null &&
                                      similarVenue.address!.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      similarVenue.address!,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                statusText,
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: statusColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    if (otherSimilarVenues.length > 3)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '... y ${otherSimilarVenues.length - 3} más',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
