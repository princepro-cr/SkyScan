import 'dart:math';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────
// SUN ANIMATION
// ─────────────────────────────────────────
class SunAnimation extends StatefulWidget {
  const SunAnimation({super.key});
  @override
  State<SunAnimation> createState() => _SunAnimationState();
}

class _SunAnimationState extends State<SunAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: size,
          painter: _SunPainter(_controller.value),
        );
      },
    );
  }
}

class _SunPainter extends CustomPainter {
  final double t;
  _SunPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width * 0.72;
    final cy = size.height * 0.13;

    // Outer atmospheric glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFD54F).withOpacity(0.18),
          const Color(0xFFFFB300).withOpacity(0.07),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(
          center: Offset(cx, cy), radius: 160));
    canvas.drawCircle(Offset(cx, cy), 160, glowPaint);

    // Mid glow
    final midGlow = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFF176).withOpacity(0.4),
          const Color(0xFFFFD54F).withOpacity(0.15),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(
          center: Offset(cx, cy), radius: 90));
    canvas.drawCircle(Offset(cx, cy), 90, midGlow);

    // Rotating rays
    final rayPaint = Paint()
      ..color = const Color(0xFFFFF9C4).withOpacity(0.35)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final angle = t * 2 * pi;
    const rayCount = 12;
    const innerR = 52.0;
    const outerR = 80.0;

    for (int i = 0; i < rayCount; i++) {
      final a = angle + (i * 2 * pi / rayCount);
      canvas.drawLine(
        Offset(cx + cos(a) * innerR, cy + sin(a) * innerR),
        Offset(cx + cos(a) * outerR, cy + sin(a) * outerR),
        rayPaint,
      );
    }

    // Sun core
    final corePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFFDE7),
          const Color(0xFFFFEB3B),
          const Color(0xFFFFC107),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(
          Rect.fromCircle(center: Offset(cx, cy), radius: 46));
    canvas.drawCircle(Offset(cx, cy), 46, corePaint);
  }

  @override
  bool shouldRepaint(_SunPainter old) => old.t != t;
}

// ─────────────────────────────────────────
// STARS + MOON ANIMATION (Night)
// ─────────────────────────────────────────
class StarsAnimation extends StatefulWidget {
  const StarsAnimation({super.key});
  @override
  State<StarsAnimation> createState() => _StarsAnimationState();
}

class _StarData {
  final double x, y, size, phase;
  _StarData(this.x, this.y, this.size, this.phase);
}

class _StarsAnimationState extends State<StarsAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_StarData> _stars;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    final rng = Random(42); // fixed seed = stable positions
    _stars = List.generate(90, (_) => _StarData(
          rng.nextDouble(),
          rng.nextDouble() * 0.65, // top 65% of screen
          0.8 + rng.nextDouble() * 2.2,
          rng.nextDouble() * 2 * pi,
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => CustomPaint(
        size: size,
        painter: _StarsMoonPainter(_stars, _controller.value),
      ),
    );
  }
}

class _StarsMoonPainter extends CustomPainter {
  final List<_StarData> stars;
  final double t;
  _StarsMoonPainter(this.stars, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Stars
    for (final s in stars) {
      final twinkle = (sin(t * 2 * pi + s.phase) + 1) / 2;
      final opacity = 0.25 + 0.75 * twinkle;
      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(
        Offset(s.x * size.width, s.y * size.height),
        s.size,
        paint,
      );
    }

    // Crescent moon
    final mx = size.width * 0.76;
    final my = size.height * 0.11;
    const mr = 34.0;

    // Moon body
    final moonPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFF8E1),
          const Color(0xFFFFECB3),
        ],
      ).createShader(Rect.fromCircle(center: Offset(mx, my), radius: mr));
    canvas.drawCircle(Offset(mx, my), mr, moonPaint);

    // Crescent cutout — slightly offset circle in bg color
    final cutPaint = Paint()
      ..color = const Color(0xFF0a0a1a) // matches clear night top color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(mx + 20, my - 8), mr * 0.88, cutPaint);

    // Soft moon glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFECB3).withOpacity(0.15),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset(mx, my), radius: 70));
    canvas.drawCircle(Offset(mx, my), 70, glowPaint);
  }

  @override
  bool shouldRepaint(_StarsMoonPainter old) => old.t != t;
}

// ─────────────────────────────────────────
// CLOUDS ANIMATION
// ─────────────────────────────────────────
class CloudsAnimation extends StatefulWidget {
  const CloudsAnimation({super.key});
  @override
  State<CloudsAnimation> createState() => _CloudsAnimationState();
}

class _CloudData {
  double x; // 0..1 normalized
  final double y;
  final double scale;
  final double opacity;
  final double speed; // normalized units/sec
  _CloudData(this.x, this.y, this.scale, this.opacity, this.speed);
}

