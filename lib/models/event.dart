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
  final bool? isFree;
  final String? mapsUrl;
  final String? description;
  final String? imageAlignment;
  
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
    this.isFree,
    this.mapsUrl,
    this.description,
    this.imageAlignment,
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
      isFree: m['is_free'] as bool?,
      mapsUrl: m['maps_url'] as String?,
      description: m['description'] as String?,
      imageAlignment: m['image_alignment'] as String? ?? 'center',
    );
  }
}

extension EventFormatting on Event {
  String get formattedDate => DateFormat('dd/MM HH:mm').format(startsAt);
  String get formattedDay => DateFormat('dd/MM').format(startsAt);
  String get formattedTime => DateFormat('HH:mm').format(startsAt);
}
