import 'dart:async';
import 'package:flutter/material.dart';
import '../../../models/event.dart';
import '../../../services/city_service.dart';
import '../../../services/event_service.dart';
import '../../event/event_detail_screen.dart';

class UnifiedSearchBar extends StatefulWidget {
  final int? selectedCityId;
  final ValueChanged<City> onCitySelected;
  final ValueChanged<String>? onSearchChanged;

  const UnifiedSearchBar({
    super.key,
    this.selectedCityId,
    required this.onCitySelected,
    this.onSearchChanged,
  });

  @override
  State<UnifiedSearchBar> createState() => _UnifiedSearchBarState();
}

class _UnifiedSearchBarState extends State<UnifiedSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final CityService _cityService = CityService.instance;
  final EventService _eventService = EventService.instance;

  String _searchQuery = '';
  Timer? _searchDebouncer;
  bool _isSearching = false;
  List<City> _cityResults = [];
  List<Event> _eventResults = [];

  @override
  void dispose() {
    _searchDebouncer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _cityResults.clear();
        _eventResults.clear();
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      // Buscar ciudades y eventos en paralelo
      final results = await Future.wait([
        _cityService.searchCities(query),
        _eventService.searchEvents(query: query, cityId: widget.selectedCityId),
      ]);

      if (!mounted) return;

      setState(() {
        _cityResults = results[0] as List<City>;
        _eventResults = results[1] as List<Event>;
        _isSearching = false;
      });

      // El UnifiedSearchBar gestiona sus resultados internos (ciudades/eventos).
      // No disparamos onSearchChanged aquí para evitar refrescar toda la pantalla
      // cada vez que el usuario teclea.
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSearching = false;
      });
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });

    _searchDebouncer?.cancel();
    if (value.trim().isNotEmpty) {
      _searchDebouncer = Timer(const Duration(milliseconds: 500), () {
        _performSearch(value);
      });
    } else {
      setState(() {
        _cityResults.clear();
        _eventResults.clear();
      });
    }
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _cityResults.clear();
      _eventResults.clear();
    });
    // Al limpiar la búsqueda, solo reseteamos los resultados locales.
    // El dashboard decide si quiere resetear filtros por su cuenta.
  }

  void _selectCity(City city) {
    widget.onCitySelected(city);
    _clearSearch();
  }

  void _selectEvent(Event event, BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => EventDetailScreen(event: event)));
    _clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    final hasResults = _cityResults.isNotEmpty || _eventResults.isNotEmpty;
    final hasQuery = _searchQuery.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _searchController,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Buscar ciudad o evento',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: hasQuery
                ? IconButton(
                    icon: _isSearching
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.clear),
                    onPressed: _clearSearch,
                  )
                : null,
          ),
          onChanged: _onSearchChanged,
          onSubmitted: (value) {
            // Si hay una sola ciudad, seleccionarla
            if (_cityResults.length == 1 && _eventResults.isEmpty) {
              _selectCity(_cityResults.first);
            }
            // Si hay un solo evento, navegar a él
            else if (_eventResults.length == 1 && _cityResults.isEmpty) {
              _selectEvent(_eventResults.first, context);
            }
          },
        ),
        // Mostrar resultados de búsqueda
        if (hasResults)
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
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            constraints: const BoxConstraints(maxHeight: 300),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                // Resultados de ciudades
                if (_cityResults.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      'Ciudades',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ..._cityResults.map((city) {
                    return ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.location_city,
                        size: 20,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      title: Text(city.name),
                      onTap: () => _selectCity(city),
                    );
                  }),
                  if (_eventResults.isNotEmpty) const Divider(height: 1),
                ],
                // Resultados de eventos
                if (_eventResults.isNotEmpty) ...[
                  if (_cityResults.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        'Eventos',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        'Eventos',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ..._eventResults.map((event) {
                    return ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.event,
                        size: 20,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      title: Text(event.title),
                      subtitle: event.cityName != null
                          ? Text(
                              event.cityName!,
                              style: Theme.of(context).textTheme.bodySmall,
                            )
                          : null,
                      onTap: () => _selectEvent(event, context),
                    );
                  }),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
