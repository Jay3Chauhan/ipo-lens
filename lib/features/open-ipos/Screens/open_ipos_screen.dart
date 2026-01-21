import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ipo_lens/core/routes/app_routes.dart';
import 'package:ipo_lens/features/open-ipos/Provider/open_ipos_provider.dart';
import 'package:ipo_lens/features/open-ipos/Models/open_ipo_models.dart';
import 'package:ipo_lens/utils/theme/theme_extensions.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OpenIposScreen extends StatefulWidget {
  const OpenIposScreen({super.key});

  @override
  State<OpenIposScreen> createState() => _OpenIposScreenState();
}

class _OpenIposScreenState extends State<OpenIposScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<OpenIposProvider>();
      provider.fetch();
      provider.fetchUpcoming();
      provider.fetchClosed();
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).appColors;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: c.background,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(130),
          child: Container(
            decoration: BoxDecoration(
              color: c.card,
              border: Border(
                bottom: BorderSide(color: c.border.withValues(alpha: 0.5), width: 1),
              ),
              boxShadow: [
                BoxShadow(
                  color: c.shadow.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              surfaceTintColor: Colors.transparent,
              titleSpacing: 16,
              toolbarHeight: 64,
              title: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [c.secondary, c.secondary.withValues(alpha: 0.8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: c.secondary.withValues(alpha: 0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.grid_view_rounded,
                      size: 22,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'IPO LENS',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: c.textPrimary,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'Live Market Data',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: c.textSecondary,
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: const [
                _ActionIcon(icon: Icons.search_rounded),
                SizedBox(width: 10),
                _ActionIcon(icon: Icons.notifications_none_rounded),
                SizedBox(width: 16),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: c.cardSecondary,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: c.border, width: 1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: TabBar(
                      isScrollable: false,
                      indicator: BoxDecoration(
                        color: c.secondary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      indicatorPadding: const EdgeInsets.all(4),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelColor: Colors.white,
                      unselectedLabelColor: c.textSecondary,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 2),
                      labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                      unselectedLabelStyle:
                          Theme.of(context).textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                      tabs: const [
                        Tab(text: 'All'),
                        Tab(text: 'Open'),
                        Tab(text: 'Upcoming'),
                        Tab(text: 'Closed'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: const _FilterFab(),
        body: Consumer<OpenIposProvider>(
          builder: (context, provider, _) {
            return TabBarView(
              children: [
                _buildTabContent(context, provider, _IpoTab.all),
                _buildTabContent(context, provider, _IpoTab.open),
                _buildTabContent(context, provider, _IpoTab.upcoming),
                _buildTabContent(context, provider, _IpoTab.closed),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabContent(
    BuildContext context,
    OpenIposProvider provider,
    _IpoTab tab,
  ) {
    final c = Theme.of(context).appColors;

    final items = switch (tab) {
      _IpoTab.all => [
          ...provider.items,
          ...provider.upcomingItems,
          ...provider.closedItems,
        ],
      _IpoTab.open => provider.items,
      _IpoTab.upcoming => provider.upcomingItems,
      _IpoTab.closed => provider.closedItems,
    };

    final isLoading = switch (tab) {
      _IpoTab.all =>
        provider.isLoading &&
            provider.items.isEmpty &&
            provider.upcomingItems.isEmpty &&
            provider.closedItems.isEmpty,
      _IpoTab.open => provider.isLoading,
      _IpoTab.upcoming => provider.isLoadingUpcoming,
      _IpoTab.closed => provider.isLoadingClosed,
    };

    final error = switch (tab) {
      _IpoTab.all =>
        provider.error ?? provider.errorUpcoming ?? provider.errorClosed,
      _IpoTab.open => provider.error,
      _IpoTab.upcoming => provider.errorUpcoming,
      _IpoTab.closed => provider.errorClosed,
    };

    final onRefresh = switch (tab) {
      _IpoTab.all => () async {
          await Future.wait([
            provider.refresh(),
            provider.refreshUpcoming(),
            provider.refreshClosed(),
          ]);
        },
      _IpoTab.open => provider.refresh,
      _IpoTab.upcoming => provider.refreshUpcoming,
      _IpoTab.closed => provider.refreshClosed,
    };

    return RefreshIndicator(
      color: c.secondary,
      backgroundColor: c.card,
      strokeWidth: 2.5,
      onRefresh: onRefresh,
      child: Skeletonizer(
        enabled: isLoading && items.isEmpty,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
          children: [
            _LiveHeader(openItems: provider.items, tab: tab),
            const SizedBox(height: 16),
            const _FilterChipsRow(),
            const SizedBox(height: 20),
            if (error != null && items.isEmpty)
              _ErrorState(error: error, onRetry: onRefresh)
            else if (items.isEmpty && isLoading)
              ...List.generate(
                4,
                (_) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _ScreenerIpoCard.skeleton(),
                ),
              )
            else if (items.isEmpty)
              const _EmptyState()
            else
              ...items.map(
                (ipo) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _ScreenerIpoCard(
                    ipo: ipo,
                    status: _statusForTab(tab, ipo),
                    onTap: () {
                      if (ipo.id != null) {
                        context.push(AppRoutes.openIpoDetails(ipo.id!));
                      }
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CompanyLogo extends StatelessWidget {
  final String? url;

  const _CompanyLogo({required this.url});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).appColors;

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: c.cardSecondary,
        border: Border.all(color: c.border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: c.shadow.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: (url == null || url!.isEmpty)
          ? Center(
              child: Text(
                '₹',
                style: TextStyle(
                  color: c.textTertiary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          : CachedNetworkImage(
              imageUrl: url!,
              fit: BoxFit.cover,
              placeholder: (_, __) => Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(c.secondary),
                  ),
                ),
              ),
              errorWidget: (_, __, ___) => Center(
                child: Text(
                  '₹',
                  style: TextStyle(
                    color: c.textTertiary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
    );
  }
}

enum _IpoTab { all, open, upcoming, closed }

enum _IpoStatus { open, upcoming, closed }

_IpoStatus _statusForTab(_IpoTab tab, IpoItem ipo) {
  return switch (tab) {
    _IpoTab.open => _IpoStatus.open,
    _IpoTab.upcoming => _IpoStatus.upcoming,
    _IpoTab.closed => _IpoStatus.closed,
    _IpoTab.all => _inferStatus(ipo),
  };
}

_IpoStatus _inferStatus(IpoItem ipo) {
  final status = (ipo.apiIpoStatus ?? '').toLowerCase();
  final formatted = (ipo.apiIpoStatusFormatted ?? '').toLowerCase();
  if (status.contains('open') || formatted.contains('open')) {
    return _IpoStatus.open;
  }
  if (status.contains('upcoming') || formatted.contains('upcoming')) {
    return _IpoStatus.upcoming;
  }
  if (status.contains('listed') || status.contains('closed')) {
    return _IpoStatus.closed;
  }
  return _IpoStatus.open;
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;

  const _ActionIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).appColors;

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: c.cardSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.border, width: 1),
      ),
      child: Icon(icon, size: 20, color: c.textPrimary),
    );
  }
}

class _FilterFab extends StatelessWidget {
  const _FilterFab();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).appColors;

    return FloatingActionButton.extended(
      onPressed: () {
        // Filter functionality can be added here
      },
      backgroundColor: c.secondary,
      foregroundColor: Colors.white,
      elevation: 4,
      icon: const Icon(Icons.tune_rounded, size: 20),
      label: Text(
        'Filter',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 15,
            ),
      ),
    );
  }
}

class _LiveHeader extends StatelessWidget {
  final List<IpoItem> openItems;
  final _IpoTab tab;

  const _LiveHeader({required this.openItems, required this.tab});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).appColors;
    final textTheme = Theme.of(context).textTheme;

    final mainboardCount = openItems.where((item) {
      final category = (item.apiIpoCategory ?? '').toLowerCase();
      return category.contains('main');
    }).length;
    final smeCount = openItems.where((item) {
      final category = (item.apiIpoCategory ?? '').toLowerCase();
      return category.contains('sme');
    }).length;

    final subtitle = switch (tab) {
      _IpoTab.open => _buildLiveSubtitle(openItems, mainboardCount, smeCount),
      _IpoTab.all => _buildLiveSubtitle(openItems, mainboardCount, smeCount),
      _IpoTab.upcoming => 'Upcoming IPOs to watch',
      _IpoTab.closed => 'Recently listed and closed IPOs',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Live Screener',
          style: textTheme.titleLarge?.copyWith(
            color: c.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: textTheme.bodyMedium?.copyWith(
            color: c.textSecondary,
            fontWeight: FontWeight.w500,
         
          ),
        ),
      ],
    );
  }

  String _buildLiveSubtitle(
    List<IpoItem> openItems,
    int mainboardCount,
    int smeCount,
  ) {
    if (mainboardCount > 0 || smeCount > 0) {
      return '$mainboardCount Mainboard & $smeCount SME IPOs actively trading';
    }
    return '${openItems.length} IPOs actively trading';
  }
}

class _FilterChipsRow extends StatelessWidget {
  const _FilterChipsRow();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: const [
          _FilterChip(
            label: 'Mainboard',
            trailing: Icons.keyboard_arrow_down_rounded,
          ),
          SizedBox(width: 10),
          _FilterChip(
            label: 'SME',
            trailing: Icons.keyboard_arrow_down_rounded,
          ),
          SizedBox(width: 10),
          _FilterChip(
            label: 'GMP > 20%',
            leading: Icons.local_fire_department_rounded,
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData? leading;
  final IconData? trailing;

  const _FilterChip({
    required this.label,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).appColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: c.shadow.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[
            Icon(leading, size: 18, color: c.warning),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: c.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 6),
            Icon(trailing, size: 20, color: c.textSecondary),
          ],
        ],
      ),
    );
  }
}

class _ScreenerIpoCard extends StatelessWidget {
  final IpoItem ipo;
  final _IpoStatus status;
  final VoidCallback? onTap;

  const _ScreenerIpoCard({
    required this.ipo,
    required this.status,
    this.onTap,
  });

  _ScreenerIpoCard.skeleton({
    IpoItem? ipo,
    this.status = _IpoStatus.open,
    this.onTap,
  }) : ipo = ipo ??
            IpoItem(
              id: '0',
              apiCompanyName: 'Loading Company Name',
              apiGmpValue: 0,
              apiSubscription: '0.0x',
              apiLot: '100',
              apiPrice: '₹100 - ₹120',
            );

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).appColors;
    final textTheme = Theme.of(context).textTheme;

    final name = ipo.apiCompanyName ??
        ipo.companyFullName ??
        ipo.companyFullNameScraped ??
        'IPO Company';

    final badge = _statusBadge(context, status);
    final subline = _buildSubline(status, ipo);
    final priceBand = _stringValue(ipo.apiPrice) ??
        _stringValue(ipo.ipoIssuePriceTable) ??
        _stringValue(ipo.lotIssuePrice) ??
        '—';
print(priceBand);
    final gmpValue = ipo.apiGmpValue;
    final gmpPercent = ipo.apiGmpPercent;
    final hasGmp = gmpValue != null && gmpValue > 0;

    final subscriptionValue = _stringValue(ipo.apiSubscription) ?? '—';
    final subscriptionRatio = _parseSubscriptionRatio(subscriptionValue);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: c.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: c.border, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: c.shadow.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CompanyLogo(url: ipo.companyLogoUrl),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.titleSmall?.copyWith(
                                  color: c.textPrimary,
                                  fontWeight: FontWeight.w700,
                           
                                 
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            badge,
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subline,
                          style: textTheme.bodySmall?.copyWith(
                            color: c.textSecondary,
                            fontWeight: FontWeight.w500,
                     
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: c.cardSecondary,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: c.border),
                    ),
                    child: Icon(
                      Icons.bookmark_border_rounded,
                      color: c.textSecondary,
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _InfoTile(
                      title: 'Price Band',
                      value: priceBand.replaceAll('Per Share', ""),
                      caption: _stringValue(ipo.apiLot) != null
                          ? 'Lot: ${_stringValue(ipo.apiLot)} Shares'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _InfoTile(
                      title: 'GMP (EST. GAIN)',
                      value: hasGmp ? '+₹$gmpValue' : 'Not Active',
                      caption: hasGmp && gmpPercent != null
                          ? '${gmpPercent > 0 ? '+' : ''}${gmpPercent.toStringAsFixed(0)}% Expected'
                          : 'Low Demand',
                      valueColor: hasGmp ? c.profit : c.textTertiary,
                      captionColor: hasGmp ? c.profit : c.textTertiary,
                      leadingIcon: hasGmp
                          ? Icons.local_fire_department_rounded
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subscription (Overall)',
                    style: textTheme.labelMedium?.copyWith(
                      color: c.textSecondary,
                      fontWeight: FontWeight.w600,
                   
                    ),
                  ),
                  Text(
                    subscriptionValue,
                    style: textTheme.labelMedium?.copyWith(
                      color: c.textPrimary,
                      fontWeight: FontWeight.w800,
                    
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _ProgressBar(value: subscriptionRatio),
              // const SizedBox(height: 16),
              // _CardActionButton(status: status, ipo: ipo),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusBadge(BuildContext context, _IpoStatus status) {
    final c = Theme.of(context).appColors;
    final color = switch (status) {
      _IpoStatus.open => c.profit,
      _IpoStatus.upcoming => c.warning,
      _IpoStatus.closed => c.textTertiary,
    };
    final label = switch (status) {
      _IpoStatus.open => 'OPEN',
      _IpoStatus.upcoming => 'UPCOMING',
      _IpoStatus.closed => 'CLOSED',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            fontSize: 8,
              letterSpacing: 0.5,
            ),
      ),
    );
  }

  String _buildSubline(_IpoStatus status, IpoItem ipo) {
    final category = _stringValue(ipo.apiIpoCategory) ?? 'Mainboard';
    return switch (status) {
      _IpoStatus.open =>
        '$category • ${_closesInLabel(_parseDate(ipo.apiIssueCloseDate)) ?? 'Closing soon'}',
      _IpoStatus.upcoming =>
        '$category • Starts ${_stringValue(ipo.apiIssueOpenDate) ?? 'soon'}',
      _IpoStatus.closed =>
        '$category • Listed ${_stringValue(ipo.listingDate) ?? 'recently'}',
    };
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;
  final String? caption;
  final Color? valueColor;
  final Color? captionColor;
  final IconData? leadingIcon;

  const _InfoTile({
    required this.title,
    required this.value,
    this.caption,
    this.valueColor,
    this.captionColor,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).appColors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: c.cardSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.labelSmall?.copyWith(
              color: c.textTertiary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
        
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: 16, color: valueColor ?? c.textPrimary),
                const SizedBox(width: 5),
              ],
              Flexible(flex:12,
                child: Text(
                  value,
                  style: textTheme.titleSmall?.copyWith(
                    color: valueColor ?? c.textPrimary,
                    fontWeight: FontWeight.w600,
                   
                  ),
                  maxLines: 1,
                  
                ),
              ),
            ],
          ),
          if (caption != null) ...[
            const SizedBox(height: 5),
            Text(
              caption!,
              style: textTheme.labelSmall?.copyWith(
                color: captionColor ?? c.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double value;

  const _ProgressBar({required this.value});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).appColors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth * value;
        return Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: c.cardSecondary,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: c.border, width: 1),
              ),
            ),
            Container(
              width: width.clamp(0, constraints.maxWidth),
              height: 8,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [c.profit, c.profit.withValues(alpha: 0.7)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CardActionButton extends StatelessWidget {
  final _IpoStatus status;
  final IpoItem ipo;

  const _CardActionButton({required this.status, required this.ipo});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).appColors;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (ipo.id != null) {
            context.push(AppRoutes.openIpoDetails(ipo.id!));
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: c.secondary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'View Details',
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_rounded,
              size: 18,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String error;
  final Future<void> Function() onRetry;

  const _ErrorState({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).appColors;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.border),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: c.loss.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.error_outline, color: c.loss, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            'Unable to load IPOs',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: c.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: c.textSecondary),
          ),
          const SizedBox(height: 16),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).appColors;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.border),
      ),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, color: c.textTertiary, size: 48),
          const SizedBox(height: 16),
          Text(
            'No IPOs available',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: c.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

double _parseSubscriptionRatio(String value) {
  final cleaned = value.toLowerCase().replaceAll('x', '').trim();
  final parsed = double.tryParse(cleaned);
  if (parsed == null) return 0.0;
  return (parsed / 100).clamp(0.0, 1.0);
}

String? _stringValue(dynamic value) {
  if (value == null) return null;
  if (value is String) return value.isNotEmpty ? value : null;
  return value.toString();
}

DateTime? _parseDate(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) return null;
  try {
    return DateTime.parse(dateStr);
  } catch (_) {
    return null;
  }
}

String? _closesInLabel(DateTime? closeDate) {
  if (closeDate == null) return null;
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final close = DateTime(closeDate.year, closeDate.month, closeDate.day);
  final diff = close.difference(today).inDays;
  if (diff < 0) return null;
  if (diff == 0) return 'Closes today';
  if (diff == 1) return 'Closes tomorrow';
  return 'Closes in $diff days';
}
