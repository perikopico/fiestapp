import 'package:intl/intl.dart';

class Event {
  final String id;
  final String title;
  final String? town;
  final String? place;
  final String? category;
  final String? imageUrl;
  final String? mapsUrl;
  final bool isFeatured;
  final bool isFree;
  final DateTime? startsAt;
  final int? cityId;
  final int? categoryId;

  Event({
    required this.id,
    required this.title,
    this.town,
    this.place,
    this.category,
    this.imageUrl,
    this.mapsUrl,
    required this.isFeatured,
    required this.isFree,
    this.startsAt,
    this.cityId,
    this.categoryId,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      town: map['town'] as String?,
      place: map['place'] as String?,
      category: map['category'] as String?,
      imageUrl: map['image_url'] as String?,
      mapsUrl: map['maps_url'] as String?,
      isFeatured: map['is_featured'] as bool? ?? false,
      isFree: map['is_free'] as bool? ?? false,
      startsAt: _parseDateTime(map['starts_at']),
      cityId: map['city_id'] as int?,
      categoryId: map['category_id'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'town': town,
      'place': place,
      'category': category,
      'image_url': imageUrl,
      'maps_url': mapsUrl,
      'is_featured': isFeatured,
      'is_free': isFree,
      'starts_at': startsAt?.toIso8601String(),
      'city_id': cityId,
      'category_id': categoryId,
    };
  }

  DateTime? get startsAtLocal => startsAt?.toLocal();

  String get formattedDate {
    if (startsAtLocal == null) return '';
    return DateFormat('dd/MM HH:mm').format(startsAtLocal!);
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    
    if (value is DateTime) {
      return value;
    }
    
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return null;
      }
    }
    
    if (value is int) {
      try {
        return DateTime.fromMillisecondsSinceEpoch(value * 1000);
      } catch (e) {
        return null;
      }
    }
    
    return null;
  }
}

