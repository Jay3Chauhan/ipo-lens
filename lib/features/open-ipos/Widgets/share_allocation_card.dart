import 'package:flutter/material.dart';
import 'package:ipo_lens/features/open-ipos/Models/open_ipo_models.dart';
import 'package:ipo_lens/features/open-ipos/Provider/share_allocation_provider.dart';
import 'package:ipo_lens/utils/theme/theme_extensions.dart';
import 'package:provider/provider.dart';

class ShareAllocationCard extends StatelessWidget {
  final List<IpoShareAllocation> allocations;
  final Color cardColor;

  const ShareAllocationCard({
    super.key,
    required this.allocations,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ShareAllocationProvider(),
      child: _ShareAllocationCardContent(
        allocations: allocations,
        cardColor: cardColor,
      ),
    );
  }
}

class _ShareAllocationCardContent extends StatefulWidget {
  final List<IpoShareAllocation> allocations;
  final Color cardColor;

  const _ShareAllocationCardContent({
    required this.allocations,
    required this.cardColor,
  });

  @override
  State<_ShareAllocationCardContent> createState() => _ShareAllocationCardContentState();
}

class _ShareAllocationCardContentState extends State<_ShareAllocationCardContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleView(ShareAllocationProvider provider) {
    provider.toggleView();
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShareAllocationProvider>();
    final colors = Theme.of(context).appColors;
    final textTheme = Theme.of(context).textTheme;

