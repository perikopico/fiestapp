import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/event.dart';
import '../icons/icon_mapper.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFFBF5EF),
      appBar: AppBar(
        title: const Text('Detalle del evento'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFF2E6DB),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen principal (con fallback)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Hero(
                tag: 'event-img-${event.id}',
                child: event.imageUrl != null && event.imageUrl!.isNotEmpty
                    ? Image.network(event.imageUrl!, height: 200, width: double.infinity, fit: BoxFit.cover)
                    : Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.black12,
                        alignment: Alignment.center,
                        child: const Icon(Icons.event, size: 56),
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // Título
            Text(event.title, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),

            // Chips de meta
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (event.cityName != null)
                  Chip(
                    label: Text(event.cityName!),
                    avatar: const Icon(Icons.place, size: 18),
                    backgroundColor: Colors.grey.shade200,
                  ),
                if (event.categoryName != null)
                  Chip(
                    label: Text(event.categoryName!),
                    avatar: Icon(
                      iconFromName(event.categoryIcon),
                      size: 18,
                    ),
                    backgroundColor: Colors.grey.shade200,
                  ),
                Chip(
                  label: Text(event.formattedDate),
                  avatar: const Icon(Icons.event, size: 18),
                  backgroundColor: Colors.grey.shade200,
                ),
                Chip(
                  label: Text(event.formattedTime),
                  avatar: const Icon(Icons.schedule, size: 18),
                  backgroundColor: Colors.grey.shade200,
                ),
                if (event.isFree == true)
                  const Chip(
                    label: Text('Gratis'),
                    avatar: Icon(Icons.check_circle, size: 18),
                    backgroundColor: Color(0xFFDFF5DD),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Lugar
            if (event.place != null && event.place!.isNotEmpty) ...[
              Text('Lugar', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(event.place!, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 16),
            ],

            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () async {
                      final url = event.mapsUrl ?? '';
                      if (url.isEmpty) return;
                      final uri = Uri.parse(url);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    },
                    icon: const Icon(Icons.map),
                    label: const Text('Ver en mapa'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      final parts = <String>[
                        event.title,
                        if (event.place != null && event.place!.isNotEmpty) 'Lugar: ${event.place!}',
                        if (event.cityName != null) 'Ciudad: ${event.cityName!}',
                        '${event.formattedDate} ${event.formattedTime}',
                        if (event.mapsUrl != null && event.mapsUrl!.isNotEmpty) 'Mapa: ${event.mapsUrl}',
                      ];
                      Share.share(parts.where((s) => s.trim().isNotEmpty).join('\n'));
                    },
                    icon: const Icon(Icons.ios_share),
                    label: const Text('Compartir'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

