import 'package:flutter/material.dart';
import 'package:ipo_lens/core/services/app_update_service.dart';

/// Widget that checks for app updates on initialization
class UpdateChecker extends StatefulWidget {
  final Widget child;

  const UpdateChecker({
    super.key,
    required this.child,
  });

  @override
  State<UpdateChecker> createState() => _UpdateCheckerState();
}

class _UpdateCheckerState extends State<UpdateChecker> {
  final AppUpdateService _updateService = AppUpdateService();
  bool _hasChecked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForUpdates();
    });
  }

  Future<void> _checkForUpdates() async {
    if (_hasChecked) return;
    _hasChecked = true;

    // Wait for navigation to be ready (go_router needs more time)
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    try {
      // Verify Navigator is available
      final navigator = Navigator.maybeOf(context);
      if (navigator == null) {
        debugPrint('❌ Navigator not ready yet, skipping update check');
        return;
      }

      // Check if in maintenance mode first
      if (_updateService.isMaintenanceMode) {
        _showMaintenanceDialog();
        return;
      }

      // Check for updates
      final updateType = await _updateService.checkForUpdate();

      if (updateType != UpdateType.none && mounted) {
        await _updateService.showUpdateDialog(
          context,
          updateType: updateType,
        );
      }
    } catch (e) {
      debugPrint('❌ Error checking for updates: $e');
    }
  }

  void _showMaintenanceDialog() {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.construction_rounded,
                color: Colors.orange,
                size: 28,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Under Maintenance',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _updateService.maintenanceMessage,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
