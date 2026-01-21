import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ipo_lens/features/open-ipos/Models/open_ipo_models.dart';
import 'package:ipo_lens/features/open-ipos/Provider/open_ipos_provider.dart';
import 'package:ipo_lens/features/open-ipos/Widgets/share_allocation_card.dart';
import 'package:ipo_lens/features/open-ipos/Widgets/gmp_trend_card.dart';
import 'package:ipo_lens/features/open-ipos/Widgets/peer_comparison_card.dart';
import 'package:ipo_lens/utils/theme/theme_extensions.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class OpenIpoDetailsScreen extends StatelessWidget {
  final String id;

  const OpenIpoDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OpenIposProvider>();
    final ipo = provider.getById(id);
    final colors = Theme.of(context).appColors;
    final bgColor = colors.background;
    final cardColor = colors.card;
    final peerRows = ipo?.peerComparison ?? [];
    final objectives = ipo?.objectives ?? [];
    final strengths = ipo?.strengths ?? [];
    final gmpTrend = ipo?.gmpTrendHistoryTable ?? [];

    // Responsive padding
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 600 ? 24.0 : 16.0;
    final cardSpacing = screenWidth > 600 ? 20.0 : 16.0;

    if (ipo == null) {
      return Scaffold(
        backgroundColor: bgColor,
        body: Center(child: Text('IPO not found')),
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, ipo),
          SliverPadding(
            padding: EdgeInsets.all(horizontalPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildCompanyHeader(context, ipo, cardColor),
                SizedBox(height: cardSpacing),
                _buildGmpTrendCard(context, ipo, gmpTrend, cardColor),
                SizedBox(height: cardSpacing),
                _buildPreIpoGmpAnalysis(context, ipo, cardColor),
                SizedBox(height: cardSpacing),
                _buildExpectedBandAndIssueSize(context, ipo, cardColor),
                SizedBox(height: cardSpacing),
                _buildIpoTimeline(context, ipo, cardColor),
                SizedBox(height: cardSpacing),
                _buildFinancialSnapshot(context, ipo, cardColor),
                SizedBox(height: cardSpacing),
                _buildShareAllocation(context, ipo, cardColor),
                SizedBox(height: cardSpacing),
                _buildFinalSubscriptionCard(context, ipo, cardColor),
                SizedBox(height: cardSpacing),
                _buildPeerComparison(context, ipo, peerRows, cardColor),
                SizedBox(height: cardSpacing),
                _buildObjectives(context, objectives, cardColor),
                SizedBox(height: cardSpacing),
                _buildStrengths(context, strengths, cardColor),
                SizedBox(height: cardSpacing),
                _buildCompanyAnalysis(context, ipo, strengths, cardColor),
                SizedBox(height: cardSpacing),
                _buildContactAndSupport(context, ipo, cardColor),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomActionBar(context),
    );
  }

  Widget _buildAppBar(BuildContext context, IpoItem ipo) {
    final colors = Theme.of(context).appColors;
    final bgColor = colors.background.withValues(alpha: 0.9);

    return SliverAppBar(
      floating: true,
      pinned: true,
      backgroundColor: bgColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: Icon(Icons.arrow_back, color: colors.textSecondary),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatTitle(ipo.apiCompanyName ?? 'IPO Lens'),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
          Text(
            ipo.apiIpoCategory.toString(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colors.textTertiary,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.share_outlined,
              size: 18,
              color: colors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {},
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.bookmark, size: 18, color: Colors.white),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildExpectedBandAndIssueSize(
    BuildContext context,
    IpoItem ipo,
    Color cardColor,
  ) {
    final colors = Theme.of(context).appColors;
    final textTheme = Theme.of(context).textTheme;
    final band = _formatPriceBand(ipo);
    final lot =
        _stringValue(ipo.apiLot) ??
        _stringValue(ipo.sharesPerLotScraped) ??
        _stringValue(ipo.lotMarketLot) ??
        '—';
    final issueSize = _stringValue(ipo.companySectorInfo?.ipoIssueSize.toString()) ?? '—';
    final issueType = ipo.apiIpoCategory ?? 'Issue';

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EXPECTED BAND',
                  style: textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.textTertiary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  band,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Lot size: $lot',
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ISSUE SIZE',
                  style: textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.textTertiary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  issueSize,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  issueType,
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreIpoGmpAnalysis(
    BuildContext context,
    IpoItem ipo,
    Color cardColor,
  ) {
    final colors = Theme.of(context).appColors;
    final textTheme = Theme.of(context).textTheme;
    final gmpValue =
ipo.currentGmp ?? _stringValue(ipo.apiGmpValue) ?? '—';
    final gmpPercent = ipo.apiGmpPercent ?? _parsePercent(ipo.gmpPercentCalc);
    final openDate =
        _stringValue(ipo.apiIssueOpenDate) ??
        _stringValue(ipo.ipoIssueOpeningDateParsed) ??
        _stringValue(ipo.ipoOpenDateParsed) ??
        'TBA';

        print("apiGmpValue ${ipo.currentGmp}");
    // final strength = _gmpStrengthBars(gmpPercent);
    final strength = ipo.apiFireRatingCount ?? 0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.primaryVariant.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.primaryVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PRE-IPO GMP ANALYSIS',
                style: textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.primaryVariant,
                  letterSpacing: 1.1,
                ),
              ),
              Icon(Icons.trending_up, size: 18, color: colors.secondary),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                      ),
                      children: [
                        TextSpan(text: '₹$gmpValue'),
                        if (gmpPercent != null)
                          TextSpan(
                            text: ' (${gmpPercent.toStringAsFixed(1)}%)',
                            style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: gmpPercent >= 0 ? colors.secondary : colors.loss,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Open Date: $openDate',
                    style: textTheme.labelSmall?.copyWith(
                      color: colors.textTertiary,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Determined Strength',
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colors.textTertiary,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: List.generate(5, (index) {
                      final active = index < strength;
                      return Container(
                        width: 16,
                        height: 6,
                        margin: const EdgeInsets.only(left: 4),
                        decoration: BoxDecoration(
                          color: active
                              ? colors.secondary
                              : colors.textTertiary.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyAnalysis(
    BuildContext context,
    IpoItem ipo,
    List<String> strengths,
    Color cardColor,
  ) {
    final colors = Theme.of(context).appColors;
    final textTheme = Theme.of(context).textTheme;
    final summary =
        ipo.aboutCompanyText ??
        ipo.ipoSummaryText ??
        'Company overview is being updated.';
    final bullets = strengths.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(20),
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
              Icon(Icons.analytics, size: 18, color: colors.secondary),
              const SizedBox(width: 8),
              Text(
                'COMPANY ANALYSIS',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            summary,
            style: textTheme.bodySmall?.copyWith(
              height: 1.2,fontWeight: FontWeight.w300,
              color: colors.textSecondary,
            ),
          ),
          if (bullets.isNotEmpty) ...[
            const SizedBox(height: 12),
            Column(
              children: bullets.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 14,
                        color: colors.secondary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item,
                          style: textTheme.labelSmall?.copyWith(
                            color: colors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildObjectsOfIssueUpcoming(
    BuildContext context,
    List<IpoObjective> objectives,
  ) {
    if (objectives.isEmpty) {
      return const SizedBox.shrink();
    }

    final colors = Theme.of(context).appColors;
    final textTheme = Theme.of(context).textTheme;
    final cardColor = colors.card;

    return Container(
      padding: const EdgeInsets.all(20),
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
              Icon(Icons.account_balance, size: 18, color: colors.secondary),
              const SizedBox(width: 8),
              Text(
                'OBJECTS OF ISSUE',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            children: objectives.map((item) {
              final amount = _parseAmount(item.amount);
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.surface.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.border),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        color: colors.secondary,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.object ?? 'Objective',
                            style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                            ),
                          ),
                          if (item.amount != null)
                            Text(
                              '₹${amount.toStringAsFixed(2)} Cr',
                              style: textTheme.labelSmall?.copyWith(
                                color: colors.textTertiary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildIpoTimeline(BuildContext context, IpoItem ipo, Color cardColor) {
    final colors = Theme.of(context).appColors;
    final textTheme = Theme.of(context).textTheme;

    // Get current date for comparison
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Parse dates and statuses
    final openDateParsed = _parseDate(ipo.ipoOpenDateParsed);
    final closeDateParsed = _parseDate(ipo.ipoCloseDateParsed);
    final basisDateParsed = _parseDate(ipo.basisOfAllotmentParsed);
    final refundDateParsed = _parseDate(ipo.initiationOfRefundsParsed);
    final creditDateParsed = _parseDate(ipo.creditOfSharesToDematParsed);
    final listingDateParsed = _parseDate(ipo.listingDateParsed);

    // Display dates - these are already strings, fallback to parsed dates
    final openDate = _stringValue(ipo.ipoOpenDate) ?? 
                     _stringValue(ipo.apiIssueOpenDate) ?? 
                     _formatDisplayDate(openDateParsed) ?? 
                     '—';
    final closeDate = _stringValue(ipo.ipoCloseDate) ?? 
                      _stringValue(ipo.apiIssueCloseDate) ?? 
                      _formatDisplayDate(closeDateParsed) ?? 
                      '—';
    final basisDate = _stringValue(ipo.basisOfAllotment) ?? 
                      _formatDisplayDate(basisDateParsed) ?? 
                      '—';
    final refundDate = _stringValue(ipo.initiationOfRefunds) ?? 
                       _formatDisplayDate(refundDateParsed) ?? 
                       '—';
    final creditDate = _stringValue(ipo.creditOfSharesToDemat) ?? 
                       _formatDisplayDate(creditDateParsed) ?? 
                       '—';
    final listingDate = _stringValue(ipo.listingDate) ?? 
                        _formatDisplayDate(listingDateParsed) ?? 
                        '—';

    // Determine statuses dynamically
    final openStatus = _getEventStatus(openDateParsed, today);
    final closeStatus = _getEventStatus(closeDateParsed, today);
    final basisStatus = _getEventStatus(basisDateParsed, today);
    final refundStatus = _getEventStatus(refundDateParsed, today);
    final creditStatus = _getEventStatus(creditDateParsed, today);
    final listingStatus = _getEventStatus(listingDateParsed, today);

    // Determine which event is currently active
    final isOpenActive = openStatus == 'active';
    final isCloseActive = closeStatus == 'active' || (openStatus == 'completed' && closeStatus != 'completed');
    final isBasisActive = basisStatus == 'active' || (closeStatus == 'completed' && basisStatus != 'completed');
    final isRefundActive = refundStatus == 'active' || (basisStatus == 'completed' && refundStatus != 'completed');
    final isCreditActive = creditStatus == 'active' || (refundStatus == 'completed' && creditStatus != 'completed');
    final isListingActive = listingStatus == 'active' || (creditStatus == 'completed' && listingStatus != 'completed');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'IPO TIMELINE',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 20),
          _buildTimelineItem(
            context: context,
            label: 'IPO Opens',
            date: openDate,
            subtitle: 'Issue opens for subscription',
            isCompleted: openStatus == 'completed',
            isActive: isOpenActive,
            colors: colors,
            textTheme: textTheme,
          ),
          _buildTimelineItem(
            context: context,
            label: 'IPO Closes',
            date: closeDate,
            subtitle: 'Last day for bidding',
            isCompleted: closeStatus == 'completed',
            isActive: isCloseActive,
            colors: colors,
            textTheme: textTheme,
          ),
          _buildTimelineItem(
            context: context,
            label: 'Basis of Allotment',
            date: basisDate,
            subtitle: 'Allotment status finalized',
            isCompleted: basisStatus == 'completed',
            isActive: isBasisActive,
            colors: colors,
            textTheme: textTheme,
          ),
          _buildTimelineItem(
            context: context,
            label: 'Refund Initiation',
            date: refundDate,
            subtitle: 'Refunds processed',
            isCompleted: refundStatus == 'completed',
            isActive: isRefundActive,
            colors: colors,
            textTheme: textTheme,
          ),
          _buildTimelineItem(
            context: context,
            label: 'Shares to Demat',
            date: creditDate,
            subtitle: 'Shares credited',
            isCompleted: creditStatus == 'completed',
            isActive: isCreditActive,
            colors: colors,
            textTheme: textTheme,
          ),
          _buildTimelineItem(
            context: context,
            label: 'Listing Date',
            date: listingDate,
            subtitle: 'Shares start trading',
            isCompleted: listingStatus == 'completed',
            isActive: isListingActive,
            colors: colors,
            textTheme: textTheme,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required BuildContext context,
    required String label,
    required String date,
    required String subtitle,
    required bool isCompleted,
    required bool isActive,
    required AppColorsExtension colors,
    required TextTheme textTheme,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted
                    ? colors.secondary
                    : isActive
                    ? colors.primary
                    : colors.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted
                      ? colors.secondary
                      : isActive
                      ? colors.primary
                      : colors.border,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? Icon(Icons.check, size: 14, color: Colors.white)
                  : isActive
                  ? Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: colors.textTertiary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.textTertiary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialSnapshot(
    BuildContext context,
    IpoItem ipo,
    Color cardColor,
  ) {
    final colors = Theme.of(context).appColors;
    final textTheme = Theme.of(context).textTheme;

    final financialData =
        ipo.companyFinancialInformationRestatedConsolidated ?? [];

    if (financialData.isEmpty) {
      return const SizedBox.shrink();
    }

    // Extract available periods from first row
    final periods = <String, String Function(FinancialMetricRow)>{};
    if (financialData.first.d31Mar2023 != null)
      periods['Mar 2023'] = (row) => row.d31Mar2023 ?? '—';
    if (financialData.first.d31Mar2024 != null)
      periods['Mar 2024'] = (row) => row.d31Mar2024 ?? '—';
    if (financialData.first.d31Mar2025 != null)
      periods['Mar 2025'] = (row) => row.d31Mar2025 ?? '—';
    if (financialData.first.d31Aug2025 != null)
      periods['Aug 2025'] = (row) => row.d31Aug2025 ?? '—';
    if (financialData.first.d30Sep2025 != null)
      periods['Sep 2025'] = (row) => row.d30Sep2025 ?? '—';

    if (periods.isEmpty) {
      return const SizedBox.shrink();
    }

    // Key metrics to display - use case-insensitive partial matching
    final keyMetrics = [
      'Total Assets',
      'Equity',
      'Share Capital',
      'Reserves',
      'Surplus',
      'Revenue',
      'EBITDA',
      'Profit After Tax',
      'PAT',
      'EPS',
      'Net Worth',
      'NAV',
      'Total Income',
      'Operating Revenue',
      'Borrowing',
      'Debt',
      'Total Liabilities',
      'Current Assets',
      'Fixed Assets',
      'Cash',
      'Retained Earnings',
    ];

    // Filter data to show only key metrics - more flexible matching
    final displayData = financialData.where((row) {
      final metric = row.metric?.trim().toLowerCase() ?? '';
      if (metric.isEmpty) return false;

      return keyMetrics.any((key) {
        final keyLower = key.toLowerCase();
        return metric.contains(keyLower) ||
            (key == 'Equity' &&
                (metric.contains('total equity') ||
                    metric.contains('shareholders') ||
                    metric.contains('equity share capital'))) ||
            (key == 'Revenue' &&
                (metric.contains('revenue') ||
                    metric.contains('income from operations') ||
                    metric.contains('total revenue'))) ||
            (key == 'Total Assets' && metric.contains('asset')) ||
            (key == 'Borrowing' &&
                (metric.contains('borrowing') ||
                    metric.contains('loan') ||
                    metric.contains('total debt'))) ||
            (key == 'Reserves' &&
                (metric.contains('reserve') ||
                    metric.contains('retained earning')));
      });
    }).toList();

    if (displayData.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
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
              Icon(Icons.bar_chart_rounded, size: 20, color: colors.secondary),
              const SizedBox(width: 8),
              Text(
                'FINANCIAL SNAPSHOT (CR.)',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Horizontal scrollable table
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    SizedBox(
                      width: 160,
                      child: Text(
                        'METRIC',
                        style: textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colors.textTertiary,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    ...periods.keys.map((period) {
                      final isLatest = period == periods.keys.last;
                      return Container(
                        width: 90,
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          period,
                          textAlign: TextAlign.right,
                          style: textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: isLatest
                                ? colors.secondary
                                : colors.textTertiary,
                            letterSpacing: 1.0,
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 2,
                  width: 160 + (periods.length * 90.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colors.border,
                        colors.secondary.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Data Rows
                ...displayData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final row = entry.value;
                  final isLast = index == displayData.length - 1;
                  final metric = _formatMetricName(row.metric ?? '—');
                  final isProfitMetric =
                      metric.contains('Profit') ||
                      metric.contains('PAT') ||
                      metric.contains('EPS');
                  final isRevenueMetric =
                      metric.contains('Revenue') || metric.contains('EBITDA');

                  return Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 160,
                          child: Text(
                            metric,
                            style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        ...periods.entries.map((periodEntry) {
                          final isLatest = periodEntry.key == periods.keys.last;
                          final value = periodEntry.value(row);
                          final numValue = _parseAmount(value);

                          return Container(
                            width: 90,
                            padding: const EdgeInsets.only(left: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  value,
                                  textAlign: TextAlign.right,
                                  style: textTheme.bodySmall?.copyWith(
                                    fontWeight: isLatest
                                        ? FontWeight.w800
                                        : FontWeight.w600,
                                    color: isLatest && isProfitMetric
                                        ? colors.profit
                                        : isLatest && isRevenueMetric
                                        ? colors.primary
                                        : isLatest
                                        ? colors.textPrimary
                                        : colors.textSecondary,
                                  ),
                                ),
                                if (isLatest && numValue > 0)
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    height: 3,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: isProfitMetric
                                          ? colors.profit
                                          : isRevenueMetric
                                          ? colors.secondary
                                          : colors.secondary,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),

          // Growth indicator
          if (displayData.length > 1) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: colors.secondary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.trending_up, size: 16, color: colors.secondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'YoY growth shown for latest period',
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.secondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatMetricName(String metric) {
    // Remove "Restated and Consolidated" and other verbose text
    return metric
        .replaceAll('Restated and Consolidated', '')
        .replaceAll('  ', ' ')
        .trim();
  }

  Widget _buildShareAllocation(
    BuildContext context,
    IpoItem ipo,
    Color cardColor,
  ) {
    final allocations = ipo.ipoShareAllocation ?? [];
    if (allocations.isEmpty) {
      return const SizedBox.shrink();
    }

    return ShareAllocationCard(allocations: allocations, cardColor: cardColor);
  }

  Widget _buildCompanyHeader(
    BuildContext context,
    IpoItem ipo,
    Color cardColor,
  ) {
    final colors = Theme.of(context).appColors;
    final textTheme = Theme.of(context).textTheme;
    final selfPeer = _findSelfPeer(ipo);
    final ronw = selfPeer?.roNW ?? '—';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company Logo
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: ipo.companyLogoUrl != null
                ? CachedNetworkImage(
                    imageUrl: ipo.companyLogoUrl!,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Center(
                      child: Text(
                        '₹',
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colors.textTertiary,
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      '₹',
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.textTertiary,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ipo.companyFullNameNew ?? 'IPO Company',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                ipo.companySectorInfo?.sector ?? 'Business',
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colors.textTertiary,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colors.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: colors.secondary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        ipo.apiIpoStatusFormatted ?? 'Open',
                        style: textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colors.secondary,
                          fontSize: 10,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primaryVariant.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: colors.primaryVariant.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        'RoNW: $ronw',
                        style: textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colors.textSecondary,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGmpTrendCard(
    BuildContext context,
    IpoItem ipo,
    List<GmpTrendHistory> gmpTrend,
    Color cardColor,
  ) {
    return GmpTrendCard(ipo: ipo, gmpTrend: gmpTrend, cardColor: cardColor);
  }

  Widget _buildFinalSubscriptionCard(
    BuildContext context,
    IpoItem ipo,
    Color cardColor,
  ) {
    final colors = Theme.of(context).appColors;
    final daywise = ipo.ipoDaywiseSubscriptionTable?.daywiseData;
    if (daywise == null || daywise.isEmpty) {
      return const SizedBox.shrink();
    }

    final latest = daywise.last;
    final qib = latest.qibRatio;
    final nii = latest.niiRatio;
    final rii = latest.riiRatio;
    final total = latest.totalRatio;
    final maxValue = [qib, nii, rii].whereType<double>().fold<double>(
      0,
      (current, value) => max(current, value),
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'FINAL SUBSCRIPTION',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.textPrimary,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(width: 8),
              if (total != null)
                Text(
                  '(${total.toStringAsFixed(1)}x)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.secondary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSubscriptionRow(
            context: context,
            label: 'QIB (Qualified Inst.)',
            value: qib,
            maxValue: maxValue,
            barColor: const Color(0xFF6EE7B7),
          ),
          const SizedBox(height: 12),
          _buildSubscriptionRow(
            context: context,
            label: 'NII (Non-Inst.)',
            value: nii,
            maxValue: maxValue,
            barColor: const Color(0xFF7DD3FC),
          ),
          const SizedBox(height: 12),
          _buildSubscriptionRow(
            context: context,
            label: 'Retail Individual',
            value: rii,
            maxValue: maxValue,
            barColor: const Color(0xFF93C5FD),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionRow({
    required BuildContext context,
    required String label,
    required double? value,
    required double maxValue,
    required Color barColor,
  }) {
    final ratio = maxValue == 0 ? 0 : (value ?? 0) / maxValue;
    final colors = Theme.of(context).appColors;
    final trackColor = colors.surface;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.textSecondary,
                ),
              ),
            ),
            Text(
              value == null ? '—' : '${value.toStringAsFixed(1)}x',
              style: textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: trackColor,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: constraints.maxWidth * ratio.clamp(0, 1),
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPeerComparison(
    BuildContext context,
    IpoItem ipo,
    List<PeerComparisonRow> rows,
    Color cardColor,
  ) {
    return PeerComparisonCard(ipo: ipo, rows: rows, cardColor: cardColor);
  }

  Widget _buildObjectives(
    BuildContext context,
    List<IpoObjective> objectives,
    Color cardColor,
  ) {
    if (objectives.isEmpty) {
      return const SizedBox.shrink();
    }

    final colors = Theme.of(context).appColors;
    final textTheme = Theme.of(context).textTheme;
    final totalAmount = objectives.fold<double>(
      0,
      (sum, item) => sum + _parseAmount(item.amount),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'OBJECTS OF ISSUE',
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: colors.textPrimary,
                letterSpacing: 0.6,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Total: ₹${totalAmount.toStringAsFixed(2)} Cr',
                style: textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.textTertiary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          children: objectives.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final amount = _parseAmount(item.amount);
            final ratio = totalAmount == 0 ? 0 : amount / totalAmount;
            final color = _objectiveColors[index % _objectiveColors.length];
            final icon = _objectiveIcons[index % _objectiveIcons.length];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.object ?? 'Objective',
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            minHeight: 6,
                            value: ratio.clamp(0, 1).toDouble(),
                            backgroundColor: colors.textPrimary.withValues(
                              alpha: 0.1,
                            ),
                            valueColor: AlwaysStoppedAnimation<Color>(color),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        item.amount ?? '—',
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStrengths(
    BuildContext context,
    List<String> strengths,
    Color cardColor,
  ) {
    if (strengths.isEmpty) {
      return const SizedBox.shrink();
    }

    final colors = Theme.of(context).appColors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INVESTMENT STRENGTHS',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: strengths.asMap().entries.map((entry) {
              final index = entry.key;
              final text = entry.value;
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == strengths.length - 1 ? 0 : 16,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: colors.secondary.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.verified,
                        size: 18,
                        color: colors.secondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        text,
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildContactAndSupport(
    BuildContext context,
    IpoItem ipo,
    Color cardColor,
  ) {
    final colors = Theme.of(context).appColors;
    final textTheme = Theme.of(context).textTheme;
    final companyAddress = ipo.companyAddress;
    final registrar = ipo.ipoRegistrar;
    final leadManagers = ipo.ipoLeadManager ?? [];

    // Check if we have any data to display
    if (companyAddress == null && registrar == null && leadManagers.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CONTACT & SUPPORT',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 24),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column - Company HQ
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (companyAddress != null) ...[
                      Text(
                        'COMPANY HQ',
                        style: textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colors.textTertiary,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (companyAddress.name != null &&
                          companyAddress.name!.isNotEmpty) ...[
                        Text(
                          companyAddress.name!,
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (companyAddress.address != null &&
                          companyAddress.address!.isNotEmpty) ...[
                        Text(
                          companyAddress.address!,
                          style: textTheme.bodySmall?.copyWith(
                            color: colors.textSecondary,
                            fontWeight: FontWeight.w300,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (companyAddress.email != null &&
                          companyAddress.email!.isNotEmpty) ...[
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: colors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.email_outlined,
                                size: 14,
                                color: colors.secondary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                companyAddress.email == ":"
                                    ? "Not Available"
                                    : companyAddress.email!,
                                style: textTheme.bodySmall?.copyWith(
                                  color: colors.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                      if (companyAddress.website != null &&
                          companyAddress.website!.isNotEmpty) ...[
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: colors.surface.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.language,
                                size: 14,
                                color: colors.textTertiary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                               ipo.companySectorInfo?.website.toString() ?? 'Not Available',
                                style: textTheme.bodySmall?.copyWith(
                                  fontSize: 10,
                                  color: colors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                    const SizedBox(height: 12),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Right Column - Registrar & Lead Manager
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Registrar
                    if (registrar != null) ...[
                      Text(
                        'REGISTRAR',
                        style: textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colors.textTertiary,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (registrar.name != null &&
                          registrar.name!.isNotEmpty) ...[
                        Text(
                          registrar.name!,
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (registrar.address != null &&
                          registrar.address!.isNotEmpty) ...[
                        Text(
                          registrar.address!,
                          style: textTheme.bodySmall?.copyWith(
                            color: colors.textSecondary,
                            fontWeight: FontWeight.w300,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (registrar.email != null &&
                          registrar.email!.isNotEmpty) ...[
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: colors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.web,
                                size: 14,
                                color: colors.secondary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: RichText(
                                
                                text: TextSpan(
                                text: registrar.website ?? 'Not Available',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colors.textSecondary,
                                  fontWeight: FontWeight.w300,
                               ) ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                      ],
                    ],

                    // Lead Manager
                  ],
                ),
              ),
            ],
          ),
          if (leadManagers.isNotEmpty) ...[
            Text(
              'LEAD MANAGER',
              style: textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: colors.textTertiary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            if (leadManagers.isNotEmpty &&
                leadManagers.first.toString().isNotEmpty) ...[
              Text(
                leadManagers.first.toString(),
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          color: colors.background.withValues(alpha: 0.95),
          border: Border(top: BorderSide(color: colors.border)),
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.notifications_active, size: 18),
                label: const Text('Set Alert'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primaryVariant,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.border),
              ),
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.bookmark, color: colors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PeerComparisonRow? _findSelfPeer(IpoItem ipo) {
    final rows = ipo.peerComparison ?? [];
    for (final row in rows) {
      if (_isSameCompany(row.company, ipo.apiCompanyName)) {
        return row;
      }
    }
    return null;
  }

  bool _isSameCompany(String? a, String? b) {
    if (a == null || b == null) return false;
    return a.toLowerCase().contains(b.toLowerCase()) ||
        b.toLowerCase().contains(a.toLowerCase());
  }

  String _formatTitle(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'IPO LENS';
    return trimmed.toUpperCase();
  }

  String? _stringValue(dynamic raw) {
    if (raw == null) return null;
    final value = raw.toString().trim();
    return value.isEmpty ? null : value;
  }

  String _formatPriceBand(IpoItem ipo) {
    final raw =
        _stringValue(ipo.apiPrice) ??
        _stringValue(ipo.lotIssuePrice) ??
        _stringValue(ipo.maxIpoPrice) ??
        '—';
    if (raw == '—') return raw;
    if (raw.contains('₹')) return raw;
    return '₹$raw';
  }

  double? _parsePercent(String? raw) {
    if (raw == null) return null;
    final cleaned = raw.replaceAll(RegExp(r'[^0-9\.]'), '');
    if (cleaned.isEmpty) return null;
    return double.tryParse(cleaned);
  }

  int _gmpStrengthBars(double? percent) {
    if (percent == null) return 2;
    if (percent >= 20) return 4;
    if (percent >= 10) return 3;
    if (percent >= 5) return 2;
    if (percent >= 1) return 1;
    return 0;
  }

  double _parseAmount(String? raw) {
    if (raw == null) return 0;
    final cleaned = raw.replaceAll(RegExp(r'[^0-9\.]'), '');
    if (cleaned.isEmpty) return 0;
    return double.tryParse(cleaned) ?? 0;
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

  List<Color> get _objectiveColors => [
    const Color(0xFF6366F1),
    const Color(0xFF10B981),
    const Color(0xFFF59E0B),
    const Color(0xFF3B82F6),
  ];

  List<IconData> get _objectiveIcons => [
    Icons.factory,
    Icons.account_balance_wallet,
    Icons.insights,
    Icons.apartment,
  ];

  DateTime? _parseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      // Try parsing ISO format: 2026-01-16
      return DateTime.parse(dateStr);
    } catch (e) {
      return null;
    }
  }

  String _formatDisplayDate(DateTime? date) {
    if (date == null) return '—';
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final day = date.day;
    final suffix = _getDaySuffix(day);
    return '$day$suffix ${months[date.month - 1]} ${date.year}';
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1: return 'st';
      case 2: return 'nd';
      case 3: return 'rd';
      default: return 'th';
    }
  }

  String _getEventStatus(DateTime? eventDate, DateTime today) {
    if (eventDate == null) return 'unknown';
    
    if (eventDate.isBefore(today)) {
      return 'completed';
    } else if (eventDate.isAtSameMomentAs(today)) {
      return 'active';
    } else {
      return 'upcoming';
    }
  }
}
