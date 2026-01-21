import 'package:flutter/material.dart';
import 'package:ipo_lens/features/open-ipos/Models/open_ipo_models.dart';
import 'package:ipo_lens/utils/theme/theme_extensions.dart';

class PeerComparisonCard extends StatelessWidget {
  final IpoItem ipo;
  final List<PeerComparisonRow> rows;
  final Color cardColor;

  const PeerComparisonCard({
    super.key,
    required this.ipo,
    required this.rows,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return const SizedBox.shrink();
    }

    final colors = Theme.of(context).appColors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'PEER COMPARISON',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                  letterSpacing: 0.6,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.compare_arrows_rounded,
                size: 20,
                color: colors.textTertiary,
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Table with horizontal scroll
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                _buildHeaderRow(colors, textTheme),
                const SizedBox(height: 12),
                // Data Rows
                ...rows.asMap().entries.map((entry) {
                  final row = entry.value;
                  final isSelf = _isSameCompany(row.company, ipo.apiCompanyName);
                  final eps = row.epsBasic ?? row.epsDiluted ?? '—';
                  final pe = row.peX ?? '—';
                  final ronw = row.roNW ?? '—';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildDataRow(
                      context: context,
                      company: row.company ?? '—',
                      epsBasic: eps,
                      nav: row.nav ?? '—',
                      peRatio: pe,
                      ronw: ronw,
                      isSelf: isSelf,
                      colors: colors,
                      textTheme: textTheme,
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          
        ],
      ),
    );
  }

  Widget _buildHeaderRow(AppColorsExtension colors, TextTheme textTheme) {
    return Row(
      children: [
        SizedBox(
          width: 180,
          child: Text(
            'COMPANY',
            style: textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.textTertiary,
              letterSpacing: 1.2,
            ),
          ),
        ),
        _buildHeaderCell('EPS\n(BASIC)', colors, textTheme),
        _buildHeaderCell('NAV', colors, textTheme),
        _buildHeaderCell('P/E\n(X)', colors, textTheme),
        _buildHeaderCell('RONW\n(%)', colors, textTheme),
      ],
    );
  }

  Widget _buildHeaderCell(String title, AppColorsExtension colors, TextTheme textTheme) {
    return SizedBox(
      width: 85,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w800,
          color: colors.textTertiary,
          letterSpacing: 0.5,
          height: 1.2,
        ),
      ),
    );
  }

  Widget _buildDataRow({
    required BuildContext context,
    required String company,
    required String epsBasic,
    required String nav,
    required String peRatio,
    required String ronw,
    required bool isSelf,
    required AppColorsExtension colors,
    required TextTheme textTheme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: isSelf ? colors.secondary.withValues(alpha:0.1) : colors.surface.withValues(alpha:0.3),
        borderRadius: BorderRadius.circular(12),
        border: isSelf ? Border.all(color: colors.secondary.withValues(alpha:0.3), width: 1.5) : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  company,
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isSelf ? colors.secondary : colors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (isSelf) ...[
                  const SizedBox(height: 2),
                  Container(
                    width: 16,
                    height: 3,
                    decoration: BoxDecoration(
                      color: colors.secondary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ],
            ),
          ),
          _buildValueCell(epsBasic, colors, textTheme),
          _buildValueCell(nav, colors, textTheme),
          _buildValueCell(peRatio, colors, textTheme, highlighted: peRatio != '—'),
          _buildValueCell(
            ronw,
            colors,
            textTheme,
            isPercentage: true,
            highlighted: ronw != '—',
          ),
        ],
      ),
    );
  }

  Widget _buildValueCell(
    String value,
    AppColorsExtension colors,
    TextTheme textTheme, {
    bool highlighted = false,
    bool isPercentage = false,
  }) {
    final displayValue = isPercentage && value != '—' ? '$value%' : value;
    
    return SizedBox(
      width: 85,
      child: Text(
        displayValue,
        textAlign: TextAlign.center,
        style: textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }


  bool _isSameCompany(String? a, String? b) {
    if (a == null || b == null) return false;
    return a.toLowerCase().contains(b.toLowerCase()) ||
        b.toLowerCase().contains(a.toLowerCase());
  }
}
