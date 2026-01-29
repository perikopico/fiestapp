import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../../services/analytics_service.dart';
import '../../services/auth_service.dart';
import '../../services/logger_service.dart';
import '../common/app_bar_logo.dart';

/// Dashboard de administración con gráficos y estadísticas
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final _analytics = AnalyticsService.instance;
  final _supa = Supabase.instance.client;
  
  bool _isLoading = true;
  Map<String, dynamic> _stats = {};
  
  @override
  void initState() {
    super.initState();
    _loadStats();
    _analytics.logScreenView('admin_dashboard');
  }

  Future<void> _loadStats() async {
    setState(() => _isLoading = true);
    
    try {
      // Cargar estadísticas en paralelo
      final results = await Future.wait([
        _getTotalEvents(),
        _getEventsByCategory(),
        _getEventsByMonth(),
        _getPopularEvents(),
        _getPendingEvents(),
        _getActiveUsers(),
      ]);
      
      setState(() {
        _stats = {
          'totalEvents': results[0],
          'eventsByCategory': results[1],
          'eventsByMonth': results[2],
          'popularEvents': results[3],
          'pendingEvents': results[4],
          'activeUsers': results[5],
        };
        _isLoading = false;
      });
    } catch (e) {
      LoggerService.instance.error('Error al cargar estadísticas del admin', error: e);
      setState(() => _isLoading = false);
    }
  }

  Future<int> _getTotalEvents() async {
    try {
      final res = await _supa
          .from('events')
          .select('id', const FetchOptions(count: CountOption.exact));
      return res.length;
    } catch (e) {
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> _getEventsByCategory() async {
    try {
      final res = await _supa
          .from('events_view')
          .select('category_name, category_id')
          .eq('status', 'published');
      
      final Map<String, int> counts = {};
      for (final item in res as List) {
        final categoryName = item['category_name'] as String? ?? 'Sin categoría';
        counts[categoryName] = (counts[categoryName] ?? 0) + 1;
      }
      
      return counts.entries.map((e) => {
        'name': e.key,
        'count': e.value,
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _getEventsByMonth() async {
    try {
      final res = await _supa
          .from('events')
          .select('created_at')
          .order('created_at', ascending: false)
          .limit(1000);
      
      final Map<String, int> counts = {};
      for (final item in res as List) {
        final createdAt = DateTime.parse(item['created_at'] as String);
        final monthKey = DateFormat('MMM yyyy', 'es').format(createdAt);
        counts[monthKey] = (counts[monthKey] ?? 0) + 1;
      }
      
      return counts.entries.map((e) => {
        'month': e.key,
        'count': e.value,
      }).toList()
        ..sort((a, b) => (a['month'] as String).compareTo(b['month'] as String));
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _getPopularEvents() async {
    try {
      final res = await _supa
          .rpc('get_popular_events', params: {'p_limit': 10, 'p_province_id': null});
      
      return (res as List).take(10).map((e) => {
        'title': e['title'] as String? ?? '',
        'views': e['views_count'] as int? ?? 0,
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<int> _getPendingEvents() async {
    try {
      final res = await _supa
          .from('events')
          .select('id')
          .eq('status', 'pending');
      return res.length;
    } catch (e) {
      return 0;
    }
  }

  Future<int> _getActiveUsers() async {
    try {
      // Aproximación: usuarios que han creado eventos
      final res = await _supa
          .from('events')
          .select('created_by')
          .not('created_by', 'is', null);
      final uniqueUsers = (res as List)
          .map((e) => e['created_by'] as String?)
          .whereType<String>()
          .toSet();
      return uniqueUsers.length;
    } catch (e) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!AuthService.instance.isAdmin) {
      return Scaffold(
        appBar: AppBar(
          title: const AppBarLogo(),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: const Center(
          child: Text('Acceso no autorizado'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const AppBarLogo(),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStats,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStats,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // KPIs
                    _buildKPICards(),
                    const SizedBox(height: 24),
                    
                    // Gráfico de eventos por categoría
                    _buildCategoryChart(),
                    const SizedBox(height: 24),
                    
                    // Gráfico de eventos por mes
                    _buildMonthlyChart(),
                    const SizedBox(height: 24),
                    
                    // Top eventos populares
                    _buildPopularEventsList(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildKPICards() {
    final stats = _stats;
    return Row(
      children: [
        Expanded(
          child: _buildKPICard(
            'Total Eventos',
            '${stats['totalEvents'] ?? 0}',
            Icons.event,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildKPICard(
            'Pendientes',
            '${stats['pendingEvents'] ?? 0}',
            Icons.pending_actions,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildKPICard(
            'Usuarios',
            '${stats['activeUsers'] ?? 0}',
            Icons.people,
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildKPICard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChart() {
    final data = _stats['eventsByCategory'] as List<Map<String, dynamic>>? ?? [];
    
    if (data.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: Text('No hay datos de categorías')),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Eventos por Categoría',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: data.map((item) {
                    final color = _getColorForIndex(data.indexOf(item));
                    return PieChartSectionData(
                      value: (item['count'] as num).toDouble(),
                      title: '${item['count']}',
                      color: color,
                      radius: 80,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: data.asMap().entries.map((entry) {
                final item = entry.value;
                final color = _getColorForIndex(entry.key);
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${item['name']}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyChart() {
    final data = _stats['eventsByMonth'] as List<Map<String, dynamic>>? ?? [];
    
    if (data.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: Text('No hay datos mensuales')),
        ),
      );
    }

    final maxCount = data.isEmpty
        ? 0.0
        : data.map((e) => (e['count'] as num).toDouble()).reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Eventos por Mes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxCount * 1.2,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < data.length) {
                            final month = data[index]['month'] as String;
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                month.split(' ')[0],
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return const Text('');
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: data.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: (item['count'] as num).toDouble(),
                          color: Colors.blue,
                          width: 16,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularEventsList() {
    final events = _stats['popularEvents'] as List<Map<String, dynamic>>? ?? [];
    
    if (events.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: Text('No hay eventos populares')),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top 10 Eventos Populares',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...events.asMap().entries.map((entry) {
              final index = entry.key;
              final event = entry.value;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text('${index + 1}'),
                ),
                title: Text(event['title'] as String? ?? ''),
                trailing: Text(
                  '${event['views']} vistas',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Color _getColorForIndex(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.amber,
    ];
    return colors[index % colors.length];
  }
}
