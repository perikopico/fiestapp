import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

import '../models/event.dart';
import 'auth_service.dart';
import 'logger_service.dart';
import '../utils/validation_utils.dart';

class EventService {
  EventService._();

  static final instance = EventService._();

  final supa = Supabase.instance.client;

  Future<List<Event>> fetchUpcoming({int limit = 50}) async {
    final r = await supa
        .from('events_view')
        .select(
          'id, title, city_id, city_name, category_id, category_name, starts_at, image_url, maps_url, place, is_featured, price, category_icon, category_color, info_url, lat, lng, venue_id',
        )
        .order('starts_at', ascending: true)
        .limit(limit);
    final events = (r as List)
        .map((e) => Event.fromMap(e as Map<String, dynamic>))
        .toList();
    // Obtener description desde la tabla base para cada evento
    await _enrichEventsWithDescription(events);
    // Enriquecer con categorías múltiples
    await _enrichEventsWithMultipleCategories(events);
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
    // Enriquecer con categorías múltiples
    await _enrichEventsWithMultipleCategories(events);
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
    // Enriquecer con categorías múltiples
    await _enrichEventsWithMultipleCategories(events);
    return events;
  }

  Future<void> incrementEventView(String eventId) async {
    try {
      await supa.rpc('increment_event_view', params: {
        'p_event_id': eventId,
      });
    } catch (e) {
      // Por ahora solo log, no queremos romper la UI si falla
      LoggerService.instance.error('Error al incrementar vista de evento', error: e);
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
    LoggerService.instance.debug(
      'fetchEvents llamado',
      data: {
        'cityIds': cityIds?.toString(),
        'categoryId': categoryId,
        'from': from?.toIso8601String(),
        'to': to?.toIso8601String(),
        'radiusKm': radiusKm,
        'center': center?.toString(),
        'searchTerm': searchTerm,
      },
    );
    // Usamos la vista/materializada "events_view" (ajústalo si usas otra)
    dynamic qb = supa
        .from('events_view')
        .select(
          'id,title,city_id,city_name,category_id,category_name,starts_at,image_url,maps_url,place,is_featured,price,category_icon,category_color,info_url,lat,lng,venue_id',
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
    // Filtro de categoría: buscar en category_id (principal) o en el array category_ids
    // Nota: PostgREST no soporta directamente filtros en arrays, así que usamos una condición OR
    // o filtramos en el cliente después de obtener los resultados
    if (categoryId != null) {
      // Filtrar por categoría principal (esto captura la mayoría de casos)
      qb = qb.eq('category_id', categoryId);
      // Nota: Los eventos con categoría secundaria también se capturarán si tienen
      // la categoría como principal. Para eventos que solo tienen la categoría como secundaria,
      // el filtro se aplicará en el cliente después de obtener los resultados.
    }
    if (from != null) qb = qb.gte('starts_at', from.toIso8601String());
    if (to != null) {
      // Incluir eventos hasta el final del día 'to'
      // Agregar 1 día para incluir todos los eventos del día 'to'
      final toNextDay = DateTime(to.year, to.month, to.day).add(const Duration(days: 1));
      qb = qb.lt('starts_at', toNextDay.toIso8601String());
    }

    // Búsqueda libre por evento (título, ciudad y lugar/venue)
    if (searchTerm != null && searchTerm.trim().isNotEmpty) {
      final t = searchTerm.trim();
      // Buscar en título, ciudad y lugar usando OR
      // PostgREST permite múltiples condiciones OR
      final orCondition = 'title.ilike.%$t%,city_name.ilike.%$t%,place.ilike.%$t%';
      qb = qb.or(orCondition);
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

      LoggerService.instance.debug(
        'fetchEvents RPC completado',
        data: {
          'radiusKm': radiusKm,
          'searchTerm': searchTerm,
          'eventosAntesFiltros': events.length,
        },
      );

      // Aplicar filtros adicionales en el cliente
      final beforeCategoryFilter = events.length;
      if (categoryId != null) {
        // Filtrar eventos que tengan la categoría (principal o secundaria)
        events = events.where((e) {
          // Verificar categoría principal
          if (e.categoryId == categoryId) return true;
          // Verificar categorías secundarias
          if (e.categoryIds != null && e.categoryIds!.contains(categoryId)) return true;
          return false;
        }).toList();
        LoggerService.instance.debug(
          'Filtro categoría aplicado',
          data: {
            'categoryId': categoryId,
            'antes': beforeCategoryFilter,
            'después': events.length,
          },
        );
      }
      
      final beforeDateFilter = events.length;
      if (from != null) {
        // Incluir eventos que empiezan en 'from' o después
        // Usar >= en lugar de > para incluir eventos que empiezan exactamente en 'from'
        events = events
            .where(
              (e) =>
                  e.startsAt.isAfter(from.subtract(const Duration(seconds: 1))) ||
                  e.startsAt.isAtSameMomentAs(from),
            )
            .toList();
        LoggerService.instance.debug(
          'Filtro fecha FROM aplicado',
          data: {
            'from': from.toIso8601String(),
            'antes': beforeDateFilter,
            'después': events.length,
          },
        );
      }
      if (to != null) {
        final beforeToFilter = events.length;
        // Incluir eventos que empiezan antes o igual a 'to'
        // Para el filtro "Hoy", 'to' es el final del día (23:59:59.999)
        // Necesitamos incluir todos los eventos que empiezan en ese día o antes
        // Usar comparación directa: si el evento empieza antes o igual al final del día siguiente, incluirlo
        final toNextDay = DateTime(to.year, to.month, to.day).add(const Duration(days: 1));
        events = events.where((e) {
          // Incluir si el evento empieza antes del día siguiente a 'to'
          return e.startsAt.isBefore(toNextDay);
        }).toList();
        LoggerService.instance.debug(
          'Filtro fecha TO aplicado',
          data: {
            'to': to.toIso8601String(),
            'toNextDay': toNextDay.toIso8601String(),
            'antes': beforeToFilter,
            'después': events.length,
            'ejemplo_evento_startsAt': beforeToFilter > 0 ? events.isNotEmpty ? events.first.startsAt.toIso8601String() : 'ninguno' : 'ninguno',
          },
        );
      }
      if (searchTerm != null && searchTerm.trim().isNotEmpty) {
        final t = searchTerm.trim().toLowerCase();
        events = events
            .where((e) {
              // Buscar en título, ciudad y lugar
              final titleMatch = e.title.toLowerCase().contains(t);
              final cityMatch = e.cityName?.toLowerCase().contains(t) ?? false;
              final placeMatch = e.place?.toLowerCase().contains(t) ?? false;
              return titleMatch || cityMatch || placeMatch;
            })
            .toList();
      }

      // Filtrar eventos pasados como medida de seguridad adicional
      // Un evento se considera pasado si ya pasaron más de 5 horas del día siguiente
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final beforePastFilter = events.length;
      events = events.where((event) {
        // Si el evento es de hoy o futuro, incluirlo
        final eventDate = DateTime(event.startsAt.year, event.startsAt.month, event.startsAt.day);
        if (eventDate.isAfter(todayStart) || eventDate.isAtSameMomentAs(todayStart)) {
          return true;
        }
        // Si el evento es de ayer o anterior, excluirlo
        return false;
      }).toList();
      if (beforePastFilter != events.length) {
        LoggerService.instance.debug(
          'Filtro eventos pasados aplicado',
          data: {
            'antes': beforePastFilter,
            'después': events.length,
          },
        );
      }

      // Ordenar eventos con jerarquía estricta de prioridades:
      // PRIORIDAD 1 (CRITERIO PRINCIPAL): Fecha y Hora (ascendente - más próximos primero)
      // PRIORIDAD 2 (TIE-BREAKER): Distancia (ascendente - más cercanos primero, solo si misma fecha)
      events.sort((a, b) {
        // CRITERIO PRINCIPAL: Comparar por fecha y hora completa (DateTime ya incluye ambos)
        // DateTime.compareTo() compara fecha Y hora, retornando:
        // - negativo si a < b (a es anterior)
        // - cero si a == b (misma fecha y hora)
        // - positivo si a > b (a es posterior)
        final dateCompare = a.startsAt.compareTo(b.startsAt);
        
        // Si las fechas son diferentes, retornar inmediatamente (prioridad absoluta)
        if (dateCompare != 0) {
          return dateCompare;
        }
        
        // CRITERIO SECUNDARIO (TIE-BREAKER): Solo se aplica si las fechas son iguales
        // Comparar por distancia (menor distancia primero)
        final aDistance = a.distanceKm;
        final bDistance = b.distanceKm;
        
        // Si ambos tienen distancia, comparar numéricamente
        if (aDistance != null && bDistance != null) {
          return aDistance.compareTo(bDistance);
        }
        
        // Si solo uno tiene distancia, priorizar el que tiene distancia (más información)
        if (aDistance != null && bDistance == null) return -1;
        if (aDistance == null && bDistance != null) return 1;
        
        // Si ninguno tiene distancia y tienen la misma fecha, mantener orden original
        return 0;
      });
      final limitedEvents = events.take(limit).toList();
      // Enriquecer con información de categoría si falta
      await _enrichEventsWithCategory(limitedEvents);
      // Obtener description desde la tabla base para cada evento
      await _enrichEventsWithDescription(limitedEvents);
      // Enriquecer con categorías múltiples
      await _enrichEventsWithMultipleCategories(limitedEvents);
      return limitedEvents;
    }

    final res = await qb.order('starts_at', ascending: true).limit(limit);

    if (res is List) {
      LoggerService.instance.debug(
        'fetchEvents query completada',
        data: {
          'searchTerm': searchTerm,
          'eventos': res.length,
        },
      );
      // Debug: verificar el primer evento solo si hay eventos y estamos en modo debug
      if (res is List && res.isNotEmpty && kDebugMode) {
        final firstEvent = res.first as Map<String, dynamic>;
        LoggerService.instance.debug(
          'Primer evento - campos disponibles',
          data: {'eventId': firstEvent['id']},
        );
      }
      
      final events = res
          .map((m) => Event.fromMap(m as Map<String, dynamic>))
          .toList();
      
      // Aplicar filtro de categoría adicional si es necesario (para capturar categorías secundarias)
      List<Event> categoryFilteredEvents = events;
      if (categoryId != null) {
        categoryFilteredEvents = events.where((e) {
          // Verificar categoría principal
          if (e.categoryId == categoryId) return true;
          // Verificar categorías secundarias
          if (e.categoryIds != null && e.categoryIds!.contains(categoryId)) return true;
          return false;
        }).toList();
      }
      
      // Filtrar eventos pasados como medida de seguridad adicional
      // Un evento se considera pasado si ya pasaron más de 5 horas del día siguiente
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final filteredEvents = categoryFilteredEvents.where((event) {
        // Si el evento es de hoy o futuro, incluirlo
        final eventDate = DateTime(event.startsAt.year, event.startsAt.month, event.startsAt.day);
        if (eventDate.isAfter(todayStart) || eventDate.isAtSameMomentAs(todayStart)) {
          return true;
        }
        // Si el evento es de ayer o anterior, excluirlo
        return false;
      }).toList();
      
      // Obtener description desde la tabla base para cada evento
      await _enrichEventsWithDescription(filteredEvents);
      // Enriquecer con categorías múltiples
      await _enrichEventsWithMultipleCategories(filteredEvents);
      return filteredEvents;
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

    // Usar events_view para tener acceso a city_name
    dynamic qb = supa
        .from('events_view')
        .select(
          'id, title, place, starts_at, image_url, image_alignment, city_id, city_name, category_id, category_name, category_icon, category_color, price, is_featured, description, info_url',
        );

    // Autocompletado NO debe limitar por ciudad
    // pero si quieres que busque por provincia podría hacerse aquí
    // Por ahora: búsqueda global

    if (q.isNotEmpty) {
      // Buscar en título, ciudad y lugar usando OR
      final orCondition = 'title.ilike.%$q%,city_name.ilike.%$q%,place.ilike.%$q%';
      qb = qb.or(orCondition);
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
    city_name, category_name, category_icon, category_color, info_url,
    lat, lng, venue_id
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
    // Filtro de categoría: buscar en category_id (principal) o en el array category_ids
    if (categoryId != null) {
      // Filtrar por categoría principal (esto captura la mayoría de casos)
      qb = qb.eq('category_id', categoryId);
      // Nota: Los eventos con categoría secundaria también se capturarán si tienen
      // la categoría como principal. Para eventos que solo tienen la categoría como secundaria,
      // el filtro se aplicará en el cliente después de obtener los resultados.
    }

    // --- Búsqueda por texto ---
    if (textQuery != null && textQuery.trim().isNotEmpty) {
      final q = textQuery.trim();
      qb = qb.ilike('title', '%$q%');
    }

    // --- Logs de depuración ---
    LoggerService.instance.debug(
      'listEvents llamado',
      data: {
        'cityId': cityId,
        'categoryId': categoryId,
        'from': from?.toIso8601String(),
        'to': to?.toIso8601String(),
        'textQuery': textQuery,
      },
    );

    // --- Ejecución final con orden y límite ---
    final rows = await qb.order('starts_at', ascending: true).limit(limit);

    final events = (rows as List)
        .cast<Map<String, dynamic>>()
        .map(Event.fromMap)
        .toList();

    // Obtener description desde la tabla base para cada evento
    await _enrichEventsWithDescription(events);
    // Enriquecer con categorías múltiples
    await _enrichEventsWithMultipleCategories(events);

    LoggerService.instance.debug(
      'listEvents resultados',
      data: {'total': events.length},
    );

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
        // Usar .filter() con 'in' para mejor rendimiento
        final catRes = await supa
            .from('categories')
            .select('id, name, icon, color')
            .filter('id', 'in', '(${batch.join(',')})');

        if (catRes is List) {
          for (final cat in catRes) {
            final catMap = cat as Map<String, dynamic>;
            final id = (catMap['id'] as num).toInt();
            categoryMap[id] = catMap;
          }
        }
      }

      // Actualizar eventos con información de categoría solo si falta
      for (int i = 0; i < events.length; i++) {
        final event = events[i];
        if (event.categoryId != null && categoryMap.containsKey(event.categoryId)) {
          final cat = categoryMap[event.categoryId]!;
          
          // Solo actualizar si realmente falta información
          if (event.categoryName == null || event.categoryIcon == null || event.categoryColor == null) {
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
              'info_url': event.infoUrl,
              'status': event.status,
              'venue_id': event.venueId,
              'owner_approved': event.ownerApproved,
              'owner_approved_at': event.ownerApprovedAt?.toIso8601String(),
              'owner_rejected_reason': event.ownerRejectedReason,
              'distance_km': event.distanceKm,
              'lat': event.lat,
              'lng': event.lng,
              'category_ids': event.categoryIds,
              'category_names': event.categoryNames,
              'category_icons': event.categoryIcons,
              'category_colors': event.categoryColors,
            };
            events[i] = Event.fromMap(updatedMap);
          }
        }
      }
    } catch (e, stackTrace) {
      LoggerService.instance.error(
        'Error al enriquecer eventos con categoría',
        error: e,
        stackTrace: stackTrace,
      );
      // Continuar sin categorías enriquecidas - los eventos seguirán funcionando
    }
  }

  /// Enriquece los eventos con categorías múltiples desde event_categories
  /// Solo consulta la BD si los eventos no tienen ya las categorías múltiples cargadas
  Future<void> _enrichEventsWithMultipleCategories(List<Event> events) async {
    if (events.isEmpty) return;

    try {
      // Filtrar eventos que ya tienen categorías múltiples cargadas desde la vista
      final eventsNeedingEnrichment = events.where((e) =>
        e.categoryIds == null || e.categoryIds!.isEmpty || 
        e.categoryNames == null || e.categoryNames!.isEmpty
      ).toList();

      // Si todos los eventos ya tienen categorías múltiples, no hacer nada
      if (eventsNeedingEnrichment.isEmpty) return;

      // Obtener todos los IDs de eventos que necesitan enriquecimiento
      final eventIds = eventsNeedingEnrichment.map((e) => e.id).toList();
      if (eventIds.isEmpty) return;

      // Consultar categorías múltiples desde event_categories
      final batchSize = 50;
      final Map<String, List<Map<String, dynamic>>> eventCategoriesMap = {};

      for (int i = 0; i < eventIds.length; i += batchSize) {
        final batch = eventIds.skip(i).take(batchSize).toList();
        
        final categoriesRes = await supa
            .from('event_categories')
            .select('event_id, category_id, is_primary')
            .filter('event_id', 'in', '(${batch.join(',')})')
            .order('is_primary', ascending: false);

        if (categoriesRes is List) {
          for (final item in categoriesRes) {
            final map = item as Map<String, dynamic>;
            final eventId = map['event_id'] as String;
            final categoryId = (map['category_id'] as num).toInt();
            final isPrimary = map['is_primary'] as bool? ?? false;
            
            if (!eventCategoriesMap.containsKey(eventId)) {
              eventCategoriesMap[eventId] = [];
            }
            eventCategoriesMap[eventId]!.add({
              'category_id': categoryId,
              'is_primary': isPrimary,
            });
          }
        }
      }

      // Obtener información de las categorías
      final allCategoryIds = <int>{};
      for (final categories in eventCategoriesMap.values) {
        for (final cat in categories) {
          allCategoryIds.add(cat['category_id'] as int);
        }
      }

      if (allCategoryIds.isEmpty) return;

      // Cargar información de todas las categorías
      final categoryInfoMap = <int, Map<String, dynamic>>{};
      final categoryBatchSize = 50;
      final categoryIdsList = allCategoryIds.toList();

      for (int i = 0; i < categoryIdsList.length; i += categoryBatchSize) {
        final batch = categoryIdsList.skip(i).take(categoryBatchSize).toList();
        final catRes = await supa
            .from('categories')
            .select('id, name, icon, color')
            .filter('id', 'in', '(${batch.join(',')})');

        if (catRes is List) {
          for (final cat in catRes) {
            final catMap = cat as Map<String, dynamic>;
            final id = (catMap['id'] as num).toInt();
            categoryInfoMap[id] = catMap;
          }
        }
      }

      // Actualizar solo los eventos que necesitan enriquecimiento
      for (int i = 0; i < events.length; i++) {
        final event = events[i];
        
        // Si el evento ya tiene categorías múltiples, saltarlo
        if (event.categoryIds != null && event.categoryIds!.isNotEmpty &&
            event.categoryNames != null && event.categoryNames!.isNotEmpty) {
          continue;
        }
        
        final categories = eventCategoriesMap[event.id];
        
        if (categories != null && categories.isNotEmpty) {
          // Ordenar por is_primary (principal primero)
          categories.sort((a, b) => (b['is_primary'] as bool ? 1 : 0).compareTo(a['is_primary'] as bool ? 1 : 0));
          
          final categoryIds = <int>[];
          final categoryNames = <String>[];
          final categoryIcons = <String>[];
          final categoryColors = <String>[];

          for (final cat in categories) {
            final catId = cat['category_id'] as int;
            final catInfo = categoryInfoMap[catId];
            
            if (catInfo != null) {
              categoryIds.add(catId);
              categoryNames.add(catInfo['name'] as String? ?? '');
              categoryIcons.add(catInfo['icon'] as String? ?? '');
              categoryColors.add(catInfo['color'] as String? ?? '');
            }
          }

          if (categoryIds.isNotEmpty) {
            // Crear un nuevo evento con las categorías múltiples
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
              'description': event.description,
              'image_alignment': event.imageAlignment,
              'info_url': event.infoUrl,
              'status': event.status,
              'venue_id': event.venueId,
              'owner_approved': event.ownerApproved,
              'owner_approved_at': event.ownerApprovedAt?.toIso8601String(),
              'owner_rejected_reason': event.ownerRejectedReason,
              'distance_km': event.distanceKm,
              'lat': event.lat,
              'lng': event.lng,
              'category_ids': categoryIds,
              'category_names': categoryNames,
              'category_icons': categoryIcons,
              'category_colors': categoryColors,
            };
            events[i] = Event.fromMap(updatedMap);
          }
        }
      }
    } catch (e, stackTrace) {
      LoggerService.instance.error(
        'Error al enriquecer eventos con categorías múltiples',
        error: e,
        stackTrace: stackTrace,
      );
      // Continuar sin categorías múltiples - los eventos seguirán funcionando con categoría principal
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
      final infoUrlMap = <String, String?>{};

      for (int i = 0; i < eventIds.length; i += batchSize) {
        final batch = eventIds.skip(i).take(batchSize).toList();
        // Usar .filter() con 'in' para mejor rendimiento que .or()
        final descRes = await supa
            .from('events')
            .select('id, description, info_url')
            .filter('id', 'in', '(${batch.join(',')})');

        if (descRes is List) {
          for (final item in descRes) {
            final map = item as Map<String, dynamic>;
            final id = map['id'] as String;
            final desc = map['description'] as String?;
            final infoUrl = map['info_url'] as String?;
            descMap[id] = desc;
            infoUrlMap[id] = infoUrl;
          }
        }
      }

      // Actualizar los eventos con sus descripciones e info_url solo si hay cambios
      for (int i = 0; i < events.length; i++) {
        final event = events[i];
        final desc = descMap[event.id];
        final infoUrl = infoUrlMap[event.id];
        
        // Solo actualizar si hay cambios reales
        final needsUpdate = (desc != null && desc != event.description) ||
            (infoUrl != null && infoUrl != event.infoUrl) ||
            (descMap.containsKey(event.id) && event.description == null);
        
        if (needsUpdate) {
          // Crear un nuevo evento con la descripción e info_url actualizados
          // IMPORTANTE: Incluir todos los campos del evento original
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
            'description': desc ?? event.description,
            'image_alignment': event.imageAlignment,
            'info_url': infoUrl ?? event.infoUrl,
            'status': event.status,
            'venue_id': event.venueId,
            'owner_approved': event.ownerApproved,
            'owner_approved_at': event.ownerApprovedAt?.toIso8601String(),
            'owner_rejected_reason': event.ownerRejectedReason,
            'distance_km': event.distanceKm,
            'lat': event.lat,
            'lng': event.lng,
            'category_ids': event.categoryIds,
            'category_names': event.categoryNames,
            'category_icons': event.categoryIcons,
            'category_colors': event.categoryColors,
          };
          events[i] = Event.fromMap(updatedMap);
        }
      }
    } catch (e, stackTrace) {
      LoggerService.instance.error(
        'Error al enriquecer eventos con description',
        error: e,
        stackTrace: stackTrace,
      );
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
        // Usar .filter() con 'in' para mejor rendimiento
        final r = await supa
            .from('events_view')
            .select(
              'id, title, city_id, city_name, category_id, category_name, starts_at, image_url, maps_url, place, is_featured, price, category_icon, category_color, image_alignment, info_url, lat, lng, venue_id',
            )
            .filter('id', 'in', '(${batch.join(',')})');

        // Debug: verificar el primer evento solo si hay eventos y estamos en modo debug
        if (r is List && r.isNotEmpty && kDebugMode) {
          final firstEvent = r.first as Map<String, dynamic>;
          LoggerService.instance.debug(
            'fetchEventsByIds - Primer evento',
            data: {'eventId': firstEvent['id']},
          );
        }
        
        final events = (r as List)
            .map((e) => Event.fromMap(e as Map<String, dynamic>))
            .toList();

        allEvents.addAll(events);
      }

