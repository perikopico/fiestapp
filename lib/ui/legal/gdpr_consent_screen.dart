// lib/ui/legal/gdpr_consent_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/url_helper.dart';
import '../../services/gdpr_consent_service.dart';
import '../../l10n/app_localizations.dart';
import '../common/app_bar_logo.dart';

class GDPRConsentScreen extends StatefulWidget {
  final bool isFirstTime;
  
  const GDPRConsentScreen({
    super.key,
    this.isFirstTime = false,
  });

  @override
  State<GDPRConsentScreen> createState() => _GDPRConsentScreenState();
}

class _GDPRConsentScreenState extends State<GDPRConsentScreen> {
  final _consentService = GDPRConsentService.instance;
  
  bool _consentLocation = false;
  bool _consentNotifications = false;
  bool _consentProfile = false;
  bool _consentAnalytics = false;
  bool _acceptedTerms = false;
  bool _acceptedPrivacyPolicy = false;
  bool _isLoading = false;

  // URLs de documentos legales
  static const String privacyPolicyUrl = 'https://queplan-app.com/privacy';
  static const String termsUrl = 'https://queplan-app.com/terms';

  @override
  void initState() {
    super.initState();
    _loadExistingConsents();
  }

  Future<void> _loadExistingConsents() async {
    final consents = await _consentService.getConsents();
    if (consents != null && mounted) {
      setState(() {
        _consentLocation = consents['consent_location'] ?? false;
        _consentNotifications = consents['consent_notifications'] ?? false;
        _consentProfile = consents['consent_profile'] ?? false;
        _consentAnalytics = consents['consent_analytics'] ?? false;
        _acceptedTerms = consents['accepted_terms'] ?? false;
        _acceptedPrivacyPolicy = consents['accepted_privacy_policy'] ?? false;
      });
    }
  }

  Future<void> _saveConsents() async {
    if (!_acceptedTerms || !_acceptedPrivacyPolicy) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)?.mustAcceptTerms ?? 'Debes aceptar los Términos y la Política de Privacidad para continuar'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _consentService.saveConsents(
        consentLocation: _consentLocation,
        consentNotifications: _consentNotifications,
        consentProfile: _consentProfile,
        consentAnalytics: _consentAnalytics,
        acceptedTerms: _acceptedTerms,
        acceptedPrivacyPolicy: _acceptedPrivacyPolicy,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)?.consentsSaved ?? 'Consentimientos guardados correctamente'),
          backgroundColor: Colors.green,
        ),
      );

      if (widget.isFirstTime) {
        Navigator.of(context).pop(true);
      } else {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)?.errorSaving(e.toString()) ?? 'Error al guardar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _openUrl(String url) async {
    await UrlHelper.launchUrlSafely(
      context,
      url,
      errorMessage: 'No se pudo abrir el enlace',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarLogo(),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: !widget.isFirstTime,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                    'Para usar QuePlan, necesitamos tu consentimiento para procesar tus datos personales según el RGPD (Reglamento General de Protección de Datos).',
                  ),
                  const SizedBox(height: 24),
                  
                  // Términos y condiciones
                  Card(
                    child: CheckboxListTile(
                      title: Text(AppLocalizations.of(context)?.acceptTerms ?? 'Acepto los Términos y Condiciones'),
                      subtitle: TextButton(
                        onPressed: () => _openUrl(termsUrl),
                        child: Text(AppLocalizations.of(context)?.readTerms ?? 'Leer términos'),
                      ),
                      value: _acceptedTerms,
                      onChanged: (value) => setState(() => _acceptedTerms = value ?? false),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Política de privacidad
                  Card(
                    child: CheckboxListTile(
                      title: Text(AppLocalizations.of(context)?.acceptPrivacy ?? 'Acepto la Política de Privacidad'),
                      subtitle: TextButton(
                        onPressed: () => _openUrl(privacyPolicyUrl),
                        child: Text(AppLocalizations.of(context)?.readPrivacy ?? 'Leer política de privacidad'),
                      ),
                      value: _acceptedPrivacyPolicy,
                      onChanged: (value) => setState(() => _acceptedPrivacyPolicy = value ?? false),
                    ),
                  ),
                  
                  const Divider(height: 32),
                  
                  const Text(
                    'Consentimientos Opcionales',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Puedes personalizar qué datos quieres compartir con nosotros:',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Consentimientos individuales
                  Card(
                    child: CheckboxListTile(
                      title: Text(AppLocalizations.of(context)?.location ?? 'Ubicación'),
                      subtitle: const Text(
                        'Usamos tu ubicación para mostrarte eventos cercanos y ordenar resultados por distancia.',
                      ),
                      value: _consentLocation,
                      onChanged: (value) => setState(() => _consentLocation = value ?? false),
                    ),
                  ),
                  
                  Card(
                    child: CheckboxListTile(
                      title: Text(AppLocalizations.of(context)?.notifications ?? 'Notificaciones'),
                      subtitle: const Text(
                        'Te enviamos notificaciones sobre eventos que te interesan según tus preferencias.',
                      ),
                      value: _consentNotifications,
                      onChanged: (value) => setState(() => _consentNotifications = value ?? false),
                    ),
                  ),
                  
                  Card(
                    child: CheckboxListTile(
                      title: const Text('Perfil y favoritos'),
                      subtitle: const Text(
                        'Guardamos tus favoritos, eventos creados y preferencias para mejorar tu experiencia.',
                      ),
                      value: _consentProfile,
                      onChanged: (value) => setState(() => _consentProfile = value ?? false),
                    ),
                  ),
                  
                  Card(
                    child: CheckboxListTile(
                      title: Text(AppLocalizations.of(context)?.analytics ?? 'Analytics'),
                      subtitle: const Text(
                        'Recopilamos datos de uso anónimos para mejorar la app y entender cómo la usas.',
                      ),
                      value: _consentAnalytics,
                      onChanged: (value) => setState(() => _consentAnalytics = value ?? false),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _saveConsents,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Guardar y continuar'),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _consentLocation = true;
                        _consentNotifications = true;
                        _consentProfile = true;
                        _consentAnalytics = true;
                      });
                    },
                    child: Text(AppLocalizations.of(context)?.acceptAll ?? 'Aceptar todo'),
                  ),
                ],
              ),
            ),
    );
  }
}

