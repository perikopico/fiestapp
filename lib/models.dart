// lib/models.dart
class City {
  final String id, name;
  const City(this.id, this.name);
}

class EventItem {
  final String id, title, cityId, categoryId, categoryName, place;
  final DateTime start, end;
  final String? price; // Precio del evento (ej: "Gratis", "18€", "Desde 10€")
  final String? imageUrl;

  const EventItem({
    required this.id,
    required this.title,
    required this.cityId,
    required this.categoryId,
    required this.categoryName,
    required this.place,
    required this.start,
    required this.end,
    this.price,
    this.imageUrl,
  });
}

class Event {
  final String id;
  final String title;
  final Location location;

  Event({required this.id, required this.title, required this.location});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      title: json['title'] as String,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
    );
  }
}

class Location {
  final String city;
  final String? venue;

  Location({required this.city, this.venue});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      city: json['city'] as String,
      venue: json['venue'] as String?,
    );
  }
}

// Ciudades iniciales (alpha)
const cities = <City>[
  City('barbate', 'Barbate'),
  City('zahara', 'Zahara'),
  City('vejer', 'Vejer'),
];

// Categorías iniciales (DEPRECADO - ahora se obtienen de Supabase)
// Mantener solo para compatibilidad con código legacy si existe
// Las categorías finales se gestionan desde Supabase:
// 1. Música (musica)
// 2. Gastronomía (gastronomia)
// 3. Deportes (deportes)
// 4. Arte y Cultura (arte-y-cultura)
// 5. Aire Libre (aire-libre)
// 6. Tradiciones (tradiciones)
// 7. Mercadillos (mercadillos)
const kCategories = <Map<String, String>>[
  {'id': 'all', 'name': 'Todo'},
  // Categorías finales (solo para referencia, la BD es la fuente de verdad)
  {'id': 'musica', 'name': 'Música'},
  {'id': 'gastronomia', 'name': 'Gastronomía'},
  {'id': 'deportes', 'name': 'Deportes'},
  {'id': 'arte-y-cultura', 'name': 'Arte y Cultura'},
  {'id': 'aire-libre', 'name': 'Aire Libre'},
  {'id': 'tradiciones', 'name': 'Tradiciones'},
  {'id': 'mercadillos', 'name': 'Mercadillos'},
];
