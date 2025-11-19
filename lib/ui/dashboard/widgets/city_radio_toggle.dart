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

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          // Botón Radio
          Expanded(
            child: InkWell(
              onTap: hasLocationPermission
                  ? () => onModeChanged(LocationMode.radius)
                  : null,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Opacity(
                opacity: hasLocationPermission ? 1.0 : 0.5,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: isRadius
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
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
                        size: 18,
                        color: isRadius
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Radio',
                        style: TextStyle(
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
            height: 40,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
          // Botón Ciudad
          Expanded(
            child: InkWell(
              onTap: () => onModeChanged(LocationMode.city),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: isCity
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
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
                      size: 18,
                      color: isCity
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Ciudad',
                      style: TextStyle(
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
      ),
    );
  }
}
