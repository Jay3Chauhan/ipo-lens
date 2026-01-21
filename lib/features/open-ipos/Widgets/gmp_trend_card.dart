import 'package:flutter/material.dart';
import 'package:ipo_lens/features/open-ipos/Models/open_ipo_models.dart';
import 'package:ipo_lens/utils/theme/theme_extensions.dart';
import 'dart:math';

class GmpTrendCard extends StatefulWidget {
  final IpoItem ipo;
  final List<GmpTrendHistory> gmpTrend;
  final Color cardColor;

  const GmpTrendCard({
    super.key,
    required this.ipo,
    required this.gmpTrend,
    required this.cardColor,
  });

  @override
  State<GmpTrendCard> createState() => _GmpTrendCardState();
}

class _GmpTrendCardState extends State<GmpTrendCard> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.gmpTrend.isEmpty && widget.ipo.apiGmpValue == null) {
      return const SizedBox.shrink();
    }

    final colors = Theme.of(context).appColors;
    final textTheme = Theme.of(context).textTheme;
    
    // Extract data from GmpTrendHistory and reverse to show oldest to newest (9 Jan to 18 Jan)
    final reversedTrend = widget.gmpTrend.reversed.toList();
    final values = _extractGmpValues(reversedTrend, widget.ipo.apiGmpValue);
    final profits = _extractProfits(reversedTrend);
    
    final latestValue = values.isNotEmpty ? values.last : (widget.ipo.apiGmpValue?.toDouble() ?? 0.0);
    
    // Calculate listing estimate
    final ipoPrice = _parseAmount(widget.ipo.apiPrice?.toString()) ??
                     _parseAmount(widget.ipo.lotIssuePrice) ??
                     _parseAmount(widget.ipo.maxIpoPrice);
    final listingEstimate = ipoPrice + latestValue;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'LATEST GMP',
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: colors.textPrimary,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 20),
            
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '₹${latestValue.toStringAsFixed(2)}',
                      style: textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: latestValue < 0 ? colors.loss : colors.textPrimary,
                        fontSize: 36,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'LISTING ESTIMATE: ₹${listingEstimate.toStringAsFixed(0)}',
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.textTertiary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            GestureDetector(
              onTapDown: (details) {
                final RenderBox box = context.findRenderObject() as RenderBox;
                final localPosition = details.localPosition;
                final chartWidth = box.size.width - 40; // Account for padding
                final relativeX = (localPosition.dx - 20) / chartWidth;
                
                if (relativeX >= 0 && relativeX <= 1 && values.isNotEmpty) {
                  final index = (relativeX * (values.length - 1)).round().clamp(0, values.length - 1);
                  setState(() {
                    _selectedIndex = index;
                  });
                }
              },
              onTapUp: (_) {
                // Keep the selected point visible
              },
              child: SizedBox(
                height: 140,
                width: double.infinity,
                child: CustomPaint(
                  painter: TrendLinePainter(
                    values: values,
                    profits: profits,
                    ipoPrice: ipoPrice,
                    selectedIndex: _selectedIndex,
                    lineColor: colors.secondary,
                    fillColor: colors.secondary.withOpacity(0.15),
                    borderColor: colors.border,
                    textColor: colors.textTertiary,
                    dotColor: colors.secondary,
                    backgroundColor: widget.cardColor,
                    textStyle: textTheme.labelSmall?.copyWith(
                      fontSize: 10,
                      color: colors.textTertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<double> _extractGmpValues(List<GmpTrendHistory> trend, int? fallback) {
    final values = trend
        .map((item) => _parseAmount(item.gmp))
        .where((value) => value > 0)
        .toList();

    if (values.isEmpty && fallback != null) {
      values.add(fallback.toDouble());
    }

    if (values.length == 1) {
      values.add(values.first);
    }

    return values;
  }

  List<double> _extractProfits(List<GmpTrendHistory> trend) {
    return trend
        .map((item) => _parseAmount(item.estimatedProfit))
        .toList();
  }

  double _parseAmount(String? raw) {
    if (raw == null) return 0;
    final cleaned = raw.replaceAll(RegExp(r'[^0-9\.\-]'), '');
    if (cleaned.isEmpty) return 0;
    return double.tryParse(cleaned) ?? 0;
  }
}

class TrendLinePainter extends CustomPainter {
  final List<double> values;
  final List<double> profits;
  final double ipoPrice;
  final int? selectedIndex;
  final Color lineColor;
  final Color fillColor;
  final Color borderColor;
  final Color textColor;
  final Color dotColor;
  final Color backgroundColor;
  final TextStyle? textStyle;

  TrendLinePainter({
    required this.values,
    required this.profits,
    required this.ipoPrice,
    this.selectedIndex,
    required this.lineColor,
    required this.fillColor,
    required this.borderColor,
    required this.textColor,
    required this.dotColor,
    required this.backgroundColor,
    this.textStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    final minValue = values.reduce(min);
    final maxValue = values.reduce(max);
    final range = max(maxValue - minValue, 1);
    const topPadding = 10.0;
    const bottomPadding = 10.0;
    final chartHeight = size.height - topPadding - bottomPadding;

    // Draw horizontal grid lines
    final gridPaint = Paint()
      ..color = borderColor.withOpacity(0.3)
      ..strokeWidth = 0.5;
    for (var i = 0; i <= 3; i++) {
      final y = topPadding + (chartHeight * (i / 3));
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Calculate points
    final points = <Offset>[];
    for (var i = 0; i < values.length; i++) {
      final x = size.width * (i / (values.length - 1));
      final normalized = (values[i] - minValue) / range;
      final y = topPadding + (1 - normalized) * chartHeight;
      points.add(Offset(x, y));
    }

    // Draw smooth curve with fill
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];
      final controlX = (current.dx + next.dx) / 2;
      path.cubicTo(controlX, current.dy, controlX, next.dy, next.dx, next.dy);
    }

    // Fill area under curve
    final fillPath = Path.from(path)
      ..lineTo(points.last.dx, size.height - bottomPadding)
      ..lineTo(points.first.dx, size.height - bottomPadding)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [fillColor, fillColor.withOpacity(0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, fillPaint);

    // Draw line (no dots on the line itself)
    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);

    // Draw selected point indicator with tooltip
    if (selectedIndex != null && selectedIndex! < points.length) {
      final selectedPoint = points[selectedIndex!];
      final gmpValue = values[selectedIndex!];
      final profit = selectedIndex! < profits.length ? profits[selectedIndex!] : 0.0;
      final listingEstimate = ipoPrice + gmpValue;
      
      // Draw vertical line to x-axis
      final lineToPaint = Paint()
        ..color = dotColor.withOpacity(0.3)
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;
      canvas.drawLine(
        selectedPoint,
        Offset(selectedPoint.dx, size.height - bottomPadding),
        lineToPaint,
      );
      
      // Draw glow
      final glowPaint = Paint()
        ..color = dotColor.withOpacity(0.3)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(selectedPoint, 8, glowPaint);
      
      // Draw outer circle
      final outerPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(selectedPoint, 5, outerPaint);
      
      // Draw inner circle
      final innerPaint = Paint()
        ..color = dotColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(selectedPoint, 3.5, innerPaint);
      
      // Draw tooltip
      final tooltipPaint = TextPainter(
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left,
      );
      
      final profitText = profit != 0.0 ? '\n${profit >= 0 ? "+" : ""}₹${profit.toStringAsFixed(0)}' : '';
      tooltipPaint.text = TextSpan(
        style: textStyle?.copyWith(fontSize: 11, height: 1.3),
        children: [
          TextSpan(
            text: '₹${gmpValue.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: textColor,
              fontSize: 12,
            ),
          ),
          TextSpan(
            text: '\n₹${listingEstimate.toStringAsFixed(0)} Est.$profitText',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: textColor.withOpacity(0.7),
              fontSize: 10,
            ),
          ),
        ],
      );
      tooltipPaint.layout(maxWidth: 150);
      
      // Position tooltip above the point
      final tooltipX = (selectedPoint.dx - tooltipPaint.width / 2).clamp(5.0, size.width - tooltipPaint.width - 5);
      final tooltipY = selectedPoint.dy - tooltipPaint.height - 15;
      
      // Draw tooltip background
      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(tooltipX - 8, tooltipY - 6, tooltipPaint.width + 16, tooltipPaint.height + 12),
        const Radius.circular(8),
      );
      final tooltipBgPaint = Paint()
        ..color = backgroundColor
        ..style = PaintingStyle.fill;
      canvas.drawRRect(rrect, tooltipBgPaint);
      
      final tooltipBorderPaint = Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawRRect(rrect, tooltipBorderPaint);
      
      tooltipPaint.paint(canvas, Offset(tooltipX, tooltipY));
    }
  }

  @override
  bool shouldRepaint(covariant TrendLinePainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.profits != profits ||
        oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.borderColor != borderColor;
  }
}
