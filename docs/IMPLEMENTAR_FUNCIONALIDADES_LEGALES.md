# 🔧 Guía de Implementación - Funcionalidades Legales

Este documento contiene guías paso a paso para implementar las funcionalidades legales requeridas.

---

## 1. 🗑️ Eliminación de Cuenta (Derecho al Olvido)

### Paso 1: Crear función SQL en Supabase

```sql
-- docs/migrations/008_add_delete_user_function.sql

-- Función para eliminar todos los datos de un usuario
CREATE OR REPLACE FUNCTION public.delete_user_data(user_uuid uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Eliminar favoritos (CASCADE automático si está configurado)
  DELETE FROM public.user_favorites WHERE user_id = user_uuid;
  
  -- Eliminar tokens FCM
  DELETE FROM public.user_fcm_tokens WHERE user_id = user_uuid;
  
  -- Anonimizar eventos creados (mantener eventos pero sin creador)
  UPDATE public.events 
  SET created_by = NULL 
  WHERE created_by = user_uuid;
  
  -- Anonimizar lugares creados
  UPDATE public.venues 
  SET created_by = NULL 
  WHERE created_by = user_uuid;
  
  -- Eliminar de admins
  DELETE FROM public.admins WHERE user_id = user_uuid;
  
  -- Eliminar de venue_managers
  DELETE FROM public.venue_managers WHERE user_id = user_uuid;
  
  -- NOTA: La eliminación de la cuenta de auth.users debe hacerse desde la app
  -- usando Supabase Admin API o desde el dashboard
END;
$$;

-- Comentario
COMMENT ON FUNCTION public.delete_user_data IS 
'Elimina todos los datos personales de un usuario (derecho al olvido RGPD)';
```

### Paso 2: Crear servicio en Flutter

```dart
// lib/services/account_deletion_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';

class AccountDeletionService {
  static final AccountDeletionService instance = AccountDeletionService._();
  AccountDeletionService._();

  /// Elimina todos los datos del usuario y su cuenta
  Future<void> deleteAccount() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception('No hay usuario autenticado');
    }

    try {
      // 1. Eliminar datos personales usando la función SQL
      await Supabase.instance.client.rpc(
        'delete_user_data',
        params: {'user_uuid': user.id},
      );

      // 2. Eliminar cuenta de autenticación
      // Nota: Esto requiere usar Admin API o hacerlo desde el dashboard
      // Por ahora, el usuario puede eliminar su cuenta manualmente
      // o puedes usar Supabase Admin API con service role key
      
      await Supabase.instance.client.auth.signOut();
      
      // 3. Limpiar datos locales
      // (favoritos locales, preferencias, etc.)
      
    } catch (e) {
      throw Exception('Error al eliminar cuenta: $e');
    }
  }

  /// Solicita eliminación de cuenta (para usar con Admin API)
  Future<void> requestAccountDeletion() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception('No hay usuario autenticado');
    }

    // Opción 1: Usar Admin API (requiere service role key en backend)
    // Opción 2: Crear tabla de solicitudes de eliminación
    // Opción 3: Enviar email al administrador
    
    // Por ahora, eliminar datos y cerrar sesión
    await deleteAccount();
  }
}
```

### Paso 3: Añadir UI en ProfileScreen

```dart
// En lib/ui/auth/profile_screen.dart

// Añadir en la lista de opciones:
ListTile(
  leading: const Icon(Icons.delete_forever, color: Colors.red),
  title: const Text('Eliminar cuenta'),
  subtitle: const Text('Eliminar todos tus datos permanentemente'),
  onTap: () => _showDeleteAccountDialog(),
);

Future<void> _showDeleteAccountDialog() async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('⚠️ Eliminar cuenta'),
      content: const Text(
        'Esta acción no se puede deshacer. Se eliminarán:\n\n'
        '• Tu cuenta y perfil\n'
        '• Todos tus favoritos\n'
        '• Tus eventos creados (se mantendrán pero sin tu nombre)\n'
        '• Todas tus preferencias\n\n'
        '¿Estás seguro de que quieres eliminar tu cuenta?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Eliminar cuenta'),
        ),
      ],
    ),
  );

  if (confirm != true) return;

  // Confirmación final
  final finalConfirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('⚠️ Última confirmación'),
      content: const Text(
        'Esta es tu última oportunidad. ¿Realmente quieres eliminar tu cuenta permanentemente?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('SÍ, ELIMINAR'),
        ),
      ],
    ),
  );

  if (finalConfirm != true) return;

  setState(() => _isLoading = true);

  try {
    await AccountDeletionService.instance.deleteAccount();
    
    if (!mounted) return;
    
    Navigator.of(context).popUntil((route) => route.isFirst);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cuenta eliminada correctamente'),
        duration: Duration(seconds: 3),
      ),
    );
  } catch (e) {
    if (!mounted) return;
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error al eliminar cuenta: $e'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}
```