class _CloudsAnimationState extends State<CloudsAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_CloudData> _clouds;
  double _lastT = 0;

  @override
  void initState() {
    super.initState();
    final rng = Random(7);
    _clouds = [
      _CloudData(0.1, 0.08, 1.4, 0.75, 0.012),
      _CloudData(0.55, 0.15, 1.0, 0.5, 0.008),
      _CloudData(0.8, 0.06, 1.2, 0.65, 0.015),
      _CloudData(0.3, 0.22, 0.85, 0.4, 0.006),
      _CloudData(0.65, 0.28, 1.1, 0.55, 0.01),
    ];
    // suppress unused warning
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final dt = _controller.value - _lastT;
        final dtClamped = dt.abs() > 0.5 ? 0.0 : dt;
        _lastT = _controller.value;

        for (final c in _clouds) {
          c.x += c.speed * dtClamped;
          if (c.x > 1.3) c.x = -0.4;
        }

        return CustomPaint(
          size: size,
          painter: _CloudsPainter(_clouds),
        );
      },
    );
  }
}

class _CloudsPainter extends CustomPainter {
  final List<_CloudData> clouds;
  _CloudsPainter(this.clouds);

  @override
  void paint(Canvas canvas, Size size) {
    for (final c in clouds) {
      _drawCloud(
        canvas,
        Offset(c.x * size.width, c.y * size.height),
        c.scale * size.width * 0.38,
        c.opacity,
      );
    }
  }

  void _drawCloud(Canvas canvas, Offset center, double w, double opacity) {
    final h = w * 0.42;
    final paint = Paint()
      ..color = Colors.white.withOpacity(opacity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    // Build cloud from overlapping ellipses
    final rects = [
      Rect.fromCenter(center: center, width: w, height: h),
      Rect.fromCenter(
          center: center.translate(-w * 0.28, -h * 0.3),
          width: w * 0.55,
          height: h * 0.75),
      Rect.fromCenter(
          center: center.translate(w * 0.2, -h * 0.25),
          width: w * 0.48,
          height: h * 0.7),
      Rect.fromCenter(
          center: center.translate(-w * 0.05, -h * 0.38),
          width: w * 0.38,
          height: h * 0.65),
    ];

    for (final r in rects) {
      canvas.drawOval(r, paint);
    }
  }

  @override
  bool shouldRepaint(_CloudsPainter old) => true;
}

// ─────────────────────────────────────────
// RAIN ANIMATION
// ─────────────────────────────────────────
class _Drop {
  double x, y;
  final double speed, length, opacity;
  _Drop(this.x, this.y, this.speed, this.length, this.opacity);
}

class RainAnimation extends StatefulWidget {
  final int dropCount;
  final double opacity;
  const RainAnimation({super.key, this.dropCount = 70, this.opacity = 1.0});
  @override
  State<RainAnimation> createState() => _RainAnimationState();
}

class _RainAnimationState extends State<RainAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Drop> _drops;
  final _rng = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 16),
      vsync: this,
    )..repeat();
    _drops = List.generate(widget.dropCount, (_) => _Drop(
          _rng.nextDouble() * 400,
          _rng.nextDouble() * 900,
          8 + _rng.nextDouble() * 10,
          12 + _rng.nextDouble() * 18,
          0.15 + _rng.nextDouble() * 0.35,
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        for (final d in _drops) {
          d.y += d.speed;
          d.x -= d.speed * 0.15; // slight left slant
          if (d.y > size.height) {
            d.y = -d.length;
            d.x = _rng.nextDouble() * size.width;
          }
          if (d.x < 0) d.x = size.width.toDouble();
        }
        return CustomPaint(
          size: size,
          painter: _RainPainter(_drops, widget.opacity),
        );
      },
    );
  }
}

class _RainPainter extends CustomPainter {
  final List<_Drop> drops;
  final double opacity;
  _RainPainter(this.drops, this.opacity);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.2;

    for (final d in drops) {
      paint.color = Colors.white.withOpacity(d.opacity * opacity);
      canvas.drawLine(
        Offset(d.x, d.y),
        Offset(d.x + d.length * 0.15, d.y + d.length),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_RainPainter old) => true;
}

// ─────────────────────────────────────────
// SNOW ANIMATION
// ─────────────────────────────────────────
class _Flake {
  double x, y;
  final double speed, size, phase;
  _Flake(this.x, this.y, this.speed, this.size, this.phase);
}

class SnowAnimation extends StatefulWidget {
  const SnowAnimation({super.key});
  @override
  State<SnowAnimation> createState() => _SnowAnimationState();
}

class _SnowAnimationState extends State<SnowAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Flake> _flakes;
  final _rng = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 16),
      vsync: this,
    )..repeat();
    _flakes = List.generate(55, (i) => _Flake(
          _rng.nextDouble() * 400,
          _rng.nextDouble() * 900,
          0.6 + _rng.nextDouble() * 1.6,
          1.5 + _rng.nextDouble() * 3.5,
          _rng.nextDouble() * 2 * pi,
        ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _t = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        _t += 0.01;
        for (final f in _flakes) {
          f.y += f.speed;
          f.x += sin(_t + f.phase) * 0.4;
          if (f.y > size.height) {
            f.y = -f.size;
            f.x = _rng.nextDouble() * size.width;
          }
        }
        return CustomPaint(
          size: size,
          painter: _SnowPainter(_flakes),
        );
      },
    );
  }
}

