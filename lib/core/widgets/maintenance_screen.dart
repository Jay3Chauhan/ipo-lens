import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:ipo_lens/utils/theme/theme_extensions.dart';

class MaintenanceScreen extends StatefulWidget {
  final String message;

  const MaintenanceScreen({
    super.key,
    required this.message,
  });

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).appColors;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: c.background,
      body: Stack(
        children: [
          // Blurred Background Content
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Column(
                children: [
                  // Header
                  Container(
                    decoration: BoxDecoration(
                      color: c.background,
                      border: Border(
                        bottom: BorderSide(color: c.border),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: SafeArea(
                      bottom: false,
                      child: Row(
                        children: [
                          Icon(Icons.menu, color: c.textTertiary),
                          const SizedBox(width: 12),
                          Text(
                            'DASHBOARD',
                            style: TextStyle(
                              color: c.textPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Mock Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: c.cardSecondary.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: c.cardSecondary.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.4),
            ),
          ),

          // Bottom Sheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: c.card,
                border: Border(
                  top: BorderSide(
                    color: c.border.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 30,
                    offset: const Offset(0, -10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Container(
                      width: 48,
                      height: 6,
                      decoration: BoxDecoration(
                        color: c.border,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 24, 32, 48),
                    child: Column(
                      children: [
                        // Animated Lens Icon
                        _buildAnimatedLens(c),

                        const SizedBox(height: 32),

                        // Title
                        Text(
                          'Under Maintenance',
                          style: TextStyle(
                            color: c.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Message
                        Text(
                          widget.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: c.textSecondary,
                            fontSize: 14,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Action Icons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildActionIcon(Icons.close, c),
                            const SizedBox(width: 16),
                            _buildActionIcon(Icons.rss_feed_rounded, c),
                            const SizedBox(width: 16),
                            _buildActionIcon(Icons.notifications_rounded, c),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Dismiss Button
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            color: c.cardSecondary,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: c.border),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                // This won't do anything in maintenance mode
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Center(
                                child: Text(
                                  'Dismiss',
                                  style: TextStyle(
                                    color: c.textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedLens(AppColorsExtension c) {
    return SizedBox(
      width: 192,
      height: 192,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer dashed circle
          AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationAnimation.value,
                child: CustomPaint(
                  size: const Size(192, 192),
                  painter: DashedCirclePainter(
                    color: c.border,
                    strokeWidth: 1,
                  ),
                ),
              );
            },
          ),

          // Inner circle
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: c.border.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
          ),

          // Main lens with gradient
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 128,
                  height: 128,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        c.secondary.withValues(alpha: 0.3),
                        c.secondary.withValues(alpha: 0.1),
                        c.cardSecondary,
                      ],
                    ),
                    border: Border.all(color: c.border, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: c.secondary.withValues(alpha: 0.2),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Main refresh icon
                      AnimatedBuilder(
                        animation: _rotationAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _rotationAnimation.value,
                            child: Icon(
                              Icons.refresh_rounded,
                              size: 48,
                              color: c.secondary,
                            ),
                          );
                        },
                      ),
                      // Sparkles
                      Positioned(
                        top: 16,
                        right: 16,
                        child: _buildSparkle(c, 12),
                      ),
                      Positioned(
                        bottom: 24,
                        left: 16,
                        child: _buildSparkle(c, 10, color: c.secondary),
                      ),
                      Positioned(
                        top: 64,
                        right: -8,
                        child: _buildSparkle(c, 8),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Top floating icon
          Positioned(
            top: -8,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: c.cardSecondary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: c.border),
              ),
              child: Icon(
                Icons.show_chart_rounded,
                size: 12,
                color: c.textSecondary,
              ),
            ),
          ),

          // Bottom right floating icon
          Positioned(
            bottom: 16,
            right: -8,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: c.cardSecondary,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: c.border),
              ),
              child: Icon(
                Icons.center_focus_strong_rounded,
                size: 10,
                color: c.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSparkle(AppColorsExtension c, double size, {Color? color}) {
    return Icon(
      Icons.auto_awesome_rounded,
      size: size,
      color: color ?? Colors.white.withValues(alpha: 0.8),
    );
  }

  Widget _buildActionIcon(IconData icon, AppColorsExtension c) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: c.cardSecondary,
        shape: BoxShape.circle,
        border: Border.all(color: c.border),
      ),
      child: Icon(
        icon,
        size: 20,
        color: c.textSecondary,
      ),
    );
  }
}

// Custom painter for dashed circle
class DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  DashedCirclePainter({
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    const dashCount = 40;
    const dashLength = math.pi * 2 / dashCount;
    const gapLength = dashLength * 0.5;

    for (int i = 0; i < dashCount; i++) {
      final startAngle = i * (dashLength + gapLength);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        dashLength,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
