// lib/models.dart
class City {
  final String id, name;
  const City(this.id, this.name);
}

class EventItem {
  final String id, title, cityId, categoryId, categoryName, place;
  final DateTime start, end;
  final bool isFree;
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
    required this.isFree,
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

// Categorías iniciales (id = lo que usaremos en BD)
const kCategories = <Map<String, String>>[
  {'id': 'all', 'name': 'Todo'},
  {'id': 'tradicion', 'name': 'Tradición'},
  {'id': 'motor', 'name': 'Motor'},
  {'id': 'mercados', 'name': 'Mercados'},
];
