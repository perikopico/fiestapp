import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import '../dashboard/dashboard_screen.dart';
import '../../providers/dashboard_provider.dart';

class SplashVideoScreen extends StatefulWidget {
  final Widget nextScreen;
  final bool isDashboard;
  
  const SplashVideoScreen({
    super.key,
    required this.nextScreen,
    this.isDashboard = false,
  });

  @override
  State<SplashVideoScreen> createState() => _SplashVideoScreenState();
}

class _SplashVideoScreenState extends State<SplashVideoScreen> with SingleTickerProviderStateMixin {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  Timer? _timer;
  bool _hasNavigated = false;
  late AnimationController _zoomController;
  late Animation<double> _zoomAnimation;
  bool _isZooming = false;
  bool _isNextScreenReady = false;
  Map<String, dynamic>? _preloadedData;
  bool _isPreloading = false;

  @override
  void initState() {
    super.initState();
    // Inicializar animación de zoom
    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _zoomAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _zoomController,
        curve: Curves.easeOut,
      ),
    );
    
    // Pre-cargar la siguiente pantalla en background
    _preloadNextScreen();
    _initializeVideo();
  }

  /// Pre-carga la siguiente pantalla para que esté lista cuando termine el video
  Future<void> _preloadNextScreen() async {
    if (_isPreloading) return;
    _isPreloading = true;
    
    // Si es el dashboard, pre-cargar sus datos
    if (widget.isDashboard) {
      try {
        _preloadedData = await DashboardScreen.preloadData();
        if (mounted) {
          setState(() {
            _isNextScreenReady = true;
          });
        }
      } catch (e) {
        debugPrint('Error al pre-cargar dashboard: $e');
        if (mounted) {
          setState(() {
            _isNextScreenReady = true;
          });
        }
      }
    } else {
      // Para otras pantallas, solo marcar como lista
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        setState(() {
          _isNextScreenReady = true;
        });
      }
    }
  }

  Future<void> _initializeVideo() async {
    try {
      // Inicializar el controlador de video
      // NOTA: Debes colocar tu video en assets/videos/splash.mp4
      _controller = VideoPlayerController.asset('assets/videos/splash.mp4');
      
      await _controller!.initialize();
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        
        // No reproducir en bucle, solo una vez
        _controller!.setLooping(false);
        
        // Silenciar el video (volumen a 0)
        _controller!.setVolume(0.0);
        
        // Escuchar cuando el video termine
        _controller!.addListener(_videoListener);
        
        // Reproducir el video
        _controller!.play();
        
        // Si el video dura menos de 4 segundos, esperar al menos 4 segundos
        final videoDuration = _controller!.value.duration;
        if (videoDuration < const Duration(seconds: 4)) {
          _timer = Timer(const Duration(seconds: 4), () {
            _navigateToNext();
          });
        }
        // Si el video dura 4 segundos o más, el listener se encargará de navegar cuando termine
      }
    } catch (e) {
      debugPrint('Error al inicializar el video: $e');
      // Si hay un error, navegar inmediatamente después de un breve delay
      _timer = Timer(const Duration(milliseconds: 500), () {
        _navigateToNext();
      });
    }
  }

  void _videoListener() {
    if (_controller == null) return;
    
    final position = _controller!.value.position;
    final duration = _controller!.value.duration;
    
    // Iniciar zoom cuando queden 0.8 segundos del video
    if (!_isZooming && 
        duration > Duration.zero && 
        position >= duration - const Duration(milliseconds: 800) &&
        position < duration - const Duration(milliseconds: 100)) {
      _startZoom();
    }
    
    // Si el video terminó y aún no hemos navegado, navegar ahora
    if (!_hasNavigated &&
        position >= duration &&
        duration > Duration.zero) {
      _timer?.cancel(); // Cancelar el timer si existe
      _navigateToNext();
    }
  }

  /// Inicia el efecto de zoom al final del video
  void _startZoom() {
    if (!mounted || _isZooming) return;
    
    setState(() {
      _isZooming = true;
    });
    
    _zoomController.forward();
  }

  void _navigateToNext() async {
    if (!mounted || _hasNavigated) return;
    
    _hasNavigated = true;
    _timer?.cancel();
    _controller?.removeListener(_videoListener);
    _controller?.pause();
    
    // Esperar un momento para que el zoom se complete si no se ha iniciado
    if (!_isZooming) {
      _startZoom();
      await Future.delayed(const Duration(milliseconds: 300));
    } else {
      // Esperar a que el zoom esté casi completo
      await Future.delayed(const Duration(milliseconds: 200));
    }
    
    if (!mounted) return;
    
    // Construir la siguiente pantalla con datos pre-cargados si están disponibles
    final nextScreen = widget.isDashboard && _preloadedData != null
        ? ChangeNotifierProvider.value(
            value: Provider.of<DashboardProvider>(context, listen: false),
            child: DashboardScreen(preloadedData: _preloadedData),
          )
        : widget.nextScreen;
    
    // Transición suave con fade continuando el zoom
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
        transitionDuration: const Duration(milliseconds: 600),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Curva suave para la animación
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          );
          
          // Combinar fade con ligera escala para continuar el efecto de zoom
          return FadeTransition(
            opacity: curvedAnimation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1.0).animate(curvedAnimation),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    _zoomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isInitialized && _controller != null
          ? AnimatedBuilder(
              animation: _zoomAnimation,
              builder: (context, child) {
                return SizedBox.expand(
                  child: Transform.scale(
                    scale: _zoomAnimation.value,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller!.value.size.width,
                        height: _controller!.value.size.height,
                        child: VideoPlayer(_controller!),
                      ),
                    ),
                  ),
                );
              },
            )
          : Container(color: Colors.black), // Fondo negro sin ruleta de carga
    );
  }
}