class _SnowPainter extends CustomPainter {
  final List<_Flake> flakes;
  _SnowPainter(this.flakes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (final f in flakes) {
      // Larger flakes = closer = more opaque
      final opacity = 0.4 + (f.size / 5.0) * 0.5;
      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(Offset(f.x, f.y), f.size, paint);
    }
  }

  @override
  bool shouldRepaint(_SnowPainter old) => true;
}

// ─────────────────────────────────────────
// THUNDERSTORM ANIMATION
// ─────────────────────────────────────────
class ThunderstormAnimation extends StatefulWidget {
  const ThunderstormAnimation({super.key});
  @override
  State<ThunderstormAnimation> createState() => _ThunderstormAnimationState();
}

class _ThunderstormAnimationState extends State<ThunderstormAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _lightningController;
  final _rng = Random();
  double _boltX = 0.5;

  @override
  void initState() {
    super.initState();
    _lightningController = AnimationController(
      duration: const Duration(milliseconds: 180),
      vsync: this,
    );
    _scheduleLightning();
  }

  void _scheduleLightning() async {
    while (mounted) {
      await Future.delayed(Duration(seconds: 3 + _rng.nextInt(6)));
      if (!mounted) break;
      _boltX = 0.2 + _rng.nextDouble() * 0.6;
      await _lightningController.forward(from: 0);
      await _lightningController.reverse();
    }
  }

  @override
  void dispose() {
    _lightningController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        // Heavy rain for storm
        const RainAnimation(dropCount: 110, opacity: 0.85),
        // Flash overlay
        AnimatedBuilder(
          animation: _lightningController,
          builder: (_, __) => Container(
            color: Colors.white
                .withOpacity(_lightningController.value * 0.22),
          ),
        ),
        // Bolt
        AnimatedBuilder(
          animation: _lightningController,
          builder: (_, __) => _lightningController.value > 0.1
              ? CustomPaint(
                  size: size,
                  painter: _BoltPainter(
                      _boltX, _lightningController.value),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _BoltPainter extends CustomPainter {
  final double boltX;
  final double intensity;
  _BoltPainter(this.boltX, this.intensity);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color =
          const Color(0xFFFFF9C4).withOpacity(intensity * 0.9)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final startX = boltX * size.width;
    final path = Path()..moveTo(startX, 0);

    // Jagged bolt segments
    final segments = [
      Offset(startX - 12, size.height * 0.18),
      Offset(startX + 18, size.height * 0.32),
      Offset(startX - 8, size.height * 0.46),
      Offset(startX + 14, size.height * 0.58),
      Offset(startX - 6, size.height * 0.68),
    ];

    for (final s in segments) {
      path.lineTo(s.dx, s.dy);
    }

    // Glow
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFFFF9C4).withOpacity(intensity * 0.25)
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BoltPainter old) =>
      old.intensity != intensity || old.boltX != boltX;
}

// ─────────────────────────────────────────
// MIST ANIMATION
// ─────────────────────────────────────────
class _MistBand {
  double x; // normalized offset
  final double y, height, opacity, speed;
  _MistBand(this.x, this.y, this.height, this.opacity, this.speed);
}

class MistAnimation extends StatefulWidget {
  const MistAnimation({super.key});
  @override
  State<MistAnimation> createState() => _MistAnimationState();
}

class _MistAnimationState extends State<MistAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _lastT = 0;

  final _bands = [
    _MistBand(0.0, 0.25, 0.14, 0.12, 0.004),
    _MistBand(0.3, 0.42, 0.12, 0.09, -0.003),
    _MistBand(0.6, 0.58, 0.16, 0.13, 0.005),
    _MistBand(0.1, 0.70, 0.10, 0.08, -0.004),
    _MistBand(0.8, 0.82, 0.13, 0.10, 0.003),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final dt = (_controller.value - _lastT).abs() > 0.5
            ? 0.0
            : _controller.value - _lastT;
        _lastT = _controller.value;

        for (final b in _bands) {
          b.x += b.speed * dt;
          if (b.x > 1.5) b.x = -0.6;
          if (b.x < -0.6) b.x = 1.5;
        }

        return CustomPaint(
          size: size,
          painter: _MistPainter(_bands),
        );
      },
    );
  }
}

class _MistPainter extends CustomPainter {
  final List<_MistBand> bands;
  _MistPainter(this.bands);

  @override
  void paint(Canvas canvas, Size size) {
    for (final b in bands) {
      final y = b.y * size.height;
      final h = b.height * size.height;
      final rect = Rect.fromLTWH(b.x * size.width - size.width * 0.1,
          y - h / 2, size.width * 1.2, h);

      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.white.withOpacity(0),
            Colors.white.withOpacity(b.opacity),
            Colors.white.withOpacity(b.opacity * 0.7),
            Colors.white.withOpacity(0),
          ],
          stops: const [0.0, 0.3, 0.7, 1.0],
        ).createShader(rect)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, h * 0.4);

      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(_MistPainter old) => true;
}