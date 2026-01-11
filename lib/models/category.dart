class Category {
  final int? id;
  final String name;
  final String? slug;
  final String? icon;
  final String? description;

  Category({this.id, required this.name, this.slug, this.icon, this.description});

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as int?,
      name: map['name'] as String? ?? '',
      slug: map['slug'] as String?,
      icon: map['icon'] as String?,
      description: map['description'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'slug': slug, 'icon': icon, 'description': description};
  }
}
