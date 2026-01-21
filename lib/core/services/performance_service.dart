import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Service for Firebase Performance Monitoring integration
/// Provides methods for tracking app performance, network requests, and custom traces
class PerformanceService {
  static final PerformanceService _instance = PerformanceService._internal();
  factory PerformanceService() => _instance;
  PerformanceService._internal();

  FirebasePerformance? _performance;
  bool _isInitialized = false;
  final Map<String, Trace> _activeTraces = {};

  /// Initialize Performance Monitoring
  Future<void> initialize() async {
    try {
      _performance = FirebasePerformance.instance;
      
      // Try to enable performance monitoring, but don't fail if platform channel isn't ready
      try {
        await _performance?.setPerformanceCollectionEnabled(true);
      } catch (channelError) {
        // Platform channel not ready yet, but we can still use the service
        debugPrint('⚠️ Performance collection enable skipped (platform channel): $channelError');
      }
      
      _isInitialized = true;
      debugPrint('✅ PerformanceService initialized');
    } catch (e) {
      debugPrint('❌ Failed to initialize PerformanceService: $e');
      _isInitialized = false;
    }
  }

  /// Check if Performance Monitoring is available
  bool get isAvailable => _isInitialized && _performance != null;

  /// Start a custom trace
  /// Returns the trace ID to use with stopTrace()
  Future<String?> startTrace(String traceName) async {
    if (!isAvailable) return null;

    try {
      final trace = _performance!.newTrace(traceName);
      await trace.start();
      
      final traceId = '${traceName}_${DateTime.now().millisecondsSinceEpoch}';
      _activeTraces[traceId] = trace;
      
      debugPrint('⏱️ Started trace: $traceName');
      return traceId;
    } catch (e) {
      debugPrint('❌ Failed to start trace: $e');
      return null;
    }
  }

  /// Stop a custom trace
  Future<void> stopTrace(String? traceId) async {
    if (!isAvailable || traceId == null) return;

    try {
      final trace = _activeTraces[traceId];
      if (trace != null) {
        await trace.stop();
        _activeTraces.remove(traceId);
        debugPrint('⏹️ Stopped trace: $traceId');
      }
    } catch (e) {
      debugPrint('❌ Failed to stop trace: $e');
    }
  }

  /// Add a metric to an active trace
  Future<void> setTraceMetric(String? traceId, String metricName, int value) async {
    if (!isAvailable || traceId == null) return;

    try {
      final trace = _activeTraces[traceId];
      if (trace != null) {
        trace.setMetric(metricName, value);
        debugPrint('📊 Set metric $metricName = $value on trace $traceId');
      }
    } catch (e) {
      debugPrint('❌ Failed to set trace metric: $e');
    }
  }

  /// Increment a metric in an active trace
  Future<void> incrementTraceMetric(String? traceId, String metricName, int incrementBy) async {
    if (!isAvailable || traceId == null) return;

    try {
      final trace = _activeTraces[traceId];
      if (trace != null) {
        trace.incrementMetric(metricName, incrementBy);
        debugPrint('📈 Incremented metric $metricName by $incrementBy on trace $traceId');
      }
    } catch (e) {
      debugPrint('❌ Failed to increment trace metric: $e');
    }
  }

  /// Add a custom attribute to an active trace
  Future<void> setTraceAttribute(String? traceId, String attributeName, String value) async {
    if (!isAvailable || traceId == null) return;

    try {
      final trace = _activeTraces[traceId];
      if (trace != null) {
        trace.putAttribute(attributeName, value);
        debugPrint('🏷️ Set attribute $attributeName = $value on trace $traceId');
      }
    } catch (e) {
      debugPrint('❌ Failed to set trace attribute: $e');
    }
  }

  /// Track an HTTP request manually
  Future<void> trackHttpRequest({
    required String url,
    required String method,
    required int statusCode,
    required int requestPayloadBytes,
    required int responsePayloadBytes,
    required Duration duration,
  }) async {
    if (!isAvailable) return;

    try {
      final metric = _performance!.newHttpMetric(url, HttpMethod.values.firstWhere(
        (m) => m.toString().split('.').last.toUpperCase() == method.toUpperCase(),
        orElse: () => HttpMethod.Get,
      ));

      metric.requestPayloadSize = requestPayloadBytes;
      metric.responsePayloadSize = responsePayloadBytes;
      metric.httpResponseCode = statusCode;
      
      await metric.start();
      await Future.delayed(duration);
      await metric.stop();
      
      debugPrint('🌐 Tracked HTTP $method $url - $statusCode (${duration.inMilliseconds}ms)');
    } catch (e) {
      debugPrint('❌ Failed to track HTTP request: $e');
    }
  }

  /// Wrap an HTTP client to automatically track requests
  http.Client wrapHttpClient(http.Client client) {
    if (!isAvailable) return client;
    return FirebasePerformanceHttpClient._(client, this);
  }

