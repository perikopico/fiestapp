// lib/models/notification_rule.dart
class NotificationRule {
  final String id;
  final int provinceId; // e.g. 1 for Cádiz
  final List<int> cityIds; // e.g. [1, 2, 3] for Barbate, Tarifa, Conil
  final List<int> categoryIds; // e.g. [1, 2] for Gastronomía, Música
  final bool isActive;
  final DateTime createdAt;

  NotificationRule({
    required this.id,
    required this.provinceId,
    required this.cityIds,
    required this.categoryIds,
    this.isActive = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Crea una copia del rule con campos modificados
  NotificationRule copyWith({
    String? id,
    int? provinceId,
    List<int>? cityIds,
    List<int>? categoryIds,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return NotificationRule(
      id: id ?? this.id,
      provinceId: provinceId ?? this.provinceId,
      cityIds: cityIds ?? this.cityIds,
      categoryIds: categoryIds ?? this.categoryIds,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Valida que el rule tenga al menos una ciudad y una categoría
  bool get isValid => cityIds.isNotEmpty && categoryIds.isNotEmpty;

  /// Convierte a Map para almacenamiento
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'province_id': provinceId,
      'city_ids': cityIds,
      'category_ids': categoryIds,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Crea desde Map
  factory NotificationRule.fromMap(Map<String, dynamic> map) {
    return NotificationRule(
      id: map['id'] as String,
      provinceId: map['province_id'] as int,
      cityIds: (map['city_ids'] as List).cast<int>(),
      categoryIds: (map['category_ids'] as List).cast<int>(),
      isActive: map['is_active'] as bool? ?? true,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
    );
  }
}

