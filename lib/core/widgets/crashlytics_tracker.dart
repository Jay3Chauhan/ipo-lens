import 'package:flutter/material.dart';
import 'package:ipo_lens/core/services/crashlytics_service.dart';

/// Wrapper widget to automatically track screen views in Crashlytics
/// 
/// Usage:
/// ```dart
/// class MyScreen extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return CrashlyticsScreenTracker(
///       screenName: 'IPO Details',
///       child: Scaffold(...),
///     );
///   }
/// }
/// ```
class CrashlyticsScreenTracker extends StatefulWidget {
  final String screenName;
  final Widget child;
  final Map<String, dynamic>? metadata;

  const CrashlyticsScreenTracker({
    super.key,
    required this.screenName,
    required this.child,
    this.metadata,
  });

  @override
  State<CrashlyticsScreenTracker> createState() => _CrashlyticsScreenTrackerState();
}

class _CrashlyticsScreenTrackerState extends State<CrashlyticsScreenTracker> {
  @override
  void initState() {
    super.initState();
    _trackScreenView();
  }

  Future<void> _trackScreenView() async {
    // Log navigation event
    await CrashlyticsService().logNavigation(widget.screenName);
    
    // Set current screen as custom key
    await CrashlyticsService().setCustomKey('current_screen', widget.screenName);
    
    // Add any additional metadata
    if (widget.metadata != null) {
      await CrashlyticsService().setCustomKeys(widget.metadata!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Extension method for easy error handling with Crashlytics
extension CrashlyticsFuture<T> on Future<T> {
  /// Catches errors and logs them to Crashlytics
  /// 
  /// Usage:
  /// ```dart
  /// await fetchData().catchWithCrashlytics('Failed to fetch data');
  /// ```
  Future<T?> catchWithCrashlytics(String reason, {bool shouldRethrow = false}) async {
    try {
      return await this;
    } catch (e, stack) {
      await CrashlyticsService().logError(e, stack, reason: reason);
      if (shouldRethrow) {
        rethrow;
      }
      return null;
    }
  }
}

/// Mixin for tracking widget lifecycle in Crashlytics
/// 
/// Usage:
/// ```dart
/// class MyWidget extends StatefulWidget with CrashlyticsLifecycleMixin {
///   @override
///   String get screenName => 'My Widget';
/// }
/// ```
mixin CrashlyticsLifecycleMixin<T extends StatefulWidget> on State<T> {
  String get screenName;

  @override
  void initState() {
    super.initState();
    _logLifecycle('initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _logLifecycle('didChangeDependencies');
  }

  @override
  void dispose() {
    _logLifecycle('dispose');
    super.dispose();
  }

  Future<void> _logLifecycle(String event) async {
    await CrashlyticsService().log('$screenName: $event');
  }
}
