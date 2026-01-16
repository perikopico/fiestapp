import 'package:intl/intl.dart';
import '../services/favorites_service.dart';

class Event {
  final String id;
  final String title;
  final String? cityName;
  final String? categoryName;
  final String? categoryIcon; // <-- importante
  final String? categoryColor;
  final DateTime startsAt;
  final String? place;
  final String? imageUrl;
  final int? categoryId;
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
  });

  factory Event.fromMap(Map<String, dynamic> m) {
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
    );
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
