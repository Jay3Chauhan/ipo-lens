import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Service for Firebase Crashlytics integration
/// Provides methods for logging errors, custom events, and user identification
class CrashlyticsService {
  static final CrashlyticsService _instance = CrashlyticsService._internal();
  factory CrashlyticsService() => _instance;
  CrashlyticsService._internal();

  FirebaseCrashlytics? _crashlytics;
  bool _isInitialized = false;

  /// Initialize Crashlytics
  Future<void> initialize() async {
    try {
      _crashlytics = FirebaseCrashlytics.instance;
      _isInitialized = true;
      
      // Enable crash collection
      await _crashlytics?.setCrashlyticsCollectionEnabled(true);
      
      debugPrint('✅ CrashlyticsService initialized');
    } catch (e) {
      debugPrint('❌ Failed to initialize CrashlyticsService: $e');
      _isInitialized = false;
    }
  }

  /// Check if Crashlytics is available
  bool get isAvailable => _isInitialized && _crashlytics != null;

  /// Log a custom error with optional stack trace
  Future<void> logError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    if (!isAvailable) return;

    try {
      await _crashlytics?.recordError(
        exception,
        stackTrace,
        reason: reason,
        fatal: fatal,
      );
      debugPrint('📝 Logged error to Crashlytics: $exception');
    } catch (e) {
      debugPrint('❌ Failed to log error: $e');
    }
  }

  /// Log a Flutter error
  Future<void> logFlutterError(FlutterErrorDetails errorDetails) async {
    if (!isAvailable) return;

    try {
      await _crashlytics?.recordFlutterFatalError(errorDetails);
      debugPrint('📝 Logged Flutter error to Crashlytics');
    } catch (e) {
      debugPrint('❌ Failed to log Flutter error: $e');
    }
  }

  /// Log a custom message/event
  Future<void> log(String message) async {
    if (!isAvailable) return;

    try {
      await _crashlytics?.log(message);
      debugPrint('📝 Logged message: $message');
    } catch (e) {
      debugPrint('❌ Failed to log message: $e');
    }
  }

  /// Set user identifier for tracking
  Future<void> setUserId(String userId) async {
    if (!isAvailable) return;

    try {
      await _crashlytics?.setUserIdentifier(userId);
      debugPrint('👤 Set user ID: $userId');
    } catch (e) {
      debugPrint('❌ Failed to set user ID: $e');
    }
  }

  /// Set custom key-value pair for crash reports
  Future<void> setCustomKey(String key, dynamic value) async {
    if (!isAvailable) return;

    try {
      await _crashlytics?.setCustomKey(key, value);
      debugPrint('🔑 Set custom key: $key = $value');
    } catch (e) {
      debugPrint('❌ Failed to set custom key: $e');
    }
  }

  /// Set multiple custom keys at once
  Future<void> setCustomKeys(Map<String, dynamic> keys) async {
    if (!isAvailable) return;

    for (final entry in keys.entries) {
      await setCustomKey(entry.key, entry.value);
    }
  }

  /// Test crash (only for testing, never use in production!)
  Future<void> testCrash() async {
    if (!isAvailable) return;
    if (kReleaseMode) {
      debugPrint('⚠️ Test crash disabled in release mode');
      return;
    }

    debugPrint('💥 Testing crash...');
    _crashlytics?.crash();
  }

  /// Log HTTP error
  Future<void> logHttpError({
    required String endpoint,
    required int statusCode,
    String? errorMessage,
    dynamic response,
  }) async {
    await log('HTTP Error: $endpoint - Status: $statusCode');
    await setCustomKeys({
      'http_endpoint': endpoint,
      'http_status_code': statusCode,
      'http_error_message': errorMessage ?? 'Unknown error',
      'http_response': response?.toString() ?? 'No response',
    });
    
    await logError(
      Exception('HTTP $statusCode: $endpoint'),
      StackTrace.current,
      reason: 'API request failed',
    );
  }

  /// Log navigation event
  Future<void> logNavigation(String routeName) async {
    await log('Navigation: $routeName');
    await setCustomKey('last_route', routeName);
  }

  /// Log authentication event
  Future<void> logAuth({
    required String action,
    String? userId,
    String? method,
  }) async {
    await log('Auth: $action${method != null ? ' via $method' : ''}');
    
    final keys = <String, dynamic>{
      'auth_action': action,
      'auth_method': method ?? 'unknown',
    };
    
    if (userId != null) {
      await setUserId(userId);
      keys['user_id'] = userId;
    }
    
    await setCustomKeys(keys);
  }

  /// Log app lifecycle event
  Future<void> logAppLifecycle(String state) async {
    await log('App Lifecycle: $state');
    await setCustomKey('app_lifecycle_state', state);
  }

  /// Clear custom keys (e.g., on logout)
  Future<void> clearUserData() async {
    if (!isAvailable) return;

    try {
      await _crashlytics?.setUserIdentifier('');
      await log('User data cleared');
      debugPrint('🧹 Cleared user data from Crashlytics');
    } catch (e) {
      debugPrint('❌ Failed to clear user data: $e');
    }
  }

  /// Log feature usage
  Future<void> logFeatureUsage(String featureName, {Map<String, dynamic>? metadata}) async {
    await log('Feature Used: $featureName');
    
    if (metadata != null) {
      final keys = <String, dynamic>{};
      for (final entry in metadata.entries) {
        keys['feature_${entry.key}'] = entry.value;
      }
      await setCustomKeys(keys);
    }
  }

  /// Log business logic error (non-fatal)
  Future<void> logBusinessError({
    required String operation,
    required String error,
    Map<String, dynamic>? context,
  }) async {
    await log('Business Error: $operation - $error');
    
    final keys = <String, dynamic>{
      'business_operation': operation,
      'business_error': error,
    };
    
    if (context != null) {
      keys.addAll(context);
    }
    
    await setCustomKeys(keys);
    
    // Log as non-fatal error
    await logError(
      Exception('Business Logic Error: $operation - $error'),
      StackTrace.current,
      reason: 'Business logic validation failed',
      fatal: false,
    );
  }
}
