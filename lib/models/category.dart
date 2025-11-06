class Category {
  final int? id;
  final String name;
  final String? icon;
  final String? description;

  Category({
    this.id,
    required this.name,
    this.icon,
    this.description,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as int?,
      name: map['name'] as String? ?? '',
      icon: map['icon'] as String?,
      description: map['description'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'description': description,
    };
  }
}

