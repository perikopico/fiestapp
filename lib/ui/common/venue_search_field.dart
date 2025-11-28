// lib/ui/common/venue_search_field.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/venue.dart';
import '../../services/venue_service.dart';

class VenueSearchField extends StatefulWidget {
  const VenueSearchField({
    super.key,
    this.initialVenue,
    required this.onVenueSelected,
    required this.cityId,
    this.labelText = 'Lugar',
    this.errorText,
  });

  final Venue? initialVenue;
  final ValueChanged<Venue?> onVenueSelected;
  final int? cityId;
  final String labelText;
  final String? errorText;

  @override
  State<VenueSearchField> createState() => _VenueSearchFieldState();
}

class _VenueSearchFieldState extends State<VenueSearchField> {
  final TextEditingController _controller = TextEditingController();
  final VenueService _venueService = VenueService.instance;

  String _query = '';
  Timer? _debouncer;
  bool _isSearching = false;
  List<Venue> _suggestions = [];
  Venue? _selectedVenue;
  bool _isNewVenue = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialVenue != null) {
      _selectedVenue = widget.initialVenue;
      _controller.text = widget.initialVenue!.name;
    }
  }

  @override
  void dispose() {
    _debouncer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {
      _query = value;
      _isNewVenue = false;
      _selectedVenue = null;
    });

    _debouncer?.cancel();
    
    if (value.trim().isEmpty) {
      setState(() {
        _suggestions = [];
        _isSearching = false;
      });
      widget.onVenueSelected(null);
      return;
    }

    // Si no hay cityId, no podemos buscar
    if (widget.cityId == null) {
      setState(() {
        _suggestions = [];
        _isSearching = false;
      });
      return;
    }

    _debouncer = Timer(const Duration(milliseconds: 400), () async {
      setState(() => _isSearching = true);
      try {
        final venues = await _venueService.searchVenues(
          query: value.trim(),
          cityId: widget.cityId,
          limit: 5,
        );

        if (!mounted) return;
        setState(() {
          _suggestions = venues;
          _isSearching = false;
          // Si no hay sugerencias y hay texto, es un lugar nuevo
          _isNewVenue = venues.isEmpty && value.trim().isNotEmpty;
        });
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _suggestions = [];
          _isSearching = false;
          _isNewVenue = false;
        });
      }
    });
  }

  void _selectVenue(Venue venue) {
    _controller.text = venue.name;
    setState(() {
      _selectedVenue = venue;
      _suggestions = [];
      _query = venue.name;
      _isNewVenue = false;
    });
    widget.onVenueSelected(venue);
  }

  Future<void> _createNewVenue() async {
    if (widget.cityId == null) return;
    
    final venueName = _controller.text.trim();
    if (venueName.isEmpty) return;

    try {
      final newVenue = await _venueService.createVenue(
        name: venueName,
        cityId: widget.cityId!,
      );

      if (!mounted) return;

      setState(() {
        _selectedVenue = newVenue;
        _suggestions = [];
        _isNewVenue = false;
      });
      
      widget.onVenueSelected(newVenue);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Lugar creado. Está pendiente de aprobación.'),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al crear lugar: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasSuggestions = _suggestions.isNotEmpty;
    final showNewVenueOption = _isNewVenue && _query.trim().isNotEmpty && widget.cityId != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: 'Escribe el nombre del lugar',
            prefixIcon: const Icon(Icons.place),
            suffixIcon: _isSearching
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : (_query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _controller.clear();
                            _query = '';
                            _suggestions = [];
                            _selectedVenue = null;
                            _isNewVenue = false;
                          });
                          widget.onVenueSelected(null);
                        },
                      )
                    : null),
            errorText: widget.errorText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onChanged: _onChanged,
        ),
        if (hasSuggestions || showNewVenueOption)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            constraints: const BoxConstraints(maxHeight: 300),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _suggestions.length + (showNewVenueOption ? 1 : 0),
              itemBuilder: (context, index) {
                // Opción de crear nuevo lugar al final
                if (showNewVenueOption && index == _suggestions.length) {
                  return ListTile(
                    dense: true,
                    leading: const Icon(Icons.add_circle_outline, size: 20),
                    title: Text('Crear nuevo lugar: "${_query.trim()}"'),
                    subtitle: const Text(
                      'Este lugar quedará pendiente de aprobación',
                      style: TextStyle(fontSize: 11),
                    ),
                    onTap: _createNewVenue,
                  );
                }

                final venue = _suggestions[index];
                return ListTile(
                  dense: true,
                  leading: const Icon(Icons.place, size: 20),
                  title: Text(venue.name),
                  subtitle: venue.address != null && venue.address!.isNotEmpty
                      ? Text(
                          venue.address!,
                          style: const TextStyle(fontSize: 11),
                        )
                      : null,
                  onTap: () => _selectVenue(venue),
                );
              },
            ),
          ),
        if (_selectedVenue != null && _selectedVenue!.isPending) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Este lugar está pendiente de aprobación',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