---

## 2. 📤 Exportación de Datos (Derecho de Portabilidad)

### Paso 1: Crear función SQL

```sql
-- docs/migrations/009_add_export_user_data_function.sql

-- Función para exportar todos los datos de un usuario
CREATE OR REPLACE FUNCTION public.export_user_data(user_uuid uuid)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  result jsonb;
BEGIN
  SELECT jsonb_build_object(
    'profile', (
      SELECT jsonb_build_object(
        'id', id,
        'email', email,
        'created_at', created_at,
        'updated_at', updated_at
      )
      FROM auth.users
      WHERE id = user_uuid
    ),
    'favorites', (
      SELECT jsonb_agg(
        jsonb_build_object(
          'event_id', event_id,
          'created_at', created_at
        )
      )
      FROM public.user_favorites
      WHERE user_id = user_uuid
    ),
    'events_created', (
      SELECT jsonb_agg(
        jsonb_build_object(
          'id', id,
          'title', title,
          'created_at', created_at,
          'status', status
        )
      )
      FROM public.events
      WHERE created_by = user_uuid
    ),
    'fcm_tokens', (
      SELECT jsonb_agg(
        jsonb_build_object(
          'device_type', device_type,
          'created_at', created_at,
          'updated_at', updated_at
        )
      )
      FROM public.user_fcm_tokens
      WHERE user_id = user_uuid
    ),
    'is_admin', EXISTS(
      SELECT 1 FROM public.admins WHERE user_id = user_uuid
    ),
    'export_date', now()
  ) INTO result;
  
  RETURN result;
END;
$$;
```

### Paso 2: Crear servicio en Flutter

```dart
// lib/services/data_export_service.dart

import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DataExportService {
  static final DataExportService instance = DataExportService._();
  DataExportService._();

  /// Exporta todos los datos del usuario
  Future<void> exportUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception('No hay usuario autenticado');
    }

    try {
      // Obtener datos desde Supabase
      final response = await Supabase.instance.client.rpc(
        'export_user_data',
        params: {'user_uuid': user.id},
      );

      // Convertir a JSON formateado
      final jsonString = const JsonEncoder.withIndent('  ').convert(response);
      
      // Guardar en archivo temporal
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/queplan_export_${DateTime.now().millisecondsSinceEpoch}.json');
      await file.writeAsString(jsonString);

      // Compartir archivo
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Mis datos de QuePlan',
        subject: 'Exportación de datos - QuePlan',
      );
    } catch (e) {
      throw Exception('Error al exportar datos: $e');
    }
  }
}
```

### Paso 3: Añadir UI en ProfileScreen

```dart
// En lib/ui/auth/profile_screen.dart

ListTile(
  leading: const Icon(Icons.download),
  title: const Text('Exportar mis datos'),
  subtitle: const Text('Descargar todos tus datos en formato JSON'),
  onTap: () => _exportUserData(),
);

Future<void> _exportUserData() async {
  setState(() => _isLoading = true);

  try {
    await DataExportService.instance.exportUserData();
    
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Datos exportados correctamente'),
        duration: Duration(seconds: 3),
      ),
    );
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error al exportar datos: $e'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  } finally {
    setState(() => _isLoading = false);
  }
}
```

---

## 3. 🚩 Sistema de Reporte de Contenido

### Paso 1: Crear tabla en Supabase

