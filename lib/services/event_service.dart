import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

import '../models/event.dart';
import 'auth_service.dart';

class EventService {
  EventService._();

  static final instance = EventService._();

  final supa = Supabase.instance.client;

  Future<List<Event>> fetchUpcoming({int limit = 50}) async {
    final r = await supa
        .from('events_view')
        .select(
          'id, title, city_id, city_name, category_id, category_name, starts_at, image_url, maps_url, place, is_featured, price, category_icon, category_color, info_url',
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
    final res = await supa.rpc(
      'get_popular_events_this_week',
      params: {'p_limit': limit},
    );

    if (res == null) return [];

    final list = (res as List).cast<Map<String, dynamic>>();
    final events = list.map((m) => Event.fromMap(m)).toList();
    
    // Obtener description desde la tabla base para cada evento
    await _enrichEventsWithDescription(events);
    return events;
  }

  Future<List<Event>> fetchPopularEvents({
    int? provinceId,
    int limit = 10,
  }) async {
    final params = <String, dynamic>{
      'p_limit': limit,
      'p_province_id': provinceId,
    };

    final res = await supa.rpc('get_popular_events', params: params);

    if (res == null) return [];

    final list = (res as List).cast<Map<String, dynamic>>();
    final events = list.map((m) => Event.fromMap(m)).toList();
    
    // Obtener description desde la tabla base para cada evento
    await _enrichEventsWithDescription(events);
    return events;
  }

  Future<void> incrementEventView(String eventId) async {
    try {
      await supa.rpc('increment_event_view', params: {
        'p_event_id': eventId,
      });
    } catch (e) {
      // Por ahora solo log, no queremos romper la UI si falla
      debugPrint('incrementEventView error: $e');
    }
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
    debugPrint(
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
          'id,title,city_id,city_name,category_id,category_name,starts_at,image_url,maps_url,place,is_featured,price,category_icon,category_color,info_url',
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

      debugPrint(
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

      // Ordenar: si hay distance_km, mantener el orden de la BD (distancia luego fecha)
      // Si no hay distance_km, ordenar solo por fecha
      events.sort((a, b) {
        // Si ambos tienen distancia, ordenar primero por distancia y luego por fecha
        if (a.distanceKm != null && b.distanceKm != null) {
          final distanceCompare = a.distanceKm!.compareTo(b.distanceKm!);
          if (distanceCompare != 0) return distanceCompare;
          // Si la distancia es igual, ordenar por fecha
          return a.startsAt.compareTo(b.startsAt);
        }
        // Si solo uno tiene distancia, el que tiene distancia va primero
        if (a.distanceKm != null) return -1;
        if (b.distanceKm != null) return 1;
        // Si ninguno tiene distancia, ordenar solo por fecha
        return a.startsAt.compareTo(b.startsAt);
      });
      final limitedEvents = events.take(limit).toList();
      // Enriquecer con información de categoría si falta
      await _enrichEventsWithCategory(limitedEvents);
      // Obtener description desde la tabla base para cada evento
      await _enrichEventsWithDescription(limitedEvents);
      return limitedEvents;
    }

    final res = await qb.order('starts_at', ascending: true).limit(limit);

    if (res is List) {
      debugPrint(
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
          'id, title, place, starts_at, image_url, image_alignment, city_id, category_id, price, is_featured, description, info_url',
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
    id, title, image_url, maps_url, place, is_featured, price,
    starts_at, city_id, category_id,
    city_name, category_name, category_icon, category_color, info_url
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

  /// Enriquece los eventos con información de categoría si falta
  Future<void> _enrichEventsWithCategory(List<Event> events) async {
    if (events.isEmpty) return;

    // Filtrar eventos que necesitan información de categoría
    final eventsNeedingCategory = events.where((e) =>
      e.categoryId != null &&
      (e.categoryName == null || e.categoryIcon == null || e.categoryColor == null)
    ).toList();

    if (eventsNeedingCategory.isEmpty) return;

    try {
      // Obtener todos los categoryIds únicos
      final categoryIds = eventsNeedingCategory
          .map((e) => e.categoryId!)
          .toSet()
          .toList();

      if (categoryIds.isEmpty) return;

      // Consultar categorías desde la tabla categories
      final batchSize = 50;
      final categoryMap = <int, Map<String, dynamic>>{};

      for (int i = 0; i < categoryIds.length; i += batchSize) {
        final batch = categoryIds.skip(i).take(batchSize).toList();
        final orCondition = batch.map((id) => 'id.eq.$id').join(',');

        final catRes = await supa
            .from('categories')
            .select('id, name, icon, color')
            .or(orCondition);

        if (catRes is List) {
          for (final cat in catRes) {
            final catMap = cat as Map<String, dynamic>;
            final id = (catMap['id'] as num).toInt();
            categoryMap[id] = catMap;
          }
        }
      }

      // Actualizar eventos con información de categoría usando el mismo patrón que _enrichEventsWithDescription
      for (int i = 0; i < events.length; i++) {
        final event = events[i];
        if (event.categoryId != null && categoryMap.containsKey(event.categoryId)) {
          final cat = categoryMap[event.categoryId]!;
          // Crear un nuevo evento con la información de categoría actualizada
          final updatedMap = {
            'id': event.id,
            'title': event.title,
            'starts_at': event.startsAt.toIso8601String(),
            'city_name': event.cityName,
            'category_name': event.categoryName ?? cat['name'],
            'category_icon': event.categoryIcon ?? cat['icon'],
            'category_color': event.categoryColor ?? cat['color'],
            'place': event.place,
            'image_url': event.imageUrl,
            'category_id': event.categoryId,
            'city_id': event.cityId,
            'price': event.price,
            'maps_url': event.mapsUrl,
            'description': event.description,
            'image_alignment': event.imageAlignment,
          };
          events[i] = Event.fromMap(updatedMap);
        }
      }
    } catch (e) {
      debugPrint('Error al enriquecer eventos con categoría: $e');
    }
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
            'price': event.price,
            'maps_url': event.mapsUrl,
            'description': desc,
            'image_alignment': event.imageAlignment,
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

  /// Obtiene eventos por sus IDs
  Future<List<Event>> fetchEventsByIds(List<String> ids) async {
    if (ids.isEmpty) {
      return [];
    }

    try {
      // Construir condición OR para múltiples IDs: (id.eq.value1,id.eq.value2,...)
      // Si hay muchos IDs, hacer consultas en lotes para evitar URLs muy largas
      final batchSize = 50;
      List<Event> allEvents = [];

      for (int i = 0; i < ids.length; i += batchSize) {
        final batch = ids.skip(i).take(batchSize).toList();
        final orCondition = batch.map((id) => 'id.eq.$id').join(',');

        final r = await supa
            .from('events_view')
            .select(
              'id, title, city_id, city_name, category_id, category_name, starts_at, image_url, maps_url, place, is_featured, price, category_icon, category_color, image_alignment, info_url',
            )
            .or(orCondition);

        final events = (r as List)
            .map((e) => Event.fromMap(e as Map<String, dynamic>))
            .toList();

        allEvents.addAll(events);
      }

      // Obtener description desde la tabla base para cada evento
      await _enrichEventsWithDescription(allEvents);

      return allEvents;
    } catch (e) {
      debugPrint('Error al obtener eventos por IDs: $e');
      return [];
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
    String? price,
    String? submittedByName,
    String? submittedByEmail,
    String? imageAlignment,
    String? venueId, // ID del lugar si se seleccionó uno existente
  }) async {
    // Obtener el ID del usuario si está autenticado
    final userId = AuthService.instance.currentUserId;
    
    final payload = <String, dynamic>{
      'title': title.trim(),
      'town': town.trim(),
      'place': place.trim(), // Mantener para compatibilidad
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
      'price': price?.trim() ?? 'Gratis',
      'submitted_by_name': submittedByName?.trim(),
      'submitted_by_email': submittedByEmail?.trim(),
      'image_alignment': imageAlignment ?? 'center',
      'venue_id': venueId, // ID del lugar si se seleccionó uno
    };

    // Añadir created_by solo si el usuario está autenticado
    if (userId != null) {
      payload['created_by'] = userId;
      debugPrint('✅ Evento creado por usuario autenticado: $userId');
    } else {
      debugPrint('⚠️ Evento creado sin usuario autenticado (created_by será null)');
    }

    // Eliminar claves con null para no pisar defaults
    payload.removeWhere((key, value) => value == null);

    await supa.from('events').insert(payload);
  }

  /// Actualiza un evento existente
  Future<void> updateEvent({
    required String eventId,
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
    String? price,
    String? imageAlignment,
  }) async {
    final payload = <String, dynamic>{
      'title': title.trim(),
      'town': town.trim(),
      'place': place.trim(),
      'starts_at': startsAt.toUtc().toIso8601String(),
      'city_id': cityId,
      'category_id': categoryId,
      'description': description?.trim(),
      'maps_url': mapsUrl?.trim(),
      'image_url': imageUrl?.trim(),
      'lat': lat,
      'lng': lng,
      'price': price?.trim() ?? 'Gratis',
      'image_alignment': imageAlignment ?? 'center',
    };

    // Eliminar claves con null para no pisar valores existentes
    payload.removeWhere((key, value) => value == null);

    await supa.from('events').update(payload).eq('id', eventId);
  }

  /// Busca posibles eventos duplicados basándose en criterios de similitud
  /// Un evento es considerado duplicado si:
  /// 1) Comparte la misma ciudad, y
  /// 2) Ocurre en el mismo día calendario (ignorando hora), o
  /// 3) Tiene un título/descripción muy similar
  Future<List<Event>> getPotentialDuplicateEvents(Event event) async {
    if (event.cityId == null) {
      return [];
    }

    try {
      // Obtener la fecha del evento (solo día, sin hora)
      final eventDate = DateTime(
        event.startsAt.year,
        event.startsAt.month,
        event.startsAt.day,
      );
      
      // Fechas de inicio y fin del mismo día calendario
      final dateStart = DateTime(eventDate.year, eventDate.month, eventDate.day, 0, 0, 0);
      final dateEnd = DateTime(eventDate.year, eventDate.month, eventDate.day, 23, 59, 59);

      // Normalizar el título para búsqueda de similitud
      // Tomar las primeras palabras significativas del título (hasta 30 caracteres)
      final normalizedTitle = event.title
          .trim()
          .toLowerCase()
          .split(' ')
          .where((w) => w.length > 2)
          .take(5)
          .join(' ');
      final normalizedTitleForSearch = normalizedTitle.length > 30 
          ? normalizedTitle.substring(0, 30) 
          : normalizedTitle;

      // Construir consulta base - buscar eventos en la misma ciudad
      // Haremos dos consultas: una para mismo día, otra para similitud de texto
      
      // Consulta 1: Mismo día calendario
      final sameDateQuery = supa
          .from('events_view')
          .select(
            'id, title, city_id, city_name, category_id, category_name, starts_at, image_url, maps_url, place, is_featured, price, category_icon, category_color, description, image_alignment, info_url',
          )
          .eq('city_id', event.cityId!)
          .neq('id', event.id)
          .gte('starts_at', dateStart.toIso8601String())
          .lte('starts_at', dateEnd.toIso8601String());

      // Consulta 2: Similitud de texto (solo si hay título normalizado)
      List<Event> textSimilarEvents = [];
      if (normalizedTitleForSearch.isNotEmpty && normalizedTitleForSearch.length >= 3) {
        try {
          // Hacer dos consultas separadas: una para título, otra para descripción
          // Esto es más robusto que usar OR con ilike
          
          // Consulta por título
          final titleQuery = supa
              .from('events_view')
              .select(
                'id, title, city_id, city_name, category_id, category_name, starts_at, image_url, maps_url, place, is_featured, price, category_icon, category_color, description, image_alignment, info_url',
              )
              .eq('city_id', event.cityId!)
              .neq('id', event.id)
              .ilike('title', '%$normalizedTitleForSearch%');

          final titleRes = await titleQuery.limit(10);
          if (titleRes is List) {
            final titleEvents = (titleRes as List)
                .cast<Map<String, dynamic>>()
                .map((m) => Event.fromMap(m))
                .toList();
            textSimilarEvents.addAll(titleEvents);
          }

          // Consulta por descripción
          final descQuery = supa
              .from('events_view')
              .select(
                'id, title, city_id, city_name, category_id, category_name, starts_at, image_url, maps_url, place, is_featured, price, category_icon, category_color, description, image_alignment, info_url',
              )
              .eq('city_id', event.cityId!)
              .neq('id', event.id)
              .ilike('description', '%$normalizedTitleForSearch%');

          final descRes = await descQuery.limit(10);
          if (descRes is List) {
            final descEvents = (descRes as List)
                .cast<Map<String, dynamic>>()
                .map((m) => Event.fromMap(m))
                .toList();
            textSimilarEvents.addAll(descEvents);
          }
        } catch (e) {
          debugPrint('Error en consulta de similitud de texto: $e');
          // Continuar sin esta consulta si falla
        }
      }

      // Ejecutar consulta de mismo día
      final sameDateRes = await sameDateQuery.order('starts_at', ascending: true).limit(10);

      // Combinar resultados
      final Set<String> seenIds = {};
      final List<Event> duplicates = [];

      // Agregar eventos del mismo día
      if (sameDateRes is List) {
        final sameDateEvents = (sameDateRes as List)
            .cast<Map<String, dynamic>>()
            .map((m) => Event.fromMap(m))
            .toList();
        
        for (final evt in sameDateEvents) {
          if (!seenIds.contains(evt.id)) {
            duplicates.add(evt);
            seenIds.add(evt.id);
          }
        }
      }

      // Agregar eventos con similitud de texto (solo si no están ya incluidos)
      for (final evt in textSimilarEvents) {
        if (!seenIds.contains(evt.id)) {
          // Verificar que el título/descripción sea realmente similar
          final evtTitle = evt.title.toLowerCase();
          final evtDesc = (evt.description ?? '').toLowerCase();
          
          // Verificar si el título normalizado está contenido en el título o descripción del candidato
          if (evtTitle.contains(normalizedTitleForSearch) || 
              (evtDesc.isNotEmpty && evtDesc.contains(normalizedTitleForSearch))) {
            duplicates.add(evt);
            seenIds.add(evt.id);
          }
        }
      }

      // Enriquecer con descripciones
      await _enrichEventsWithDescription(duplicates);

      // Ordenar por proximidad de fecha (mismo día primero, luego por diferencia de días)
      duplicates.sort((a, b) {
        final aDate = DateTime(a.startsAt.year, a.startsAt.month, a.startsAt.day);
        final bDate = DateTime(b.startsAt.year, b.startsAt.month, b.startsAt.day);
        
        // Mismo día primero
        final aIsSameDay = aDate == eventDate;
        final bIsSameDay = bDate == eventDate;
        if (aIsSameDay && !bIsSameDay) return -1;
        if (!aIsSameDay && bIsSameDay) return 1;
        
        // Luego por diferencia de días
        final aDiff = (aDate.difference(eventDate).inDays).abs();
        final bDiff = (bDate.difference(eventDate).inDays).abs();
        return aDiff.compareTo(bDiff);
      });

      return duplicates.take(5).toList();
    } catch (e) {
      debugPrint('Error al buscar duplicados: $e');
      return [];
    }
  }

  /// Obtiene los eventos creados por el usuario actual
  /// Solo funciona si el usuario está autenticado
  Future<List<Event>> fetchUserCreatedEvents() async {
    final userId = AuthService.instance.currentUserId;
    if (userId == null) {
      debugPrint('⚠️ Usuario no autenticado, no se pueden obtener eventos del usuario');
      return [];
    }

    try {
      // Obtener eventos directamente de la tabla events (no events_view porque solo muestra published)
      final r = await supa
          .from('events')
          .select(
            'id, title, city_id, category_id, starts_at, image_url, maps_url, place, '
            'is_featured, price, status, description, image_alignment, info_url',
          )
          .eq('created_by', userId)
          .order('starts_at', ascending: false); // Más recientes primero

      final events = (r as List)
          .map((e) => Event.fromMap(e as Map<String, dynamic>))
          .toList();

      // Enriquecer con información de categorías y ciudades
      await _enrichEventsWithCategory(events);
      await _enrichEventsWithCities(events);
      // Las descripciones ya están incluidas en la query

      return events;
    } catch (e) {
      debugPrint('❌ Error al obtener eventos del usuario: $e');
      throw Exception('Error al obtener tus eventos: ${e.toString()}');
    }
  }

  /// Enriquece eventos con información de ciudades
  Future<void> _enrichEventsWithCities(List<Event> events) async {
    if (events.isEmpty) return;

    try {
      final cityIds = events
          .where((e) => e.cityId != null)
          .map((e) => e.cityId!)
          .toSet()
          .toList();

      if (cityIds.isEmpty) return;

      // Obtener ciudades una por una o usar consulta con OR
      // Para múltiples IDs, hacemos consultas en lotes
      final citiesResponse = <Map<String, dynamic>>[];
      final batchSize = 50;
      
      for (int i = 0; i < cityIds.length; i += batchSize) {
        final batch = cityIds.skip(i).take(batchSize).toList();
        // Construir condición OR para múltiples IDs
        final orCondition = batch.map((id) => 'id.eq.$id').join(',');
        final batchResponse = await supa
            .from('cities')
            .select('id, name')
            .or(orCondition);
        citiesResponse.addAll((batchResponse as List).cast<Map<String, dynamic>>());
      }

      final citiesMap = {
        for (var city in citiesResponse as List)
          (city['id'] as num).toInt(): city['name'] as String
      };

      // Enriquecer eventos con nombres de ciudades
      for (int i = 0; i < events.length; i++) {
        final event = events[i];
        if (event.cityId != null && citiesMap.containsKey(event.cityId)) {
          final updatedMap = {
            'id': event.id,
            'title': event.title,
            'starts_at': event.startsAt.toIso8601String(),
            'city_name': citiesMap[event.cityId],
            'category_name': event.categoryName,
            'category_icon': event.categoryIcon,
            'category_color': event.categoryColor,
            'place': event.place,
            'image_url': event.imageUrl,
            'category_id': event.categoryId,
            'city_id': event.cityId,
            'price': event.price,
            'maps_url': event.mapsUrl,
            'description': event.description,
            'image_alignment': event.imageAlignment,
            'status': event.status,
          };
          events[i] = Event.fromMap(updatedMap);
        }
      }
    } catch (e) {
      debugPrint('⚠️ Error al enriquecer eventos con ciudades: $e');
    }
  }
}
