import 'package:flutter/material.dart';

void main() {
  runApp(const AgriVoiceApp());
}

class AgriVoiceApp extends StatelessWidget {
  const AgriVoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agri Voice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SpaceGrotesk',
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();

    _progressAnimation = Tween<double>(begin: 0.0, end: 0.45).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1B5E20), // Dark forest green at top
              Color(0xFF4CAF50), // Medium green at bottom
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Main centered content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ── Logo Section ──
                    _buildLogoSection(),

                    const SizedBox(height: 96),

                    // ── Loading Section ──
                    _buildLoadingSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        // Logo circle with glow
        Stack(
          alignment: Alignment.center,
          children: [
            // Glow effect
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.15),
                    blurRadius: 60,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
            // White circle with logo
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(
                  color: const Color(0xFF2F7F34).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: ClipOval(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildPlantIcon(),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // App name
        const Text(
          'Agri Voice',
          style: TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            height: 1.2,
          ),
        ),

        const SizedBox(height: 8),

        // Subtitle
        Text(
          'Sustainable Agriculture AI',
          style: TextStyle(
            color: Colors.white.withOpacity(0.70),
            fontSize: 18,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPlantIcon() {
    // SVG-style plant icon drawn with CustomPaint
    return CustomPaint(
      painter: _PlantIconPainter(),
      size: const Size(96, 96),
    );
  }

  Widget _buildLoadingSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        children: [
          // "LOADING AI MODEL..." label
          Text(
            'LOADING AI MODEL...',
            style: TextStyle(
              color: Colors.white.withOpacity(0.90),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.5,
            ),
          ),

          const SizedBox(height: 12),

          // Progress bar
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return _buildProgressBar(_progressAnimation.value);
            },
          ),

          const SizedBox(height: 24),

          // Version / footer text
          Text(
            'v2.4.0 • Secure Neural Core',
            style: TextStyle(
              color: Colors.white.withOpacity(0.40),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return Container(
      width: double.infinity,
      height: 6,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.20),
        borderRadius: BorderRadius.circular(999),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
    );
  }
}

/// Custom painter that draws a simple botanical plant illustration
/// matching the minimal plant icon seen in the splash screen logo.
class _PlantIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2D5E1E)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = const Color(0xFF2D5E1E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // ── Stem ──
    canvas.drawLine(
      Offset(cx, cy + size.height * 0.28),
      Offset(cx, cy - size.height * 0.10),
      strokePaint,
    );

    // ── Center tall leaf ──
    _drawLeaf(
      canvas,
      paint,
      base: Offset(cx, cy - size.height * 0.08),
      tip: Offset(cx, cy - size.height * 0.42),
      width: size.width * 0.14,
    );

    // ── Left leaf ──
    _drawLeaf(
      canvas,
      paint,
      base: Offset(cx - size.width * 0.04, cy - size.height * 0.02),
      tip: Offset(cx - size.width * 0.28, cy - size.height * 0.30),
      width: size.width * 0.10,
    );

    // ── Right leaf ──
    _drawLeaf(
      canvas,
      paint,
      base: Offset(cx + size.width * 0.04, cy - size.height * 0.02),
      tip: Offset(cx + size.width * 0.28, cy - size.height * 0.30),
      width: size.width * 0.10,
    );

    // ── Small left leaf ──
    _drawLeaf(
      canvas,
      paint,
      base: Offset(cx - size.width * 0.02, cy + size.height * 0.08),
      tip: Offset(cx - size.width * 0.20, cy - size.height * 0.10),
      width: size.width * 0.08,
    );

    // ── Small right leaf ──
    _drawLeaf(
      canvas,
      paint,
      base: Offset(cx + size.width * 0.02, cy + size.height * 0.08),
      tip: Offset(cx + size.width * 0.20, cy - size.height * 0.10),
      width: size.width * 0.08,
    );

    // ── Ground / soil line ──
    final groundPaint = Paint()
      ..color = const Color(0xFF2D5E1E)
      ..style = PaintingStyle.fill;

    final groundRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cx, cy + size.height * 0.30),
        width: size.width * 0.55,
        height: size.height * 0.045,
      ),
      const Radius.circular(4),
    );
    canvas.drawRRect(groundRect, groundPaint);
  }

  void _drawLeaf(
    Canvas canvas,
    Paint paint, {
    required Offset base,
    required Offset tip,
    required double width,
  }) {
    final dx = tip.dy - base.dy;
    final dy = -(tip.dx - base.dx);
    final len = (dx * dx + dy * dy == 0)
        ? 1.0
        : (dx * dx + dy * dy).abs() > 0
            ? (dx * dx + dy * dy) > 0
                ? (dx * dx + dy * dy)
                : 1.0
            : 1.0;
    final norm = Offset(dx, dy) / len * width * 0.5;

    final path = Path()
      ..moveTo(base.dx, base.dy)
      ..quadraticBezierTo(
        (base.dx + tip.dx) / 2 + norm.dx,
        (base.dy + tip.dy) / 2 + norm.dy,
        tip.dx,
        tip.dy,
      )
      ..quadraticBezierTo(
        (base.dx + tip.dx) / 2 - norm.dx,
        (base.dy + tip.dy) / 2 - norm.dy,
        base.dx,
        base.dy,
      )
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}