import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

import '../models/event.dart';

class EventService {
  EventService._();

  static final instance = EventService._();

  final supa = Supabase.instance.client;

  Future<List<Event>> fetchUpcoming({int limit = 50}) async {
    final r = await supa
        .from('events_view')
        .select(
          'id, title, city_id, city_name, category_id, category_name, starts_at, image_url, maps_url, place, is_featured, is_free, category_icon, category_color',
        )
        .order('starts_at', ascending: true)
        .limit(limit);
    final events = (r as List)
        .map((e) => Event.fromMap(e as Map<String, dynamic>))
        .toList();
    // Obtener description desde la tabla base para cada evento
    await _enrichEventsWithDescription(events);
    return events;
  }

  Future<List<Event>> fetchFeatured({int limit = 10}) async {
    final r = await supa
        .from('events_view')
        .select(
          'id, title, city_id, city_name, category_id, category_name, starts_at, image_url, maps_url, place, is_featured, is_free, category_icon, category_color',
        )
        .eq('is_featured', true)
        .order('starts_at', ascending: true)
        .limit(limit);
    final events = (r as List)
        .map((e) => Event.fromMap(e as Map<String, dynamic>))
        .toList();
    // Obtener description desde la tabla base para cada evento
    await _enrichEventsWithDescription(events);
    return events;
  }

  Future<List<Event>> fetchEvents({
    List<int>? cityIds,
    int? categoryId,
    DateTime? from,
    DateTime? to,
    double? radiusKm,
    dynamic center, // si tienes LatLng usa tu tipo; aquí evitamos lios tipados
    String? searchTerm, // término libre para título/descr
    int limit = 50,
  }) async {
    print(
      'fetchEvents(): '
      'cityIds=$cityIds, '
      'categoryId=$categoryId, '
      'from=$from, '
      'to=$to, '
      'radiusKm=$radiusKm, '
      'center=$center, '
      'searchTerm=$searchTerm',
    );
    // Usamos la vista/materializada "events_view" (ajústalo si usas otra)
    dynamic qb = supa
        .from('events_view')
        .select(
          'id,title,city_id,city_name,category_id,category_name,starts_at,image_url,maps_url,place,is_featured,is_free,category_icon,category_color',
        );

    // Filtros básicos
    // Nota: si hay searchTerm, NO limitamos por ciudad para permitir buscar eventos en cualquier ciudad
    if (cityIds != null &&
        cityIds.isNotEmpty &&
        (searchTerm == null || searchTerm.trim().isEmpty)) {
      // Para múltiples cityIds, usamos el operador 'in' de PostgREST
      if (cityIds.length == 1) {
        qb = qb.eq('city_id', cityIds.first);
      } else {
        // Construimos condición OR para múltiples valores: (city_id.eq.1,city_id.eq.2)
        final orCondition = cityIds.map((id) => 'city_id.eq.$id').join(',');
        qb = qb.or(orCondition);
      }
    }
    if (categoryId != null) qb = qb.eq('category_id', categoryId);
    if (from != null) qb = qb.gte('starts_at', from.toIso8601String());
    if (to != null) qb = qb.lt('starts_at', to.toIso8601String());

    // Búsqueda libre por evento (título/descr)
    if (searchTerm != null && searchTerm.trim().isNotEmpty) {
      final t = searchTerm.trim();
      // Para búsqueda en título o descripción, usamos ilike en ambos campos
      // PostgREST permite múltiples filtros, pero si ya hay un 'or', necesitamos combinarlos
      // Por simplicidad, buscamos solo en title por ahora (se puede mejorar)
      qb = qb.ilike('title', '%$t%');
    }

    // Radio (si aplica). Si usas RPC, llama a tu función y obvia cityIds.
    if (radiusKm != null && center != null && radiusKm > 0) {
      // Cuando se usa radio, usamos la función RPC que filtra por distancia
      // y luego aplicamos los otros filtros en el cliente
      final lat = center['lat'] as double;
      final lng = center['lng'] as double;

      final rpcRes = await supa.rpc(
        'events_within_radius',
        params: {'p_lat': lat, 'p_lng': lng, 'p_radius_km': radiusKm},
      );

      if (rpcRes is! List) return [];

      // Convertir resultados de la RPC a eventos
      List<Event> events = (rpcRes as List)
          .cast<Map<String, dynamic>>()
          .map((m) => Event.fromMap(m))
          .toList();

      print(
        'fetchEvents() [RPC]: '
        'radiusKm=$radiusKm, '
        'searchTerm=$searchTerm -> ${events.length} eventos',
      );

      // Aplicar filtros adicionales en el cliente
      if (categoryId != null) {
        events = events.where((e) => e.categoryId == categoryId).toList();
      }
      if (from != null) {
        events = events
            .where(
              (e) =>
                  e.startsAt.isAfter(from.subtract(const Duration(seconds: 1))),
            )
            .toList();
      }
      if (to != null) {
        events = events.where((e) => e.startsAt.isBefore(to)).toList();
      }
      if (searchTerm != null && searchTerm.trim().isNotEmpty) {
        final t = searchTerm.trim().toLowerCase();
        events = events
            .where((e) => e.title.toLowerCase().contains(t))
            .toList();
      }

      // Ordenar y limitar
      events.sort((a, b) => a.startsAt.compareTo(b.startsAt));
      final limitedEvents = events.take(limit).toList();
      // Obtener description desde la tabla base para cada evento
      await _enrichEventsWithDescription(limitedEvents);
      return limitedEvents;
    }

    final res = await qb.order('starts_at', ascending: true).limit(limit);

    if (res is List) {
      print(
        'fetchEvents() [QUERY]: '
        'searchTerm=$searchTerm -> ${res.length} eventos',
      );
      final events = res
          .map((m) => Event.fromMap(m as Map<String, dynamic>))
          .toList();
      // Obtener description desde la tabla base para cada evento
      await _enrichEventsWithDescription(events);
      return events;
    }
    return [];
  }

