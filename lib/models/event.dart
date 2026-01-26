import 'package:intl/intl.dart';
import 'dart:convert';
import '../services/favorites_service.dart';

class Event {
  final String id;
  final String title;
  final String? cityName;
  final String? categoryName; // Categoría principal (para compatibilidad)
  final String? categoryIcon; // Icono de categoría principal (para compatibilidad)
  final String? categoryColor; // Color de categoría principal (para compatibilidad)
  final DateTime startsAt;
  final String? place;
  final String? imageUrl;
  final int? categoryId; // ID de categoría principal (para compatibilidad)
  // Soporte para múltiples categorías (máximo 2)
  final List<int>? categoryIds; // IDs de todas las categorías (1-2)
  final List<String>? categoryNames; // Nombres de todas las categorías (1-2)
  final List<String>? categoryIcons; // Iconos de todas las categorías (1-2)
  final List<String>? categoryColors; // Colores de todas las categorías (1-2)
  final int? cityId;
  final String? price; // Precio del evento (ej: "Gratis", "18€", "Desde 10€", etc.)
  final String? mapsUrl;
  final String? description;
  final String? imageAlignment;
  final String? infoUrl; // URL de interés relacionada con el evento
  final String? status; // 'pending', 'published', 'rejected'
  final String? venueId; // ID del venue asociado
  final bool? ownerApproved; // NULL = no requiere aprobación, true = aprobado, false = rechazado
  final DateTime? ownerApprovedAt;
  final String? ownerRejectedReason;
  final double? distanceKm; // Distancia en km (solo viene de events_within_radius)
  
  /// Campo calculado que indica si el evento es favorito (no viene de Supabase)
  bool get isFavorite => FavoritesService.instance.isFavorite(id);
  
  /// Campo calculado que indica si el evento está en el pasado
  /// Un evento se considera "FINALIZADO" solo a partir de las 5:00 del día siguiente a su fecha
  bool get isPast {
    // Fecha del evento (ignorando horas)
    final eventDate = DateTime(startsAt.year, startsAt.month, startsAt.day);
    
    // El evento deja de ser "activo" a las 05:00 del día siguiente
    final cutoff = eventDate.add(const Duration(days: 1)).add(const Duration(hours: 5));
    
    final now = DateTime.now();
    
    return now.isAfter(cutoff);
  }

  Event({
    required this.id,
    required this.title,
    required this.startsAt,
    this.cityName,
    this.categoryName,
    this.categoryIcon, // <-- importante
    this.categoryColor,
    this.place,
    this.imageUrl,
    this.categoryId,
    this.cityId,
    this.price,
    this.mapsUrl,
    this.description,
    this.imageAlignment,
    this.infoUrl,
    this.status,
    this.venueId,
    this.ownerApproved,
    this.ownerApprovedAt,
    this.ownerRejectedReason,
    this.distanceKm,
    this.categoryIds,
    this.categoryNames,
    this.categoryIcons,
    this.categoryColors,
  });

  factory Event.fromMap(Map<String, dynamic> m) {
    // Procesar categorías múltiples si vienen como array
    // Helper function para parsear arrays de diferentes formatos
    List<T>? _parseArray<T>(dynamic value, T? Function(dynamic) converter) {
      if (value == null) return null;
      
      if (value is List) {
        return value.map(converter).whereType<T>().toList();
      }
      
      if (value is String) {
        try {
          // Intentar parsear como JSON array primero (formato ["1","2"])
          if (value.startsWith('[') && value.endsWith(']')) {
            final decoded = jsonDecode(value) as List;
            return decoded.map(converter).whereType<T>().toList();
          }
          // Si no es JSON, intentar formato PostgreSQL array {1,2}
          else if (value.startsWith('{') && value.endsWith('}')) {
            final cleaned = value.substring(1, value.length - 1);
            if (cleaned.isNotEmpty) {
              return cleaned.split(',').map((e) => converter(e.trim().replaceAll('"', ''))).whereType<T>().toList();
            }
          }
        } catch (e) {
          // Error silenciado - usar categoría principal si está disponible
          return null;
        }
      }
      
      return null;
    }
    
    // Parsear arrays de categorías múltiples de forma optimizada
    final categoryIds = _parseArray<int>(
      m['category_ids'],
      (e) {
        if (e is num) return e.toInt();
        if (e is int) return e;
        return int.tryParse(e.toString());
      },
    );
    
    final categoryNames = _parseArray<String>(
      m['category_names'],
      (e) => e.toString(),
    );
    
    final categoryIcons = _parseArray<String>(
      m['category_icons'],
      (e) => e.toString(),
    );
    
    final categoryColors = _parseArray<String>(
      m['category_colors'],
      (e) => e.toString(),
    );
    
    return Event(
      id: m['id'] as String,
      title: m['title'] as String,
      startsAt: DateTime.parse(m['starts_at'] as String),
      cityName: m['city_name'] as String?,
      categoryName: m['category_name'] as String?,
      categoryIcon: m['category_icon'] as String?, // <-- importante
      categoryColor: m['category_color'] as String?,
      place: m['place'] as String?,
      imageUrl: m['image_url'] as String?,
      categoryId: (m['category_id'] as num?)?.toInt(),
      cityId: (m['city_id'] as num?)?.toInt(),
      price: m['price'] as String?,
      mapsUrl: m['maps_url'] as String?,
      description: m['description'] as String?,
      imageAlignment: m['image_alignment'] as String? ?? 'center',
      infoUrl: m['info_url'] as String?,
      status: m['status'] as String?,
      venueId: m['venue_id'] as String?,
      ownerApproved: m['owner_approved'] as bool?,
      ownerApprovedAt: m['owner_approved_at'] != null 
          ? DateTime.parse(m['owner_approved_at'] as String) 
          : null,
      ownerRejectedReason: m['owner_rejected_reason'] as String?,
      distanceKm: (m['distance_km'] as num?)?.toDouble(),
      categoryIds: categoryIds,
      categoryNames: categoryNames,
      categoryIcons: categoryIcons,
      categoryColors: categoryColors,
    );
  }
  