      // Obtener description desde la tabla base para cada evento
      await _enrichEventsWithDescription(allEvents);
      // Enriquecer con categorías múltiples
      await _enrichEventsWithMultipleCategories(allEvents);

      return allEvents;
    } catch (e, stackTrace) {
      LoggerService.instance.error(
        'Error al obtener eventos por IDs',
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  /// Crea un nuevo evento
  /// 
  /// [categoryId] - Categoría principal (obligatoria, para compatibilidad con BBDD actual)
  /// [categoryIds] - Lista opcional de categorías adicionales (máximo 2 total)
  ///                 Por ahora solo se usa la primera, pero se guarda para futuro
  Future<void> submitEvent({
    required String title,
    required String town,
    required String place,
    required DateTime startsAt,
    required int cityId,
    required int categoryId, // Categoría principal (obligatoria)
    List<int>? categoryIds, // Lista adicional de categorías (para soporte futuro)
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
    String? infoUrl, // URL de interés relacionada con el evento
  }) async {
    // Validaciones
    if (!ValidationUtils.isNotEmpty(title)) {
      throw ArgumentError('El título del evento es obligatorio');
    }
    
    if (mapsUrl != null && mapsUrl.isNotEmpty && !ValidationUtils.isValidUrl(mapsUrl)) {
      LoggerService.instance.warning('mapsUrl inválido proporcionado', data: {'mapsUrl': mapsUrl});
      // No lanzar error, solo loguear y continuar sin mapsUrl
    }
    
    if (imageUrl != null && imageUrl.isNotEmpty && !ValidationUtils.isValidUrl(imageUrl)) {
      LoggerService.instance.warning('imageUrl inválido proporcionado', data: {'imageUrl': imageUrl});
      // No lanzar error, solo loguear y continuar sin imageUrl
    }
    
    if (infoUrl != null && infoUrl.isNotEmpty && !ValidationUtils.isValidUrl(infoUrl)) {
      LoggerService.instance.warning('infoUrl inválido proporcionado', data: {'infoUrl': infoUrl});
      // No lanzar error, solo loguear y continuar sin infoUrl
    }
    
    if (lat != null && lng != null && !ValidationUtils.isValidCoordinates(lat, lng)) {
      throw ArgumentError('Las coordenadas proporcionadas no son válidas');
    }
    
    if (submittedByEmail != null && submittedByEmail.isNotEmpty && !ValidationUtils.isValidEmail(submittedByEmail)) {
      LoggerService.instance.warning('Email inválido proporcionado', data: {'email': submittedByEmail});
      // No lanzar error, solo loguear
    }
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
      'info_url': infoUrl?.trim(), // URL de interés
    };

    // Añadir created_by solo si el usuario está autenticado
    if (userId != null) {
      payload['created_by'] = userId;
      LoggerService.instance.info('Evento creado por usuario autenticado', data: {'userId': userId});
    } else {
      LoggerService.instance.warning('Evento creado sin usuario autenticado');
    }

    // Eliminar claves con null para no pisar defaults
    payload.removeWhere((key, value) => value == null);

    // Insertar el evento y obtener el ID
    final insertResult = await supa.from('events').insert(payload).select('id').single();
    final newEventId = insertResult['id'] as String;

    // Guardar categorías en event_categories
    // Siempre guardar la categoría principal, y si hay categorías adicionales, guardarlas también
    try {
      final List<Map<String, dynamic>> categoryPayloads = [];
      
      // Primero, agregar la categoría principal
      categoryPayloads.add({
        'event_id': newEventId,
        'category_id': categoryId,
        'is_primary': true,
      });
      
      // Si hay categorías adicionales, agregarlas también (evitando duplicar la principal)
      if (categoryIds != null && categoryIds.isNotEmpty) {
        for (final catId in categoryIds) {
          // Solo agregar si no es la categoría principal
          if (catId != categoryId) {
            categoryPayloads.add({
              'event_id': newEventId,
              'category_id': catId,
              'is_primary': false,
            });
          }
        }
      }

      if (categoryPayloads.isNotEmpty) {
        await supa.from('event_categories').insert(categoryPayloads);
        LoggerService.instance.info('Categorías guardadas en event_categories', data: {'eventId': newEventId, 'count': categoryPayloads.length});
      }
    } catch (e) {
      // Si la tabla event_categories no existe aún, solo loguear el error
      LoggerService.instance.warning('No se pudieron guardar categorías múltiples', data: {'error': e.toString()});
    }
  }

  /// Actualiza un evento existente
  Future<void> updateEvent({
    required String eventId,
    required String title,
    required String town,
    required String place,
    required DateTime startsAt,
    required int cityId,
    required int categoryId, // Categoría principal (obligatoria)
    List<int>? categoryIds, // Lista adicional de categorías (para soporte futuro)
    String? description,
    String? mapsUrl,
    String? imageUrl,
    double? lat,
    double? lng,
    String? price,
    String? imageAlignment,
    String? infoUrl, // URL de interés relacionada con el evento
  }) async {
    // Validaciones
    if (!ValidationUtils.isNotEmpty(title)) {
      throw ArgumentError('El título del evento es obligatorio');
    }
    
    if (mapsUrl != null && mapsUrl.isNotEmpty && !ValidationUtils.isValidUrl(mapsUrl)) {
      LoggerService.instance.warning('mapsUrl inválido proporcionado', data: {'mapsUrl': mapsUrl});
    }
    
    if (imageUrl != null && imageUrl.isNotEmpty && !ValidationUtils.isValidUrl(imageUrl)) {
      LoggerService.instance.warning('imageUrl inválido proporcionado', data: {'imageUrl': imageUrl});
    }
    
    if (infoUrl != null && infoUrl.isNotEmpty && !ValidationUtils.isValidUrl(infoUrl)) {
      LoggerService.instance.warning('infoUrl inválido proporcionado', data: {'infoUrl': infoUrl});
    }
    
    if (lat != null && lng != null && !ValidationUtils.isValidCoordinates(lat, lng)) {
      throw ArgumentError('Las coordenadas proporcionadas no son válidas');
    }
    
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
      'info_url': infoUrl?.trim(), // URL de interés
    };

    // Eliminar claves con null para no pisar valores existentes
    payload.removeWhere((key, value) => value == null);

    // Actualizar el evento
    await supa.from('events').update(payload).eq('id', eventId);

    // Actualizar categorías en event_categories
    // Si se proporcionaron categoryIds, actualizar; si no, solo asegurar que la principal esté
    try {
      // Primero, eliminar todas las categorías existentes del evento
      await supa
          .from('event_categories')
          .delete()
          .eq('event_id', eventId);

      final List<Map<String, dynamic>> categoryPayloads = [];
      
      // Siempre agregar la categoría principal
      categoryPayloads.add({
        'event_id': eventId,
        'category_id': categoryId,
        'is_primary': true,
      });
      
      // Si hay categorías adicionales, agregarlas también (evitando duplicar la principal)
      if (categoryIds != null && categoryIds.isNotEmpty) {
        for (final catId in categoryIds) {
          // Solo agregar si no es la categoría principal
          if (catId != categoryId) {
            categoryPayloads.add({
              'event_id': eventId,
              'category_id': catId,
              'is_primary': false,
            });
          }
        }
      }

      if (categoryPayloads.isNotEmpty) {
        await supa.from('event_categories').insert(categoryPayloads);
        LoggerService.instance.info('Categorías actualizadas en event_categories', data: {'eventId': eventId, 'count': categoryPayloads.length});
      }
    } catch (e) {
      // Si la tabla event_categories no existe aún, solo loguear el error
      LoggerService.instance.warning('No se pudieron guardar categorías múltiples', data: {'error': e.toString()});
    }
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
          LoggerService.instance.error('Error en consulta de similitud de texto', error: e);
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
      // Enriquecer con categorías múltiples
      await _enrichEventsWithMultipleCategories(duplicates);

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
      LoggerService.instance.error('Error al buscar duplicados', error: e);
      return [];
    }
  }

  /// Obtiene los eventos creados por el usuario actual
  /// Solo funciona si el usuario está autenticado
  Future<List<Event>> fetchUserCreatedEvents() async {
    final userId = AuthService.instance.currentUserId;
    if (userId == null) {
      LoggerService.instance.warning('Usuario no autenticado, no se pueden obtener eventos del usuario');
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
      LoggerService.instance.error('Error al obtener eventos del usuario', error: e);
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
        // Usar .filter() con 'in' para mejor rendimiento
        final batchResponse = await supa
            .from('cities')
            .select('id, name')
            .filter('id', 'in', '(${batch.join(',')})');
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
      LoggerService.instance.error('Error al enriquecer eventos con ciudades', error: e);
    }
  }
}
