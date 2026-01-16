import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SplashVideoScreen extends StatefulWidget {
  final Widget nextScreen;
  
  const SplashVideoScreen({
    super.key,
    required this.nextScreen,
  });

  @override
  State<SplashVideoScreen> createState() => _SplashVideoScreenState();
}

class _SplashVideoScreenState extends State<SplashVideoScreen> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  Timer? _timer;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
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
        
        // Si el video dura menos de 5 segundos, esperar al menos 5 segundos
        final videoDuration = _controller!.value.duration;
        if (videoDuration < const Duration(seconds: 5)) {
          _timer = Timer(const Duration(seconds: 5), () {
            _navigateToNext();
          });
        }
        // Si el video dura 5 segundos o más, el listener se encargará de navegar cuando termine
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
    // Si el video terminó y aún no hemos navegado, navegar ahora
    if (_controller != null && 
        !_hasNavigated &&
        _controller!.value.position >= _controller!.value.duration &&
        _controller!.value.duration > Duration.zero) {
      _timer?.cancel(); // Cancelar el timer si existe
      _navigateToNext();
    }
  }

  void _navigateToNext() {
    if (!mounted || _hasNavigated) return;
    
    _hasNavigated = true;
    _timer?.cancel();
    _controller?.removeListener(_videoListener);
    _controller?.pause();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => widget.nextScreen,
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _isInitialized && _controller != null
            ? AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              )
            : Container(), // Fondo negro sin ruleta de carga
      ),
    );
  }
}
