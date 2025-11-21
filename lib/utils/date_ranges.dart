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

/// Obtiene el rango de la semana actual (desde hoy hasta el final de la semana)
QuickDateRange thisWeekRange() {
  final now = DateTime.now();
  // Inicio: hoy a las 00:00
  final start = DateTime(now.year, now.month, now.day);
  // Fin: domingo de esta semana a las 23:59:59.999
  int weekday = now.weekday; // 1=lunes ... 7=domingo
  final daysUntilSunday = 7 - weekday;
  final sundayEnd = DateTime(now.year, now.month, now.day)
      .add(Duration(days: daysUntilSunday))
      .add(const Duration(days: 1))
      .subtract(const Duration(milliseconds: 1)); // Domingo 23:59:59.999
  return QuickDateRange(start, sundayEnd);
}