  /// Obtiene todas las categorías del evento (principal + secundarias)
  /// Retorna una lista con 1-2 categorías
  List<Map<String, dynamic>> get allCategories {
    final List<Map<String, dynamic>> categories = [];
    
    // Si tenemos arrays de categorías múltiples, usarlos (ya incluyen todas las categorías)
    if (categoryIds != null && categoryNames != null && categoryIds!.isNotEmpty) {
      for (int i = 0; i < categoryIds!.length; i++) {
        final catId = categoryIds![i];
        final catName = i < categoryNames!.length ? categoryNames![i] : null;
        final catIcon = categoryIcons != null && i < categoryIcons!.length ? categoryIcons![i] : null;
        final catColor = categoryColors != null && i < categoryColors!.length ? categoryColors![i] : null;
        
        if (catId != null && catName != null) {
          categories.add({
            'id': catId,
            'name': catName,
            'icon': catIcon,
            'color': catColor,
          });
        }
      }
    }
    
    // Si no hay arrays pero sí categoría principal, usar solo esa
    if (categories.isEmpty && categoryId != null && categoryName != null) {
      categories.add({
        'id': categoryId,
        'name': categoryName,
        'icon': categoryIcon,
        'color': categoryColor,
      });
    }
    
    return categories;
  }
  
  /// Verifica si el evento tiene una categoría específica (por ID)
  bool hasCategory(int categoryIdToCheck) {
    if (categoryId == categoryIdToCheck) return true;
    if (categoryIds != null && categoryIds!.contains(categoryIdToCheck)) return true;
    return false;
  }
  
  /// Indica si el evento requiere aprobación del dueño del venue
  bool get requiresOwnerApproval => venueId != null && ownerApproved == null;
  
  /// Indica si el evento fue aprobado por el dueño
  bool get isOwnerApproved => ownerApproved == true;
  
  /// Indica si el evento fue rechazado por el dueño
  bool get isOwnerRejected => ownerApproved == false;
}

extension EventFormatting on Event {
  String get formattedDate => DateFormat('dd/MM HH:mm').format(startsAt);
  String get formattedDay => DateFormat('dd/MM').format(startsAt);
  String get formattedTime => DateFormat('HH:mm').format(startsAt);
  
  /// Formato legible de fecha y hora combinadas para mostrar en chips
  /// Ejemplo: "15 marzo, 20:30"
  String get formattedDateTime {
    try {
      // Intentar con locale español - mes completo (MMMM)
      return DateFormat('d MMMM, HH:mm', 'es').format(startsAt);
    } catch (e) {
      // Fallback a formato sin locale si hay problemas
      return DateFormat('d MMMM, HH:mm').format(startsAt);
    }
  }
  
  /// Solo la fecha en formato legible
  /// Ejemplo: "15 marzo"
  String get formattedDateOnly {
    try {
      return DateFormat('d MMMM', 'es').format(startsAt);
    } catch (e) {
      return DateFormat('d MMMM').format(startsAt);
    }
  }
  
  /// Solo la hora
  /// Ejemplo: "20:30"
  String get formattedTimeOnly {
    return DateFormat('HH:mm').format(startsAt);
  }
}
