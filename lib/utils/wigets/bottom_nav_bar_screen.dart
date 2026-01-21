import 'package:flutter/material.dart';
import 'package:ipo_lens/core/services/app_update_service.dart';
import 'package:ipo_lens/core/widgets/maintenance_screen.dart';
import 'package:ipo_lens/features/bids/screens/bid_screen.dart';
import 'package:ipo_lens/features/open-ipos/Screens/open_ipos_screen.dart';
import 'package:ipo_lens/features/settings/screens/settings_screen.dart';
import 'package:ipo_lens/utils/providers/bottom_nav_provider.dart';
import 'package:ipo_lens/utils/theme/theme_extensions.dart';
import 'package:provider/provider.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  bool _hasCheckedForUpdates = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForUpdates();
    });
  }

  Future<void> _checkForUpdates() async {
    if (_hasCheckedForUpdates) return;
    _hasCheckedForUpdates = true;

    // Wait a bit for UI to settle
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    try {
      final updateService = AppUpdateService();

      // Check if in maintenance mode first
      if (updateService.isMaintenanceMode) {
        _showMaintenanceDialog(updateService);
        return;
      }

      // Check for updates
      final updateType = await updateService.checkForUpdate();

      if (updateType != UpdateType.none && mounted) {
        await updateService.showUpdateDialog(
          context,
          updateType: updateType,
        );
      }
    } catch (e) {
      debugPrint('❌ Error checking for updates: $e');
    }
  }

  void _showMaintenanceDialog(AppUpdateService updateService) {
    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => MaintenanceScreen(
          message: updateService.maintenanceMessage,
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = const [OpenIposScreen(), BidScreen(), SettingsScreen()];

    return Scaffold(
      body: Consumer<BottomNavProvider>(
        builder: (context, nav, _) {
          return IndexedStack(index: nav.index, children: screens);
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).appColors.card,
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).appColors.textPrimary.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Consumer<BottomNavProvider>(
              builder: (context, nav, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      context,
                      icon: Icons.local_fire_department_rounded,
                      label: 'IPOs',
                      index: 0,
                      currentIndex: nav.index,
                      onTap: () => nav.setIndex(0),
                    ),
                    _buildNavItem(
                      context,
                      icon: Icons.gavel_rounded,
                      label: 'Bids',
                      index: 1,
                      currentIndex: nav.index,
                      onTap: () => nav.setIndex(1),
                    ),
                    _buildNavItem(
                      context,
                      icon: Icons.settings_rounded,
                      label: 'Settings',
                      index: 2,
                      currentIndex: nav.index,
                      onTap: () => nav.setIndex(2),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required int currentIndex,
    required VoidCallback onTap,
  }) {
    final isSelected = currentIndex == index;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).appColors.secondary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).appColors.secondary
                  : Theme.of(context).appColors.textSecondary,
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).appColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
