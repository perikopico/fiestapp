// lib/models/venue.dart
class Venue {
  final String id;
  final String name;
  final int cityId;
  final String? cityName; // Nombre de la ciudad (opcional, para mostrar)
  final String? address;
  final double? lat;
  final double? lng;
  final String status; // 'pending', 'approved', 'rejected'
  final String? createdBy;
  final String? rejectedReason;
  final DateTime createdAt;
  final DateTime updatedAt;

  Venue({
    required this.id,
    required this.name,
    required this.cityId,
    this.cityName,
    this.address,
    this.lat,
    this.lng,
    required this.status,
    this.createdBy,
    this.rejectedReason,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Venue.fromMap(Map<String, dynamic> map) {
    return Venue(
      id: map['id'] as String,
      name: map['name'] as String,
      cityId: (map['city_id'] as num).toInt(),
      cityName: map['city_name'] as String?,
      address: map['address'] as String?,
      lat: map['lat'] as double?,
      lng: map['lng'] as double?,
      status: map['status'] as String? ?? 'pending',
      createdBy: map['created_by'] as String?,
      rejectedReason: map['rejected_reason'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'city_id': cityId,
      'address': address,
      'lat': lat,
      'lng': lng,
      'status': status,
      'created_by': createdBy,
      'rejected_reason': rejectedReason,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  bool get isApproved => status == 'approved';
  bool get isPending => status == 'pending';
  bool get isRejected => status == 'rejected';
}