  Future<List<Event>> searchEvents({
    required String query,
    int? cityId,
    int? provinceId,
    double? lat,
    double? lng,
    double? radiusKm,
  }) async {
    final q = query.trim();

    // Si no hay query y tampoco filtro por ciudad, devolvemos vacío (UI decide)
    if (q.isEmpty && cityId == null) return [];

    dynamic qb = supa
        .from('events')
        .select(
          'id, title, place, starts_at, image_url, city_id, category_id, is_free, is_featured, description',
        );

    // Autocompletado NO debe limitar por ciudad
    // pero si quieres que busque por provincia podría hacerse aquí
    // Por ahora: búsqueda global

    if (q.isNotEmpty) {
      qb = qb.ilike('title', '%$q%');
    }

    qb = qb.order('starts_at');

    final res = await qb;
    final list = (res as List).cast<Map<String, dynamic>>();
    return list.map((m) => Event.fromMap(m)).toList();
  }

  Future<List<Event>> listEvents({
    int? cityId,
    int? categoryId,
    DateTime? from,
    DateTime? to,
    String? textQuery,
    double? radiusKm,
    double? userLat,
    double? userLng,
    int limit = 50,
  }) async {
    // --- Base query ---
    dynamic qb = supa.from('events_view').select('''
    id, title, image_url, maps_url, place, is_featured, is_free,
    starts_at, city_id, category_id,
    city_name, category_name, category_icon, category_color
  ''');

    // --- Fechas (en UTC, rango inclusivo/exclusivo) ---
    DateTime? startUtc;
    DateTime? endUtc;
    if (from != null) startUtc = DateTime.utc(from.year, from.month, from.day);
    if (to != null)
      endUtc = DateTime.utc(
        to.year,
        to.month,
        to.day,
      ).add(const Duration(days: 1));

    if (startUtc != null) qb = qb.gte('starts_at', startUtc.toIso8601String());
    if (endUtc != null) qb = qb.lt('starts_at', endUtc.toIso8601String());

    // --- Filtros por ciudad y categoría ---
    if (cityId != null) qb = qb.eq('city_id', cityId);
    if (categoryId != null) qb = qb.eq('category_id', categoryId);

    // --- Búsqueda por texto ---
    if (textQuery != null && textQuery.trim().isNotEmpty) {
      final q = textQuery.trim();
      qb = qb.ilike('title', '%$q%');
    }

    // --- Logs de depuración ---
    debugPrint(
      '[EVENTS] params -> cityId=$cityId categoryId=$categoryId from=$from to=$to text="$textQuery"',
    );

    // --- Ejecución final con orden y límite ---
    final rows = await qb.order('starts_at', ascending: true).limit(limit);

    final events = (rows as List)
        .cast<Map<String, dynamic>>()
        .map(Event.fromMap)
        .toList();

    // Obtener description desde la tabla base para cada evento
    await _enrichEventsWithDescription(events);

    debugPrint('[EVENTS] results -> ${events.length} items');
    for (final e in events.take(10)) {
      debugPrint(
        ' - ${e.title} @ ${e.startsAt.toIso8601String()} (cityId=${e.cityId}, catId=${e.categoryId})',
      );
    }

    return events;
  }

