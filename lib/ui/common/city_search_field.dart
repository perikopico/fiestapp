import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fiestapp/services/city_service.dart';

class CitySearchField extends StatefulWidget {
  const CitySearchField({
    super.key,
    this.initialCity,
    required this.onCitySelected,
    this.labelText = 'Ciudad',
  });

  final City? initialCity;
  final ValueChanged<City> onCitySelected;
  final String labelText;

  @override
  State<CitySearchField> createState() => _CitySearchFieldState();
}

class _CitySearchFieldState extends State<CitySearchField> {
  final TextEditingController _controller = TextEditingController();
  final CityService _cityService = CityService.instance;

  String _query = '';
  Timer? _debouncer;
  bool _isSearching = false;
  List<City> _results = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialCity != null) {
      _controller.text = widget.initialCity!.name;
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
    });

    _debouncer?.cancel();
    if (value.trim().isEmpty) {
      setState(() {
        _results = [];
        _isSearching = false;
      });
      return;
    }

    _debouncer = Timer(const Duration(milliseconds: 400), () async {
      setState(() => _isSearching = true);
      try {
        final list = await _cityService.searchCities(value.trim());

        if (!mounted) return;
        setState(() {
          _results = list;
          _isSearching = false;
        });
      } catch (_) {
        if (!mounted) return;
        setState(() => _isSearching = false);
      }
    });
  }

  void _selectCity(City city) {
    _controller.text = city.name;
    setState(() {
      _results = [];
      _query = city.name;
    });
    widget.onCitySelected(city);
  }

  @override
  Widget build(BuildContext context) {
    final hasResults = _results.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: widget.labelText,
            prefixIcon: const Icon(Icons.location_city),
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
                              _results = [];
                            });
                          },
                        )
                      : null),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onChanged: _onChanged,
        ),
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
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            constraints: const BoxConstraints(maxHeight: 260),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final city = _results[index];
                return ListTile(
                  dense: true,
                  leading: const Icon(Icons.location_on, size: 20),
                  title: Text(city.name),
                  onTap: () => _selectCity(city),
                );
              },
            ),
          ),
      ],
    );
  }
}