```sql
-- docs/migrations/010_create_content_reports_table.sql

CREATE TABLE IF NOT EXISTS public.content_reports (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  reported_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  content_type text NOT NULL, -- 'event', 'venue'
  content_id uuid NOT NULL,
  reason text NOT NULL, -- 'inappropriate', 'spam', 'false_info', 'copyright', 'other'
  description text,
  status text DEFAULT 'pending', -- 'pending', 'reviewed', 'resolved', 'dismissed'
  reviewed_by uuid REFERENCES auth.users(id),
  reviewed_at timestamptz,
  created_at timestamptz DEFAULT now()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_content_reports_status ON public.content_reports(status);
CREATE INDEX IF NOT EXISTS idx_content_reports_content ON public.content_reports(content_type, content_id);

-- RLS
ALTER TABLE public.content_reports ENABLE ROW LEVEL SECURITY;

-- Política: Usuarios pueden crear reportes
CREATE POLICY "Users can create reports" ON public.content_reports
  FOR INSERT
  WITH CHECK (auth.uid() = reported_by);

-- Política: Usuarios pueden ver sus propios reportes
CREATE POLICY "Users can read own reports" ON public.content_reports
  FOR SELECT
  USING (auth.uid() = reported_by);

-- Política: Admins pueden ver todos los reportes
CREATE POLICY "Admins can read all reports" ON public.content_reports
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.admins
      WHERE admins.user_id = auth.uid()
    )
  );

-- Política: Admins pueden actualizar reportes
CREATE POLICY "Admins can update reports" ON public.content_reports
  FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.admins
      WHERE admins.user_id = auth.uid()
    )
  );
```

### Paso 2: Crear servicio en Flutter

```dart
// lib/services/report_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';

enum ReportReason {
  inappropriate,
  spam,
  falseInfo,
  copyright,
  other,
}

class ReportService {
  static final ReportService instance = ReportService._();
  ReportService._();

  Future<void> reportContent({
    required String contentType, // 'event' o 'venue'
    required String contentId,
    required ReportReason reason,
    String? description,
  }) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception('Debes estar autenticado para reportar contenido');
    }

    try {
      await Supabase.instance.client.from('content_reports').insert({
        'reported_by': user.id,
        'content_type': contentType,
        'content_id': contentId,
        'reason': reason.name,
        'description': description,
      });
    } catch (e) {
      throw Exception('Error al reportar contenido: $e');
    }
  }
}
```

### Paso 3: Añadir UI en EventDetailScreen

```dart
// En lib/ui/event/event_detail_screen.dart

// Añadir en el menú de acciones:
PopupMenuButton(
  itemBuilder: (context) => [
    // ... otros items
    const PopupMenuItem(
      value: 'report',
      child: Row(
        children: [
          Icon(Icons.flag, color: Colors.red),
          SizedBox(width: 8),
          Text('Reportar evento'),
        ],
      ),
    ),
  ],
  onSelected: (value) {
    if (value == 'report') {
      _showReportDialog();
    }
  },
);

Future<void> _showReportDialog() async {
  ReportReason? selectedReason;
  final descriptionController = TextEditingController();

  final result = await showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('Reportar evento'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('¿Por qué quieres reportar este evento?'),
            const SizedBox(height: 16),
            ...ReportReason.values.map((reason) => RadioListTile<ReportReason>(
              title: Text(_getReasonText(reason)),
              value: reason,
              groupValue: selectedReason,
              onChanged: (value) => setState(() => selectedReason = value),
            )),
            if (selectedReason == ReportReason.other) ...[
              const SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Describe el problema',
                  hintText: 'Explica por qué reportas este evento...',
                ),
                maxLines: 3,
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: selectedReason == null
                ? null
                : () => Navigator.of(context).pop(true),
            child: const Text('Reportar'),
          ),
        ],
      ),
    ),
  );

  if (result == true && selectedReason != null) {
    try {
      await ReportService.instance.reportContent(
        contentType: 'event',
        contentId: widget.event.id,
        reason: selectedReason,
        description: descriptionController.text.isEmpty 
            ? null 
            : descriptionController.text,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Evento reportado. Gracias por tu ayuda.'),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al reportar: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}

String _getReasonText(ReportReason reason) {
  switch (reason) {
    case ReportReason.inappropriate:
      return 'Contenido inapropiado';
    case ReportReason.spam:
      return 'Spam';
    case ReportReason.falseInfo:
      return 'Información falsa';
    case ReportReason.copyright:
      return 'Violación de derechos';
    case ReportReason.other:
      return 'Otro';
  }
}
```

---

## 4. ✅ Consentimiento GDPR

### Crear pantalla de consentimiento

