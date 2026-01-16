import 'package:intl/intl.dart';

class QuickDateRange {
  final DateTime from;
  final DateTime to;
  const QuickDateRange(this.from, this.to);
}

QuickDateRange todayRange() {
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day);
  final end = start
      .add(const Duration(days: 1))
      .subtract(const Duration(milliseconds: 1));
  return QuickDateRange(start, end);
}

QuickDateRange weekendRange() {
  final now = DateTime.now();
  // Asumimos sábado-domingo del fin de semana actual (o próximo si ya pasó)
  int weekday = now.weekday; // 1=lunes ... 7=domingo
  final saturday = DateTime(
    now.year,
    now.month,
    now.day,
  ).add(Duration(days: (6 - weekday))); // Sábado
  final sundayEnd = DateTime(saturday.year, saturday.month, saturday.day)
      .add(const Duration(days: 2))
      .subtract(const Duration(milliseconds: 1)); // Domingo 23:59:59.999
  return QuickDateRange(saturday, sundayEnd);
}

QuickDateRange thisMonthRange() {
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, 1);
  final nextMonth = (now.month == 12)
      ? DateTime(now.year + 1, 1, 1)
      : DateTime(now.year, now.month + 1, 1);
  final end = nextMonth.subtract(const Duration(milliseconds: 1));
  return QuickDateRange(start, end);
}

/// Obtiene el rango de los próximos 7 días (desde hoy hasta hoy + 7 días)
QuickDateRange next7DaysRange() {
  final now = DateTime.now();
  // Inicio: hoy a las 00:00
  final start = DateTime(now.year, now.month, now.day);
  // Fin: hoy + 7 días a las 23:59:59.999
  final end = DateTime(now.year, now.month, now.day)
      .add(const Duration(days: 7))
      .subtract(const Duration(milliseconds: 1));
  return QuickDateRange(start, end);
}

/// Obtiene el rango de los próximos 30 días (desde hoy hasta hoy + 30 días)
QuickDateRange next30DaysRange() {
  final now = DateTime.now();
  // Inicio: hoy a las 00:00
  final start = DateTime(now.year, now.month, now.day);
  // Fin: hoy + 30 días a las 23:59:59.999
  final end = DateTime(now.year, now.month, now.day)
      .add(const Duration(days: 30))
      .subtract(const Duration(milliseconds: 1));
  return QuickDateRange(start, end);
}

/// Obtiene el rango del próximo fin de semana (viernes, sábado y domingo)
QuickDateRange nextWeekendRange() {
  final now = DateTime.now();
  int weekday = now.weekday; // 1=lunes ... 7=domingo
  
  // Calcular días hasta el próximo viernes
  // Si hoy es viernes, sábado o domingo, el próximo fin de semana es el siguiente
  int daysUntilFriday;
  if (weekday <= 5) {
    // Si no es viernes, calcular días hasta el próximo viernes
    daysUntilFriday = 5 - weekday;
  } else {
    // Si es viernes, sábado o domingo, el próximo viernes está en la siguiente semana
    daysUntilFriday = 5 + (7 - weekday); // Ej: si es sábado (6), 5 + (7-6) = 6 días
  }
  
  final friday = DateTime(now.year, now.month, now.day)
      .add(Duration(days: daysUntilFriday));
  final sundayEnd = friday
      .add(const Duration(days: 2)) // Viernes + 2 días = Domingo
      .subtract(const Duration(milliseconds: 1)); // Domingo 23:59:59.999
  
  return QuickDateRange(friday, sundayEnd);
}
