import 'dart:math';
import 'package:flutter/material.dart';

enum ParticleType { snow, rain, confetti, petals, leaves, sunbeams }

class ParticleEffects extends StatefulWidget {
  final ParticleType type;
  final Widget child;

  const ParticleEffects({
    super.key,
    required this.type,
    required this.child,
  });

  @override
  State<ParticleEffects> createState() => _ParticleEffectsState();
}

class _ParticleEffectsState extends State<ParticleEffects>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _generateParticles();
    _controller.addListener(_updateParticles);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _generateParticles() {
    _particles.clear();
    int count;
    double startY;
    
    switch (widget.type) {
      case ParticleType.confetti:
        count = 80;
        startY = 0.3; // Empezar desde el centro para explosión
        break;
      case ParticleType.rain:
        count = 100;
        startY = -0.5;
        break;
      case ParticleType.petals:
      case ParticleType.leaves:
        count = 60;
        startY = -0.3;
        break;
      case ParticleType.sunbeams:
        count = 30;
        startY = -0.2;
        break;
      default: // snow
        count = 100;
        startY = -0.5;
    }
    
    for (int i = 0; i < count; i++) {
      double speed;
      double size;
      Color color;
      double horizontalDrift = 0.0;
      double rotationSpeed = 0.0;
      
      switch (widget.type) {
        case ParticleType.confetti:
          // Explosión de confeti desde el centro
          final angle = _random.nextDouble() * 2 * pi;
          final velocity = 0.003 + _random.nextDouble() * 0.005;
          speed = velocity;
          horizontalDrift = cos(angle) * velocity * 0.5;
          size = 4.0 + _random.nextDouble() * 6.0;
          color = _getConfettiColor();
          rotationSpeed = (_random.nextDouble() - 0.5) * 0.02;
          break;
        case ParticleType.rain:
          speed = 0.01 + _random.nextDouble() * 0.02;
          size = 2.0 + _random.nextDouble() * 3.0;
          color = Colors.lightBlue.withOpacity(0.7);
          break;
        case ParticleType.petals:
          speed = 0.002 + _random.nextDouble() * 0.004;
          size = 3.0 + _random.nextDouble() * 5.0;
          color = _getPetalColor();
          horizontalDrift = (_random.nextDouble() - 0.5) * 0.001;
          rotationSpeed = (_random.nextDouble() - 0.5) * 0.01;
          break;
        case ParticleType.leaves:
          speed = 0.001 + _random.nextDouble() * 0.003;
          size = 4.0 + _random.nextDouble() * 6.0;
          color = _getLeafColor();
          horizontalDrift = (_random.nextDouble() - 0.5) * 0.0015;
          rotationSpeed = (_random.nextDouble() - 0.5) * 0.008;
          break;
        case ParticleType.sunbeams:
          speed = 0.001 + _random.nextDouble() * 0.002;
          size = 8.0 + _random.nextDouble() * 12.0;
          color = Colors.yellow.withOpacity(0.3);
          horizontalDrift = (_random.nextDouble() - 0.5) * 0.0005;
          break;
        default: // snow
          speed = 0.003 + _random.nextDouble() * 0.005;
          size = 2.0 + _random.nextDouble() * 4.0;
          color = Colors.white;
          horizontalDrift = (_random.nextDouble() - 0.5) * 0.002;
      }
      
      _particles.add(Particle(
        x: widget.type == ParticleType.confetti 
            ? 0.5 + (_random.nextDouble() - 0.5) * 0.1 // Empezar cerca del centro
            : _random.nextDouble(),
        y: widget.type == ParticleType.confetti
            ? startY + (_random.nextDouble() - 0.5) * 0.1
            : startY + _random.nextDouble() * 0.2,
        speed: speed,
        size: size,
        color: color,
        horizontalDrift: horizontalDrift,
        rotationSpeed: rotationSpeed,
      ));
    }
  }

  Color _getConfettiColor() {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.cyan,
      Colors.amber,
    ];
    return colors[_random.nextInt(colors.length)];
  }

  Color _getPetalColor() {
    final colors = [
      Colors.pink.shade200,
      Colors.pink.shade300,
      Colors.pink.shade100,
      Colors.white,
      Colors.pinkAccent.shade100,
    ];
    return colors[_random.nextInt(colors.length)];
  }

  Color _getLeafColor() {
    final colors = [
      Colors.brown.shade400,
      Colors.orange.shade600,
      Colors.orange.shade700,
      Colors.red.shade700,
      Colors.brown.shade600,
      Colors.amber.shade800,
    ];
    return colors[_random.nextInt(colors.length)];
  }

  void _updateParticles() {
    setState(() {
      for (var particle in _particles) {
        particle.y += particle.speed;
        particle.x += particle.horizontalDrift;
        
        // Rotación para pétalos y hojas
        if (widget.type == ParticleType.petals || widget.type == ParticleType.leaves) {
          particle.rotation += particle.rotationSpeed;
        }
        
        // Movimiento especial para nieve
        if (widget.type == ParticleType.snow) {
          particle.horizontalDrift += (_random.nextDouble() - 0.5) * 0.0001;
        }
        
        // Para confeti (explosión), resetear cuando sale de la pantalla
        if (widget.type == ParticleType.confetti) {
          if (particle.y > 1.2 || particle.y < -0.2 || 
              particle.x < -0.2 || particle.x > 1.2) {
            // Reiniciar desde el centro para nueva explosión
            final angle = _random.nextDouble() * 2 * pi;
            final velocity = 0.003 + _random.nextDouble() * 0.005;
            particle.speed = velocity;
            particle.horizontalDrift = cos(angle) * velocity * 0.5;
            particle.x = 0.5 + (_random.nextDouble() - 0.5) * 0.1;
            particle.y = 0.3 + (_random.nextDouble() - 0.5) * 0.1;
          }
        } else {
          // Resetear partícula cuando sale de la pantalla (otros tipos)
          if (particle.y > 1.2) {
            particle.y = -0.1;
            particle.x = _random.nextDouble();
            if (widget.type == ParticleType.petals || widget.type == ParticleType.leaves) {
              particle.horizontalDrift = (_random.nextDouble() - 0.5) * 0.0015;
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        fit: StackFit.expand,
        children: [
          widget.child,
          CustomPaint(
            painter: ParticlePainter(
              particles: _particles,
              type: widget.type,
            ),
            size: Size.infinite,
          ),
        ],
      ),
    );
  }
}

class Particle {
  double x;
  double y;
  double speed;
  double size;
  Color color;
  double horizontalDrift;
  double rotation;
  double rotationSpeed;

  Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.color,
    this.horizontalDrift = 0.0,
    this.rotation = 0.0,
    this.rotationSpeed = 0.0,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final ParticleType type;

  ParticlePainter({
    required this.particles,
    required this.type,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final x = particle.x * size.width;
      final y = particle.y * size.height;

      canvas.save();
      canvas.translate(x, y);
      
      if (type == ParticleType.petals || type == ParticleType.leaves) {
        canvas.rotate(particle.rotation);
      }

      switch (type) {
        case ParticleType.confetti:
          // Confeti como rectángulos rotados (explosión)
          final paint = Paint()
            ..color = particle.color.withOpacity(0.9)
            ..style = PaintingStyle.fill;
          final rect = RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset.zero,
              width: particle.size,
              height: particle.size * 0.6,
            ),
            const Radius.circular(2),
          );
          canvas.rotate(particle.rotation);
          canvas.drawRRect(rect, paint);
          break;
          
        case ParticleType.rain:
          // Lluvia como líneas
          final paintLine = Paint()
            ..color = particle.color.withOpacity(0.4)
            ..strokeWidth = 1.5
            ..style = PaintingStyle.stroke;
          canvas.drawLine(
            Offset.zero,
            Offset(0, particle.size * 3),
            paintLine,
          );
          break;
          
        case ParticleType.petals:
          // Pétalos como elipses
          final paint = Paint()
            ..color = particle.color.withOpacity(0.7)
            ..style = PaintingStyle.fill;
          canvas.drawOval(
            Rect.fromCenter(
              center: Offset.zero,
              width: particle.size,
              height: particle.size * 0.7,
            ),
            paint,
          );
          break;
          
        case ParticleType.leaves:
          // Hojas como elipses más grandes
          final paint = Paint()
            ..color = particle.color.withOpacity(0.8)
            ..style = PaintingStyle.fill;
          canvas.drawOval(
            Rect.fromCenter(
              center: Offset.zero,
              width: particle.size,
              height: particle.size * 0.6,
            ),
            paint,
          );
          break;
          
        case ParticleType.sunbeams:
          // Destellos de sol como líneas brillantes
          final paint = Paint()
            ..color = particle.color.withOpacity(0.4)
            ..strokeWidth = 2.0
            ..style = PaintingStyle.stroke
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
          canvas.drawLine(
            Offset(-particle.size / 2, -particle.size / 2),
            Offset(particle.size / 2, particle.size / 2),
            paint,
          );
          canvas.drawLine(
            Offset(particle.size / 2, -particle.size / 2),
            Offset(-particle.size / 2, particle.size / 2),
            paint,
          );
          break;
          
        default: // snow
          // Nieve como círculos
          final paint = Paint()
            ..color = particle.color.withOpacity(0.4)
            ..style = PaintingStyle.fill;
          canvas.drawCircle(Offset.zero, particle.size / 2, paint);
      }
      
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

