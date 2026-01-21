import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ipo_lens/core/services/remote_config_service.dart';
import 'package:ipo_lens/utils/theme/theme_extensions.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

enum UpdateType {
  none,
  flexible, // Optional update
  immediate, // Force update
}

class AppUpdateService {
  static final AppUpdateService _instance = AppUpdateService._internal();
  factory AppUpdateService() => _instance;
  AppUpdateService._internal();

  final RemoteConfigService _remoteConfig = RemoteConfigService();
  PackageInfo? _packageInfo;

  /// Initialize the service
  Future<void> initialize() async {
    try {
      _packageInfo = await PackageInfo.fromPlatform();
      await _remoteConfig.initialize();
    } catch (e) {
      debugPrint('❌ Failed to initialize AppUpdateService: $e');
    }
  }

  /// Get current app version
  String get currentVersion => _packageInfo?.version ?? '1.0.0';

  /// Check what type of update is needed
  Future<UpdateType> checkForUpdate() async {
    try {
      final minVersion = _remoteConfig.minAppVersion;
      final latestVersion = _remoteConfig.latestAppVersion;
      final forceUpdateEnabled = _remoteConfig.isForceUpdateEnabled;

      debugPrint('📱 Current version: $currentVersion');
      debugPrint('📱 Min version: $minVersion');
      debugPrint('📱 Latest version: $latestVersion');
      debugPrint('📱 Force update enabled: $forceUpdateEnabled');

      // Check if current version is below minimum required
      if (_isVersionLower(currentVersion, minVersion)) {
        return UpdateType.immediate;
      }

      // Check if force update is enabled and there's a newer version
      if (forceUpdateEnabled && _isVersionLower(currentVersion, latestVersion)) {
        return UpdateType.immediate;
      }

      // Check if there's a newer version available (optional update)
      if (_isVersionLower(currentVersion, latestVersion)) {
        return UpdateType.flexible;
      }

      return UpdateType.none;
    } catch (e) {
      debugPrint('❌ Error checking for update: $e');
      return UpdateType.none;
    }
  }

  /// Compare two version strings (e.g., "1.2.3" vs "1.3.0")
  bool _isVersionLower(String current, String compare) {
    try {
      final currentParts = current.split('.').map(int.parse).toList();
      final compareParts = compare.split('.').map(int.parse).toList();

      for (int i = 0; i < 3; i++) {
        final currentPart = i < currentParts.length ? currentParts[i] : 0;
        final comparePart = i < compareParts.length ? compareParts[i] : 0;

        if (currentPart < comparePart) return true;
        if (currentPart > comparePart) return false;
      }

      return false; // Versions are equal
    } catch (e) {
      debugPrint('❌ Error comparing versions: $e');
      return false;
    }
  }

  /// Open Play Store or App Store
  Future<void> openStore() async {
    try {
      final packageName = _packageInfo?.packageName ?? 'com.example.ipo_lens';
      
      // Android Play Store URL
      final Uri playStoreUrl = Uri.parse(
        'https://play.google.com/store/apps/details?id=$packageName',
      );

      // iOS App Store URL (replace YOUR_APP_ID with actual App Store ID)
      final Uri appStoreUrl = Uri.parse(
        'https://apps.apple.com/app/idYOUR_APP_ID',
      );

      // Try to launch appropriate store based on platform
      final url = playStoreUrl; // Change to appStoreUrl for iOS

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('❌ Could not launch store URL');
      }
    } catch (e) {
      debugPrint('❌ Error opening store: $e');
    }
  }

  /// Show update dialog
  Future<void> showUpdateDialog(
    BuildContext context, {
    required UpdateType updateType,
  }) async {
    if (updateType == UpdateType.none) return;

    final isForceUpdate = updateType == UpdateType.immediate;
    final message = isForceUpdate
        ? _remoteConfig.forceUpdateMessage
        : _remoteConfig.updateMessage;

    if (!context.mounted) return;

    // Use full screen for better experience
    await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => UpdateScreen(
          title: isForceUpdate ? 'Update Required' : 'New Features Available',
          message: message,
          updateButtonText: _remoteConfig.updateButtonText,
          skipButtonText: _remoteConfig.skipButtonText,
          isForceUpdate: isForceUpdate,
          currentVersion: currentVersion,
          latestVersion: _remoteConfig.latestAppVersion,
          onUpdate: () {
            Navigator.of(context).pop();
            openStore();
          },
          onSkip: isForceUpdate
              ? null
              : () {
                  Navigator.of(context).pop();
                },
        ),
        opaque: false,
        barrierDismissible: !isForceUpdate,
        barrierColor: Colors.black.withValues(alpha: 0.5),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
      ),
    );
  }

  /// Check if app is in maintenance mode
  bool get isMaintenanceMode => _remoteConfig.isMaintenanceMode;

  /// Get maintenance message
  String get maintenanceMessage => _remoteConfig.maintenanceMessage;
}

/// Custom Update Screen Widget with beautiful UI
class UpdateScreen extends StatefulWidget {
  final String title;
  final String message;
  final String updateButtonText;
  final String skipButtonText;
  final bool isForceUpdate;
  final String currentVersion;
  final String latestVersion;
  final VoidCallback onUpdate;
  final VoidCallback? onSkip;

  const UpdateScreen({
    super.key,
    required this.title,
    required this.message,
    required this.updateButtonText,
    required this.skipButtonText,
    required this.isForceUpdate,
    required this.currentVersion,
    required this.latestVersion,
    required this.onUpdate,
    this.onSkip,
  });

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sparkleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _sparkleAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
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

    return PopScope(
      canPop: !widget.isForceUpdate,
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 40,
                              width: 128,
                              decoration: BoxDecoration(
                                color: c.cardSecondary.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            const SizedBox(height: 24),
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
                          // Gift Icon
                          _buildGiftIcon(c),

                          const SizedBox(height: 24),

                          // Title
                          Text(
                            widget.title,
                            style: TextStyle(
                              color: c.textPrimary,
                              fontSize: 22,
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

                          // Version info for force update
                          if (widget.isForceUpdate) ...[
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: c.secondary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: c.secondary.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.info_outline_rounded,
                                    color: c.secondary,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'v${widget.currentVersion} → v${widget.latestVersion}',
                                    style: TextStyle(
                                      color: c.secondary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          const SizedBox(height: 32),

                          // Update Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: widget.onUpdate,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: c.secondary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                widget.updateButtonText,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),

                          // Skip Button (only for flexible updates)
                          if (!widget.isForceUpdate && widget.onSkip != null) ...[
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: widget.onSkip,
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: Text(
                                widget.skipButtonText,
                                style: TextStyle(
                                  color: c.textSecondary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGiftIcon(AppColorsExtension c) {
    return SizedBox(
      width: 96,
      height: 96,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background glow
          Transform.rotate(
            angle: 0.2,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    c.secondary.withValues(alpha: 0.2),
                    c.secondary.withValues(alpha: 0.05),
                  ],
                ),
              ),
            ),
          ),

          // Main gift box
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  c.secondary.withValues(alpha: 0.3),
                  c.secondary.withValues(alpha: 0.15),
                ],
              ),
              border: Border.all(
                color: c.border.withValues(alpha: 0.5),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: c.secondary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Gift icon
                Icon(
                  Icons.redeem_rounded,
                  size: 40,
                  color: c.secondary,
                ),

                // Sparkle
                Positioned(
                  top: -4,
                  right: -4,
                  child: AnimatedBuilder(
                    animation: _sparkleAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _sparkleAnimation.value,
                        child: Icon(
                          Icons.auto_awesome_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                      );
                    },
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
