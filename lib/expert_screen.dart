import 'package:flutter/material.dart';

class ExpertScreen extends StatelessWidget {
  const ExpertScreen({super.key});

  static const _primaryGreen = Color(0xFF2F7F34);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildScannedSpecimen(),
                  const SizedBox(height: 12),
                  _buildDetectionCard(),
                  const SizedBox(height: 4),
                  _buildTreatmentSection(),
                  _buildActionButtons(context),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ──
  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2F7F34), Color(0xFF43A047)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Expert Advisory',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              const Icon(Icons.notifications_outlined, color: Colors.white, size: 24),
              const SizedBox(width: 16),
              const Icon(Icons.account_circle_outlined, color: Colors.white, size: 26),
            ],
          ),
        ),
      ),
    );
  }

  // ── Scanned Specimen Thumbnail ──
  Widget _buildScannedSpecimen() {
    return Center(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  // Placeholder green box representing scanned image
                  color: const Color(0xFF2D5E1E),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _PlantThumbnail(),
                ),
              ),
              Positioned(
                bottom: -6,
                right: -6,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    color: _primaryGreen,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                  ),
                  child: const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'SCANNED SPECIMEN',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.0,
            ),
          ),
        ],
      ),
    );
  }

  // ── Main Detection Card ──
  Widget _buildDetectionCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _primaryGreen.withOpacity(0.10), width: 1),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 3)),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image area
            Container(
              width: double.infinity,
              height: 190,
              color: const Color(0xFF3D6B2C),
              child: const _TomatoHeroImage(),
            ),
            // Info section
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: Text(
                          'Tomato Early Blight',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _primaryGreen.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'DISEASE',
                          style: TextStyle(
                            color: _primaryGreen,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: 0.94,
                            minHeight: 8,
                            backgroundColor: const Color(0xFFF1F5F9),
                            valueColor: const AlwaysStoppedAnimation<Color>(_primaryGreen),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        '94% Confidence',
                        style: TextStyle(
                          color: _primaryGreen,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Treatment Recommendations ──
  Widget _buildTreatmentSection() {
    const treatments = [
      'Prune and remove infected lower leaves to prevent spore splash-back from the soil.',
      'Apply copper-based fungicides or bio-pesticides early in the morning for best results.',
      'Improve air circulation by spacing plants at least 24 inches apart.',
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.medical_services_rounded, color: _primaryGreen, size: 22),
              SizedBox(width: 8),
              Text(
                'Treatment Recommendation',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...treatments.map((t) => _TreatmentItem(text: t)),
        ],
      ),
    );
  }

  // ── Action Buttons ──
  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Listen Advisory
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF34D399), Color(0xFF2F7F34)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: _primaryGreen.withOpacity(0.30),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {},
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.volume_up_rounded, color: Colors.white, size: 22),
                    SizedBox(width: 10),
                    Text(
                      'Listen Advisory',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Scan Another Leaf
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.center_focus_strong_rounded, color: _primaryGreen, size: 22),
              label: const Text(
                'Scan Another Leaf',
                style: TextStyle(
                  color: _primaryGreen,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: _primaryGreen, width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  TREATMENT ITEM WIDGET
// ─────────────────────────────────────────────

class _TreatmentItem extends StatelessWidget {
  final String text;
  const _TreatmentItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(Icons.radio_button_checked_rounded, color: Color(0xFF2F7F34), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF334155),
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  PLACEHOLDER PAINTED IMAGES
// ─────────────────────────────────────────────

/// Thumbnail: small leaf icon on dark green background
class _PlantThumbnail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1B4D1F),
      child: const Center(
        child: Icon(Icons.eco_rounded, color: Color(0xFF81C784), size: 44),
      ),
    );
  }
}

/// Hero: tomato plant illustration on green background
class _TomatoHeroImage extends StatelessWidget {
  const _TomatoHeroImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Background leaf texture
          Positioned.fill(
            child: CustomPaint(painter: _LeafPatternPainter()),
          ),
          // Centered tomato icon
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.yard_rounded, color: Color(0xFFFFFFFF), size: 64),
                SizedBox(height: 6),
                Text(
                  'Tomato Plant',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LeafPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    // Draw some abstract leaf shapes
    for (int i = 0; i < 6; i++) {
      final path = Path();
      final x = (size.width / 5) * i;
      final y = size.height * 0.3 + (i % 2 == 0 ? -20.0 : 20.0);
      path.moveTo(x, y + 40);
      path.quadraticBezierTo(x - 30, y, x + 10, y - 40);
      path.quadraticBezierTo(x + 50, y, x, y + 40);
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}