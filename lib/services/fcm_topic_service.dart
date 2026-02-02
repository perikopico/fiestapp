// lib/services/fcm_topic_service.dart
// Servicio para gestionar suscripciones a FCM Topics (ciudades y categorías)

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Servicio para gestionar suscripciones a FCM Topics
class FCMTopicService {
  FCMTopicService._();
  
  static final FCMTopicService instance = FCMTopicService._();
  
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  
  // Keys para SharedPreferences
  static const String _keySubscribedCities = 'fcm_subscribed_cities';
  static const String _keySubscribedCategories = 'fcm_subscribed_categories';
  
  /// Normaliza el nombre de una ciudad para crear el topic de FCM
  /// Los topics de FCM solo permiten: [a-zA-Z0-9-_.~%]
  String _normalizeCityNameForTopic(String cityName) {
    return cityName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }
  
  /// Normaliza el nombre de una categoría para crear el topic de FCM
  String _normalizeCategoryNameForTopic(String categoryName) {
    return categoryName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }
  
  /// Obtiene el nombre del topic para una ciudad
  String getCityTopic(String cityName) {
    final normalized = _normalizeCityNameForTopic(cityName);
    return 'city_$normalized';
  }
  
  /// Obtiene el nombre del topic para una categoría
  String getCategoryTopic(String categoryName) {
    final normalized = _normalizeCategoryNameForTopic(categoryName);
    return 'category_$normalized';
  }
  
  /// Suscribe a notificaciones de una ciudad
  Future<bool> subscribeToCity(String cityName) async {
    try {
      final topic = getCityTopic(cityName);
      await _messaging.subscribeToTopic(topic);
      
      // Guardar en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final subscribedCities = await getSubscribedCities();
      if (!subscribedCities.contains(cityName)) {
        subscribedCities.add(cityName);
        await prefs.setStringList(_keySubscribedCities, subscribedCities);
      }
      
      debugPrint('✅ Suscrito al topic de ciudad: $topic ($cityName)');
      return true;
    } catch (e) {
      debugPrint('❌ Error al suscribirse a ciudad $cityName: $e');
      return false;
    }
  }
  
  /// Desuscribe de notificaciones de una ciudad
  Future<bool> unsubscribeFromCity(String cityName) async {
    try {
      final topic = getCityTopic(cityName);
      await _messaging.unsubscribeFromTopic(topic);
      
      // Actualizar SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final subscribedCities = await getSubscribedCities();
      subscribedCities.remove(cityName);
      await prefs.setStringList(_keySubscribedCities, subscribedCities);
      
      debugPrint('✅ Desuscrito del topic de ciudad: $topic ($cityName)');
      return true;
    } catch (e) {
      debugPrint('❌ Error al desuscribirse de ciudad $cityName: $e');
      return false;
    }
  }
  
  /// Suscribe a múltiples ciudades
  Future<void> subscribeToCities(List<String> cityNames) async {
    for (final cityName in cityNames) {
      await subscribeToCity(cityName);
    }
  }
  
  /// Desuscribe de múltiples ciudades
  Future<void> unsubscribeFromCities(List<String> cityNames) async {
    for (final cityName in cityNames) {
      await unsubscribeFromCity(cityName);
    }
  }
  
  /// Actualiza las suscripciones de ciudades (suscribe nuevas, desuscribe las que ya no están)
  Future<void> updateCitySubscriptions(List<String> selectedCities) async {
    final currentSubscriptions = await getSubscribedCities();
    
    // Desuscribirse de ciudades que ya no están seleccionadas
    final toUnsubscribe = currentSubscriptions
        .where((city) => !selectedCities.contains(city))
        .toList();
    await unsubscribeFromCities(toUnsubscribe);
    
    // Suscribirse a nuevas ciudades
    final toSubscribe = selectedCities
        .where((city) => !currentSubscriptions.contains(city))
        .toList();
    await subscribeToCities(toSubscribe);
  }
  
  /// Obtiene las ciudades a las que está suscrito
  Future<List<String>> getSubscribedCities() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keySubscribedCities) ?? [];
  }
  
  /// Suscribe a notificaciones de una categoría
  Future<bool> subscribeToCategory(String categoryName) async {
    try {
      final topic = getCategoryTopic(categoryName);
      await _messaging.subscribeToTopic(topic);
      
      // Guardar en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final subscribedCategories = await getSubscribedCategories();
      if (!subscribedCategories.contains(categoryName)) {
        subscribedCategories.add(categoryName);
        await prefs.setStringList(_keySubscribedCategories, subscribedCategories);
      }
      
      debugPrint('✅ Suscrito al topic de categoría: $topic ($categoryName)');
      return true;
    } catch (e) {
      debugPrint('❌ Error al suscribirse a categoría $categoryName: $e');
      return false;
    }
  }
  
  /// Desuscribe de notificaciones de una categoría
  Future<bool> unsubscribeFromCategory(String categoryName) async {
    try {
      final topic = getCategoryTopic(categoryName);
      await _messaging.unsubscribeFromTopic(topic);
      
      // Actualizar SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final subscribedCategories = await getSubscribedCategories();
      subscribedCategories.remove(categoryName);
      await prefs.setStringList(_keySubscribedCategories, subscribedCategories);
      
      debugPrint('✅ Desuscrito del topic de categoría: $topic ($categoryName)');
      return true;
    } catch (e) {
      debugPrint('❌ Error al desuscribirse de categoría $categoryName: $e');
      return false;
    }
  }
  
  /// Actualiza las suscripciones de categorías
  Future<void> updateCategorySubscriptions(List<String> selectedCategories) async {
    final currentSubscriptions = await getSubscribedCategories();
    
    // Desuscribirse de categorías que ya no están seleccionadas
    final toUnsubscribe = currentSubscriptions
        .where((cat) => !selectedCategories.contains(cat))
        .toList();
    for (final cat in toUnsubscribe) {
      await unsubscribeFromCategory(cat);
    }
    
    // Suscribirse a nuevas categorías
    final toSubscribe = selectedCategories
        .where((cat) => !currentSubscriptions.contains(cat))
        .toList();
    for (final cat in toSubscribe) {
      await subscribeToCategory(cat);
    }
  }
  
  /// Obtiene las categorías a las que está suscrito
  Future<List<String>> getSubscribedCategories() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keySubscribedCategories) ?? [];
  }
  
  /// Limpia todas las suscripciones (útil para logout)
  Future<void> clearAllSubscriptions() async {
    final cities = await getSubscribedCities();
    final categories = await getSubscribedCategories();
    
    await unsubscribeFromCities(cities);
    for (final cat in categories) {
      await unsubscribeFromCategory(cat);
    }
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keySubscribedCities);
    await prefs.remove(_keySubscribedCategories);
  }
}