  /// Execute a function with automatic performance tracking
  Future<T> trace<T>(
    String traceName,
    Future<T> Function() function, {
    Map<String, String>? attributes,
    Map<String, int>? metrics,
  }) async {
    // If service not available, just execute function without tracking
    if (!isAvailable) {
      return await function();
    }
    
    String? traceId;
    
    try {
      traceId = await startTrace(traceName);
      
      // Add attributes if provided
      if (attributes != null && traceId != null) {
        for (final entry in attributes.entries) {
          await setTraceAttribute(traceId, entry.key, entry.value);
        }
      }
    } catch (e) {
      // If trace setup fails, just continue without tracking
      debugPrint('⚠️ Trace setup failed for $traceName, continuing without tracking: $e');
      traceId = null;
    }
    
    try {
      final startTime = DateTime.now();
      final result = await function();
      final duration = DateTime.now().difference(startTime);
      
      // Add duration as metric (only if trace was successfully started)
      if (traceId != null) {
        try {
          await setTraceMetric(traceId, 'duration_ms', duration.inMilliseconds);
          
          // Add custom metrics if provided
          if (metrics != null) {
            for (final entry in metrics.entries) {
              await setTraceMetric(traceId, entry.key, entry.value);
            }
          }
        } catch (e) {
          // Ignore metric errors
          debugPrint('⚠️ Failed to set metrics: $e');
        }
      }
      
      await stopTrace(traceId);
      return result;
    } catch (e) {
      // Stop trace if it was started
      try {
        await stopTrace(traceId);
      } catch (_) {
        // Ignore stop errors
      }
      rethrow;
    }
  }

  /// Track screen rendering time
  Future<String?> startScreenTrace(String screenName) async {
    return await startTrace('screen_$screenName');
  }

  /// Track API call performance
  Future<T> traceApiCall<T>(
    String endpoint,
    Future<T> Function() apiCall, {
    Map<String, String>? parameters,
  }) async {
    return await trace(
      'api_$endpoint',
      apiCall,
      attributes: parameters,
    );
  }

  /// Track database operation performance
  Future<T> traceDatabaseOperation<T>(
    String operation,
    Future<T> Function() dbOperation, {
    String? tableName,
    int? recordCount,
  }) async {
    return await trace(
      'db_$operation',
      dbOperation,
      attributes: tableName != null ? {'table': tableName} : null,
      metrics: recordCount != null ? {'record_count': recordCount} : null,
    );
  }

  /// Track image loading performance
  Future<String?> startImageLoadTrace(String imageUrl) async {
    final traceId = await startTrace('image_load');
    if (traceId != null) {
      await setTraceAttribute(traceId, 'url', imageUrl);
    }
    return traceId;
  }

  /// Track navigation performance
  Future<T> traceNavigation<T>(
    String from,
    String to,
    Future<T> Function() navigationAction,
  ) async {
    return await trace(
      'navigation',
      navigationAction,
      attributes: {
        'from': from,
        'to': to,
      },
    );
  }

  /// Track authentication performance
  Future<T> traceAuth<T>(
    String authType,
    Future<T> Function() authAction,
  ) async {
    return await trace(
      'auth_$authType',
      authAction,
      attributes: {'auth_type': authType},
    );
  }

  /// Track feature initialization
  Future<T> traceFeatureInit<T>(
    String featureName,
    Future<T> Function() initAction,
  ) async {
    return await trace(
      'init_$featureName',
      initAction,
      attributes: {'feature': featureName},
    );
  }

  /// Get all active trace IDs (for debugging)
  List<String> getActiveTraceIds() {
    return _activeTraces.keys.toList();
  }

  /// Stop all active traces (cleanup)
  Future<void> stopAllTraces() async {
    final traceIds = List<String>.from(_activeTraces.keys);
    for (final traceId in traceIds) {
      await stopTrace(traceId);
    }
    debugPrint('🧹 Stopped all active traces');
  }
}

/// Custom HTTP client that automatically tracks requests with Firebase Performance
class FirebasePerformanceHttpClient extends http.BaseClient {
  final http.Client _inner;
  final PerformanceService _performanceService;

  FirebasePerformanceHttpClient._(this._inner, this._performanceService);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Skip performance tracking if service isn't available
    if (!_performanceService.isAvailable) {
      return await _inner.send(request);
    }
    
    HttpMetric? metric;
    bool metricStarted = false;
    
    try {
      // Try to create and start HTTP metric
      final httpMethod = HttpMethod.values.firstWhere(
        (m) => m.toString().split('.').last.toUpperCase() == request.method.toUpperCase(),
        orElse: () => HttpMethod.Get,
      );
      
      metric = FirebasePerformance.instance.newHttpMetric(
        request.url.toString(),
        httpMethod,
      );

      // Set request size
      if (request.contentLength != null) {
        metric.requestPayloadSize = request.contentLength!;
      }

      // Start tracking
      await metric.start();
      metricStarted = true;
    } catch (e) {
      // If metric creation/start fails, continue without tracking
      debugPrint('⚠️ Performance metric setup failed for ${request.url}, continuing without tracking');
      metric = null;
      metricStarted = false;
    }
    
    try {
      // Send request (this always happens regardless of tracking)
      final response = await _inner.send(request);

      // Try to log response data if metric was started
      if (metricStarted && metric != null) {
        try {
          metric.httpResponseCode = response.statusCode;
          metric.responseContentType = response.headers['content-type'];
          
          if (response.contentLength != null) {
            metric.responsePayloadSize = response.contentLength!;
          }

          // Stop tracking
          await metric.stop();
        } catch (e) {
          // Ignore metric logging errors
          debugPrint('⚠️ Failed to log response metrics: $e');
        }
      }

      return response;
    } catch (e) {
      // If the actual request fails, try to stop metric and rethrow
      if (metricStarted && metric != null) {
        try {
          await metric.stop();
        } catch (_) {
          // Ignore stop errors
        }
      }
      rethrow;
    }
  }

  @override
  void close() {
    _inner.close();
  }
}