```dart
// lib/ui/legal/gdpr_consent_screen.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GDPRConsentScreen extends StatefulWidget {
  const GDPRConsentScreen({super.key});

  @override
  State<GDPRConsentScreen> createState() => _GDPRConsentScreenState();
}

class _GDPRConsentScreenState extends State<GDPRConsentScreen> {
  bool _consentLocation = false;
  bool _consentNotifications = false;
  bool _consentProfile = false;
  bool _consentAnalytics = false;
  bool _acceptedTerms = false;

  Future<void> _saveConsent() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    // Guardar consentimientos en Supabase
    await Supabase.instance.client.from('user_consents').upsert({
      'user_id': user.id,
      'consent_location': _consentLocation,
      'consent_notifications': _consentNotifications,
      'consent_profile': _consentProfile,
      'consent_analytics': _consentAnalytics,
      'accepted_terms': _acceptedTerms,
      'consent_date': DateTime.now().toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consentimiento de Datos'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Protección de Datos',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Para usar QuePlan, necesitamos tu consentimiento para procesar tus datos personales según el RGPD.',
            ),
            const SizedBox(height: 24),
            
            // Términos y condiciones
            CheckboxListTile(
              title: const Text('Acepto los Términos y Condiciones'),
              subtitle: TextButton(
                onPressed: () {
                  // Abrir términos
                },
                child: const Text('Leer términos'),
              ),
              value: _acceptedTerms,
              onChanged: (value) => setState(() => _acceptedTerms = value ?? false),
            ),
            
            const Divider(),
            
            // Consentimientos individuales
            CheckboxListTile(
              title: const Text('Ubicación'),
              subtitle: const Text(
                'Usamos tu ubicación para mostrarte eventos cercanos',
              ),
              value: _consentLocation,
              onChanged: (value) => setState(() => _consentLocation = value ?? false),
            ),
            
            CheckboxListTile(
              title: const Text('Notificaciones'),
              subtitle: const Text(
                'Te enviamos notificaciones sobre eventos que te interesan',
              ),
              value: _consentNotifications,
              onChanged: (value) => setState(() => _consentNotifications = value ?? false),
            ),
            
            CheckboxListTile(
              title: const Text('Perfil y favoritos'),
              subtitle: const Text(
                'Guardamos tus favoritos y preferencias',
              ),
              value: _consentProfile,
              onChanged: (value) => setState(() => _consentProfile = value ?? false),
            ),
            
            CheckboxListTile(
              title: const Text('Analytics'),
              subtitle: const Text(
                'Recopilamos datos de uso para mejorar la app',
              ),
              value: _consentAnalytics,
              onChanged: (value) => setState(() => _consentAnalytics = value ?? false),
            ),
            
            const SizedBox(height: 24),
            
            ElevatedButton(
              onPressed: _acceptedTerms ? _saveConsent : null,
              child: const Text('Guardar y continuar'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 5. 📄 Enlaces a Documentos Legales

### Añadir en ProfileScreen

```dart
// En lib/ui/auth/profile_screen.dart

const Divider(),

ListTile(
  leading: const Icon(Icons.privacy_tip),
  title: const Text('Política de Privacidad'),
  onTap: () => _openPrivacyPolicy(),
),

ListTile(
  leading: const Icon(Icons.description),
  title: const Text('Términos y Condiciones'),
  onTap: () => _openTerms(),
),

ListTile(
  leading: const Icon(Icons.info),
  title: const Text('Sobre QuePlan'),
  onTap: () => _openAbout(),
),

Future<void> _openPrivacyPolicy() async {
  // Abrir URL en navegador
  final url = Uri.parse('https://queplan.app/privacy'); // Tu URL
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}

Future<void> _openTerms() async {
  final url = Uri.parse('https://queplan.app/terms'); // Tu URL
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}
```

---

## 📝 NOTAS IMPORTANTES

1. **Service Role Key**: Para eliminar cuentas completamente, necesitarás usar la Service Role Key de Supabase (nunca en el cliente). Considera crear una Edge Function.

2. **URLs de Documentos**: Asegúrate de tener las URLs públicas antes de implementar los enlaces.

3. **Testing**: Prueba todas las funcionalidades antes de publicar.

4. **Backups**: Antes de eliminar cuentas, considera un período de gracia (30 días) para recuperación.

---

**Última actualización**: Diciembre 2024

