import 'package:flutter/material.dart';
import '../../../utils/dashboard_utils.dart';

class CityRadioToggle extends StatelessWidget {
  final LocationMode selectedMode;
  final ValueChanged<LocationMode> onModeChanged;
  final String? selectedCityName;
  final double radiusKm;
  final bool hasLocationPermission;

  const CityRadioToggle({
    super.key,
    required this.selectedMode,
    required this.onModeChanged,
    this.selectedCityName,
    required this.radiusKm,
    this.hasLocationPermission = true,
  });

  @override
  Widget build(BuildContext context) {
    final isCity = selectedMode == LocationMode.city;
    final isRadius = selectedMode == LocationMode.radius;

    return Row(
        children: [
          // Botón Radio
          Expanded(
            child: InkWell(
              onTap: hasLocationPermission
                  ? () => onModeChanged(LocationMode.radius)
                  : null,
              borderRadius: BorderRadius.circular(8),
              child: Opacity(
                opacity: hasLocationPermission ? 1.0 : 0.5,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isRadius
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isRadius
                        ? Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          )
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.radar,
                        size: 16,
                        color: isRadius
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Radio',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isRadius
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: isRadius
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Divisor
          Container(
            width: 1,
            height: 24,
            margin: const EdgeInsets.symmetric(vertical: 4),
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
          // Botón Ciudad
          Expanded(
            child: InkWell(
              onTap: () => onModeChanged(LocationMode.city),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: isCity
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: isCity
                      ? Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        )
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_city,
                      size: 16,
                      color: isCity
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Ciudad',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isCity
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: isCity
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
    );
  }
}