  /// Enriquece los eventos con la descripción desde la tabla base events
  Future<void> _enrichEventsWithDescription(List<Event> events) async {
    if (events.isEmpty) return;

    try {
      // Obtener todos los IDs de eventos
      final eventIds = events.map((e) => e.id).toList();

      // Consultar descriptions desde la tabla base
      // Construir condición OR para múltiples IDs
      if (eventIds.isEmpty) return;

      // Si hay muchos IDs, hacer consultas en lotes para evitar URLs muy largas
      final batchSize = 50;
      final descMap = <String, String?>{};

      for (int i = 0; i < eventIds.length; i += batchSize) {
        final batch = eventIds.skip(i).take(batchSize).toList();
        // Construir condición OR: (id.eq.value1,id.eq.value2,...)
        final orCondition = batch.map((id) => 'id.eq.$id').join(',');

        final descRes = await supa
            .from('events')
            .select('id, description')
            .or(orCondition);

        if (descRes is List) {
          for (final item in descRes) {
            final map = item as Map<String, dynamic>;
            final id = map['id'] as String;
            final desc = map['description'] as String?;
            descMap[id] = desc;
          }
        }
      }

      // Actualizar los eventos con sus descripciones
      for (int i = 0; i < events.length; i++) {
        final event = events[i];
        final desc = descMap[event.id];
        if (desc != null || descMap.containsKey(event.id)) {
          // Crear un nuevo evento con la descripción
          final updatedMap = {
            'id': event.id,
            'title': event.title,
            'starts_at': event.startsAt.toIso8601String(),
            'city_name': event.cityName,
            'category_name': event.categoryName,
            'category_icon': event.categoryIcon,
            'category_color': event.categoryColor,
            'place': event.place,
            'image_url': event.imageUrl,
            'category_id': event.categoryId,
            'city_id': event.cityId,
            'is_free': event.isFree,
            'maps_url': event.mapsUrl,
            'description': desc,
          };
          // Reemplazar el evento en la lista
          events[i] = Event.fromMap(updatedMap);
        }
      }
    } catch (e) {
      debugPrint('Error al enriquecer eventos con description: $e');
      // No lanzar excepción, simplemente continuar sin description
    }
  }

  Future<void> submitEvent({
    required String title,
    required String town,
    required String place,
    required DateTime startsAt,
    required int cityId,
    required int categoryId,
    String? description,
    String? mapsUrl,
    String? imageUrl,
    double? lat,
    double? lng,
    bool isFree = true,
    String? submittedByName,
    String? submittedByEmail,
  }) async {
    final payload = <String, dynamic>{
      'title': title.trim(),
      'town': town.trim(),
      'place': place.trim(),
      'starts_at': startsAt.toUtc().toIso8601String(),
      'city_id': cityId,
      'category_id': categoryId,
      'status': 'pending', // Todos los eventos nuevos empiezan como pendientes
      // dejamos que "category" (texto) use el default 'Todo' o lo rellenamos más adelante
      'description': description?.trim(),
      'maps_url': mapsUrl?.trim(),
      'image_url': imageUrl?.trim(),
      'lat': lat,
      'lng': lng,
      'is_free': isFree,
      'submitted_by_name': submittedByName?.trim(),
      'submitted_by_email': submittedByEmail?.trim(),
    };

    // Eliminar claves con null para no pisar defaults
    payload.removeWhere((key, value) => value == null);

    await supa.from('events').insert(payload);
  }
}
