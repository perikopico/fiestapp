import 'package:intl/intl.dart';

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
    );
  }
}

extension EventFormatting on Event {
  String get formattedDate => DateFormat('dd/MM HH:mm').format(startsAt);
  String get formattedDay  => DateFormat('dd/MM').format(startsAt);
  String get formattedTime => DateFormat('HH:mm').format(startsAt);
}