    final totalShares = widget.allocations.fold<int>(
      0,
      (sum, item) => sum + (item.sharesAllocated ?? 0),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.pie_chart_rounded, size: 20, color: colors.primary),
              const SizedBox(width: 8),
              Text(
                'ALLOCATION BREAKDOWN',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                  letterSpacing: 0.6,
                ),
              ),
              const Spacer(),
              // Toggle Button
              Container(
                decoration: BoxDecoration(
                  color: colors.surface.withValues(alpha:0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    _buildToggleButton(
                      icon: Icons.bar_chart_rounded,
                      isActive: provider.showBarView,
                      colors: colors,
                      onTap: () => _toggleView(provider),
                    ),
                    _buildToggleButton(
                      icon: Icons.table_chart_rounded,
                      isActive: !provider.showBarView,
                      colors: colors,
                      onTap: () => _toggleView(provider),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Total Shares Offered: ${_formatShareNumber(totalShares)}',
            style: textTheme.labelSmall?.copyWith(
              color: colors.textTertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          FadeTransition(
            opacity: _fadeAnimation,
            child: provider.showBarView
                ? _buildBarView(colors, textTheme, totalShares, provider)
                : _buildTableView(colors, textTheme),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required IconData icon,
    required bool isActive,
    required AppColorsExtension colors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive ? colors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isActive ? Colors.white : colors.textTertiary,
        ),
      ),
    );
  }
  Widget _buildBarView(
    AppColorsExtension colors,
    TextTheme textTheme,
    int totalShares,
    ShareAllocationProvider provider,
  ) {
    // Use allocations as-is (data already contains bNII and sNII separately)
    final expandedAllocations = <Map<String, dynamic>>[];
    for (var item in widget.allocations) {
      expandedAllocations.add({
        'category': item.category ?? '',
        'shares': item.sharesAllocated ?? 0,
        'percent': item.allocationPct ?? 0.0,
      });
    }

    // Distinct colors for each category
    final categoryColors = [
      const Color(0xFF3B82F6), // Blue for QIB
      const Color.fromARGB(255, 72, 146, 236), // Pink for bNII
      const Color.fromARGB(255, 92, 246, 220), // Purple for sNII
      const Color.fromARGB(255, 16, 162, 185), // Green for Retail
      const Color.fromARGB(255, 11, 229, 245), // Amber for Market Maker
    ];

    return Column(
      children: [
        // Stacked Bar Chart with tap detection
        Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha:0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: expandedAllocations.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final percent = (item['percent'] as double) / 100;
                final color = categoryColors[index % categoryColors.length];
                final isHovered = provider.hoveredIndex == index;

                return Flexible(
                  flex: (percent * 1000).toInt(),
                  child: GestureDetector(
                    onTap: () => provider.toggleHoveredIndex(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      color: color,
                      transform: isHovered
                          ? Matrix4.translationValues(0, -4, 0)
                          : Matrix4.identity(),
                      child: Center(
                        child: isHovered
                            ? FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    _getCategoryLabel(item['category'] as String),
                                    style: textTheme.labelSmall?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        if (provider.hoveredIndex != null) ...[
          const SizedBox(height: 8),
          Text(
            'Tap again to hide',
            style: textTheme.labelSmall?.copyWith(
              color: colors.textTertiary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
        const SizedBox(height: 20),
        // Legend with numbers (including split NII)
        ...expandedAllocations.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final categoryRaw = item['category'] as String;
          final category = _getCategoryLabel(categoryRaw);
          final shares = item['shares'] as int;
          final percent = item['percent'] as double;
          final color = categoryColors[index % categoryColors.length];
          final isSub = categoryRaw.toLowerCase().contains('small') || 
                        categoryRaw.toLowerCase().contains('big');

          return Padding(
            padding: EdgeInsets.only(
              bottom: 12,
              left: isSub ? 20 : 0,
            ),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Text(
                    isSub ? '− $category' : category,
                    style: textTheme.bodySmall?.copyWith(fontSize: 10,
                      fontWeight: isSub ? FontWeight.w400 : FontWeight.w500,
                      color: isSub ? colors.textSecondary : colors.textPrimary,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    _formatShareNumber(shares),
                    textAlign: TextAlign.right,
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha:0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${percent.toStringAsFixed(2)}%',
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTableView(AppColorsExtension colors, TextTheme textTheme) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha:0.5),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  'CATEGORY',
                  style: textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colors.textTertiary,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'SHARES',
                  textAlign: TextAlign.right,
                  style: textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colors.textTertiary,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 50,
                child: Text(
                  '%',
                  textAlign: TextAlign.center,
                  style: textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colors.textTertiary,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Data Rows
        ...widget.allocations.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final category = _getCategoryLabel(item.category ?? '');
          final shares = item.sharesAllocated ?? 0;
          final percent = item.allocationPct ?? 0.0;
          final isLast = index == widget.allocations.length - 1;

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 0),
            decoration: BoxDecoration(
              color: index.isEven
                  ? colors.surface.withValues(alpha:0.2)
                  : Colors.transparent,
              borderRadius: isLast
                  ? const BorderRadius.vertical(bottom: Radius.circular(12))
                  : null,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Text(
                    category,
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    _formatShareNumber(shares),
                    textAlign: TextAlign.right,
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.secondary.withValues(alpha:0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${percent.toStringAsFixed(0)}%',
                    textAlign: TextAlign.center,
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colors.secondary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  String _getCategoryLabel(String category) {
    final lower = category.toLowerCase();
    if (category.toUpperCase().contains('QIB')) return 'QIB Shares';
    if (lower.contains('big') && lower.contains('non')) return 'bNII > ₹10L';
    if (lower.contains('small') && lower.contains('non')) return 'sNII < ₹10L';
    if (lower.contains('non') && lower.contains('inst') && !lower.contains('big') && !lower.contains('small'))
      return 'NII (HNI) Shares';
    if (lower.contains('retail')) return 'Retail Shares';
    if (lower.contains('market') && lower.contains('maker'))
      return 'Market Maker';
    return category.toUpperCase();
  }

  String _formatShareNumber(int number) {
    if (number >= 10000000) {
      return '${(number / 10000000).toStringAsFixed(2)} Cr';
    } else if (number >= 100000) {
      return '${(number / 100000).toStringAsFixed(2)} L';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)} K';
    }
    return number.toString();
  }
}
