// lib/ui/legal/about_screen.dart
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/url_helper.dart';
import '../../l10n/app_localizations.dart';
import 'gdpr_consent_screen.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _appVersion = '1.0.0';
  String _buildNumber = '1';

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _appVersion = packageInfo.version;
          _buildNumber = packageInfo.buildNumber;
        });
      }
    } catch (e) {
      // Si falla, usar valores por defecto
    }
  }

  Future<void> _openUrl(String url) async {
    await UrlHelper.launchUrlSafely(
      context,
      url,
      errorMessage: 'No se pudo abrir el enlace',
    );
  }
  
  // Método legacy mantenido por compatibilidad (ya no se usa)
  Future<void> _openUrlLegacy(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el enlace')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // URLs de documentos legales
    const privacyPolicyUrl = 'https://queplan-app.com/privacy';
    const termsUrl = 'https://queplan-app.com/terms';
    const contactEmail = 'info@queplan-app.com';

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.aboutQuePlan ?? 'Sobre QuePlan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Logo y nombre
          Center(
            child: Column(
              children: [
                const Icon(
                  Icons.event,
                  size: 80,
                  color: Colors.blue,
                ),
                const SizedBox(height: 16),
                const Text(
                  'QuePlan',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Versión $_appVersion (Build $_buildNumber)',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Descripción
          const Text(
            'QuePlan es una aplicación para descubrir y compartir eventos en tu zona. Encuentra los mejores planes cerca de ti.',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          // Información de contacto
          Card(
            child: ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Contacto'),
              subtitle: Text(contactEmail),
              onTap: () {
                final uri = Uri.parse('mailto:$contactEmail');
                launchUrl(uri);
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Documentos legales
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: Text(AppLocalizations.of(context)?.privacyPolicy ?? 'Política de Privacidad'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _openUrl(privacyPolicyUrl),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description),
                  title: Text(AppLocalizations.of(context)?.termsAndConditions ?? 'Términos y Condiciones'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _openUrl(termsUrl),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Gestión de datos
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: Text(AppLocalizations.of(context)?.manageConsents ?? 'Gestionar consentimientos'),
                  subtitle: Text(AppLocalizations.of(context)?.modifyPrivacyPreferences ?? 'Modificar tus preferencias de privacidad'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const GDPRConsentScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Copyright
          Center(
            child: Text(
              '© ${DateTime.now().year} QuePlan',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          Center(
            child: Text(
              'Todos los derechos reservados',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

