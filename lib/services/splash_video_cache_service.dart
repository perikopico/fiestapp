// lib/services/splash_video_cache_service.dart
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'logger_service.dart';

/// Origen del video de splash: asset, archivo local o URL remota.
enum SplashVideoSourceKind { asset, file, network }

/// Resultado de [SplashVideoCacheService.getVideoSource].
/// Indica si usar asset, file local o URL de red.
class SplashVideoSource {
  final SplashVideoSourceKind kind;
  final String? assetPath;
  final File? file;
  final String? networkUrl;

  const SplashVideoSource._({
    required this.kind,
    this.assetPath,
    this.file,
    this.networkUrl,
  });

  factory SplashVideoSource.asset(String path) =>
      SplashVideoSource._(kind: SplashVideoSourceKind.asset, assetPath: path);

  factory SplashVideoSource.file(File f) =>
      SplashVideoSource._(kind: SplashVideoSourceKind.file, file: f);

  factory SplashVideoSource.network(String url) =>
      SplashVideoSource._(kind: SplashVideoSourceKind.network, networkUrl: url);
}

/// Caché inteligente y rotativa para el video de introducción (splash).
///
/// Videos en Supabase Storage: `video_1.mp4` (Enero) … `video_12.mp4` (Diciembre).
/// Nomenclatura humana 1–12; [DateTime.month] ya es 1–12. Si existe local → file (instantáneo);
/// si no → network + descarga en background y borrado del mes anterior.
///
/// Env: [SUPABASE_URL] obligatorio. Opcional: [SPLASH_VIDEO_BUCKET] (default `splash-videos`).
class SplashVideoCacheService {
  SplashVideoCacheService._();
  static final SplashVideoCacheService instance = SplashVideoCacheService._();

  static const String _defaultBucket = 'splash-videos';
  static String get _bucket => dotenv.env['SPLASH_VIDEO_BUCKET']?.trim().isNotEmpty == true
      ? dotenv.env['SPLASH_VIDEO_BUCKET']!.trim()
      : _defaultBucket;
  static const String _assetFallback = 'assets/videos/splash.mp4';

  /// Índice del mes actual en nomenclatura humana (1–12).
  /// Dart: [DateTime.month] ya es 1–12; en JS sería getMonth() + 1.
  int get _currentMonthIndex {
    final m = DateTime.now().month;
    return m.clamp(1, 12);
  }

  /// Índice del mes anterior (1–12). Si actual es 1 (Enero) → 12 (Diciembre).
  int _previousMonthIndex(int current) {
    return current == 1 ? 12 : current - 1;
  }

  /// Nombre de archivo para el mes: video_1.mp4 … video_12.mp4.
  String _fileName(int monthIndex) => 'video_$monthIndex.mp4';

  /// Directorio local para videos en caché.
  Future<Directory> _cacheDir() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory('${base.path}/splash_videos');
    if (!dir.existsSync()) await dir.create(recursive: true);
    return dir;
  }

  /// Ruta absoluta del archivo local para un mes.
  Future<File> _localFile(int monthIndex) async {
    final dir = await _cacheDir();
    return File('${dir.path}/${_fileName(monthIndex)}');
  }

  /// Comprueba si el video del mes existe localmente.
  Future<bool> _existsLocal(int monthIndex) async {
    final f = await _localFile(monthIndex);
    return f.existsSync();
  }

  /// URL pública de Supabase Storage para un archivo del bucket.
  String _remoteUrl(String fileName) {
    final base = dotenv.env['SUPABASE_URL']?.trim();
    if (base == null || base.isEmpty) return '';
    final b = base.endsWith('/') ? base : '$base/';
    return '${b}storage/v1/object/public/$_bucket/$fileName';
  }

  /// Obtiene la fuente del video (asset / file / network) y dispara descarga + limpieza en background.
  Future<SplashVideoSource> getVideoSource() async {
    final current = _currentMonthIndex;
    final previous = _previousMonthIndex(current);
    final fileName = _fileName(current);
    final remoteUrl = _remoteUrl(fileName);

    if (remoteUrl.isEmpty) {
      LoggerService.instance.warning('SplashVideoCache: SUPABASE_URL no configurado, usando asset');
      return SplashVideoSource.asset(_assetFallback);
    }

    final exists = await _existsLocal(current);

    if (exists) {
      // ESCENARIO A: existe local → reproducir y listo. No descargar ni limpiar de nuevo.
      final f = await _localFile(current);
      LoggerService.instance.debug('SplashVideoCache: usando caché local', data: {'file': f.path});
      return SplashVideoSource.file(f);
    }

    // ESCENARIO B: no existe → streaming remoto + descarga y limpieza en background
    LoggerService.instance.debug('SplashVideoCache: streaming remoto', data: {'url': remoteUrl});
    _scheduleBackgroundDownloadAndCleanup(current, previous, remoteUrl);
    return SplashVideoSource.network(remoteUrl);
  }

  /// En background: descarga video actual y borra el del mes anterior.
  void _scheduleBackgroundDownloadAndCleanup(int current, int previous, String remoteUrl) {
    Future(() async {
      try {
        await _downloadToLocal(current, remoteUrl);
        await _deleteIfExists(previous);
      } catch (e) {
        LoggerService.instance.warning('SplashVideoCache: error en background', data: {'error': e.toString()});
      }
    });
  }

  /// Descarga el video del mes a almacenamiento local.
  Future<void> _downloadToLocal(int monthIndex, String url) async {
    final res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}');
    }
    final f = await _localFile(monthIndex);
    await f.writeAsBytes(res.bodyBytes);
    LoggerService.instance.info('SplashVideoCache: descargado', data: {'file': _fileName(monthIndex)});
  }

  /// Borra el video del mes anterior si existe.
  Future<void> _deleteIfExists(int monthIndex) async {
    final f = await _localFile(monthIndex);
    if (f.existsSync()) {
      await f.delete();
      LoggerService.instance.debug('SplashVideoCache: limpieza', data: {'file': _fileName(monthIndex)});
    }
  }
}
