import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category.dart';

class CategoryService {
  Future<List<Category>> fetchAll() async {
    try {
      final rows = await Supabase.instance.client
          .from('categories')
          .select()
          .order('name', ascending: true);

      return (rows as List)
          .map((e) => Category.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener categorías: ${e.toString()}');
    }
  }

  Future<List<Category>> getCategories() async {
    return await fetchAll();
  }
}
