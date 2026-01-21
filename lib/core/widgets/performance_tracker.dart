import 'package:flutter/material.dart';
import 'package:ipo_lens/core/services/crashlytics_service.dart';
import 'package:ipo_lens/core/services/performance_service.dart';

/// Wrapper widget to automatically track screen rendering performance
/// 
/// Usage:
/// ```dart
/// class MyScreen extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return PerformanceScreenTracker(
///       screenName: 'IPO Details',
///       child: Scaffold(...),
///     );
///   }
/// }
/// ```
class PerformanceScreenTracker extends StatefulWidget {
  final String screenName;
  final Widget child;
  final Map<String, String>? attributes;

  const PerformanceScreenTracker({
    super.key,
    required this.screenName,
    required this.child,
    this.attributes,
  });

  @override
  State<PerformanceScreenTracker> createState() => _PerformanceScreenTrackerState();
}

class _PerformanceScreenTrackerState extends State<PerformanceScreenTracker> {
  String? _traceId;

  @override
  void initState() {
    super.initState();
    _startTracking();
  }

  Future<void> _startTracking() async {
    _traceId = await PerformanceService().startScreenTrace(widget.screenName);
    
    // Add attributes if provided
    if (_traceId != null && widget.attributes != null) {
      for (final entry in widget.attributes!.entries) {
        await PerformanceService().setTraceAttribute(_traceId, entry.key, entry.value);
      }
    }
  }

  @override
  void dispose() {
    PerformanceService().stopTrace(_traceId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Extension methods for easy performance tracking
extension PerformanceFuture<T> on Future<T> {
  /// Wraps a future with performance tracking
  /// 
  /// Usage:
  /// ```dart
  /// final data = await fetchData().trackPerformance('fetch_ipo_data');
  /// ```
  Future<T> trackPerformance(String traceName, {
    Map<String, String>? attributes,
    Map<String, int>? metrics,
  }) async {
    return await PerformanceService().trace(
      traceName,
      () => this,
      attributes: attributes,
      metrics: metrics,
    );
  }
}

/// Combined tracker for both Performance and Crashlytics
/// 
/// Usage:
/// ```dart
/// class MyScreen extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return CombinedScreenTracker(
///       screenName: 'IPO Details',
///       metadata: {'ipo_id': '123'},
///       child: Scaffold(...),
///     );
///   }
/// }
/// ```
class CombinedScreenTracker extends StatefulWidget {
  final String screenName;
  final Widget child;
  final Map<String, dynamic>? metadata;

  const CombinedScreenTracker({
    super.key,
    required this.screenName,
    required this.child,
    this.metadata,
  });

  @override
  State<CombinedScreenTracker> createState() => _CombinedScreenTrackerState();
}

class _CombinedScreenTrackerState extends State<CombinedScreenTracker> {
  String? _traceId;

  @override
  void initState() {
    super.initState();
    _startTracking();
  }

  Future<void> _startTracking() async {
    final crashlytics = CrashlyticsService();
    final performance = PerformanceService();
    
    // Track in both services
    _traceId = await performance.startScreenTrace(widget.screenName);
    await crashlytics.logNavigation(widget.screenName);
    await crashlytics.setCustomKey('current_screen', widget.screenName);
    
    // Add metadata
    if (widget.metadata != null) {
      for (final entry in widget.metadata!.entries) {
        final value = entry.value;
        
        // Add to Crashlytics
        await crashlytics.setCustomKey(entry.key, value);
        
        // Add to Performance (only strings)
        if (_traceId != null && value is String) {
          await performance.setTraceAttribute(_traceId, entry.key, value);
        }
      }
    }
  }

  @override
  void dispose() {
    PerformanceService().stopTrace(_traceId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Mixin for tracking widget lifecycle performance
/// 
/// Usage:
/// ```dart
/// class _MyScreenState extends State<MyScreen> with PerformanceLifecycleMixin {
///   @override
///   String get screenName => 'My Screen';
/// }
/// ```
mixin PerformanceLifecycleMixin<T extends StatefulWidget> on State<T> {
  String get screenName;
  String? _lifecycleTraceId;

  @override
  void initState() {
    super.initState();
    _startLifecycleTrace();
  }

  Future<void> _startLifecycleTrace() async {
    _lifecycleTraceId = await PerformanceService().startTrace('${screenName}_lifecycle');
  }

  @override
  void dispose() {
    PerformanceService().stopTrace(_lifecycleTraceId);
    super.dispose();
  }
}
