import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;
  RemoteConfigService._internal();

  late FirebaseRemoteConfig _remoteConfig;
  bool _initialized = false;

  // Keys for remote config
  static const String keyMinAppVersion = 'min_app_version';
  static const String keyLatestAppVersion = 'latest_app_version';
  static const String keyForceUpdateEnabled = 'force_update_enabled';
  static const String keyUpdateMessage = 'update_message';
  static const String keyForceUpdateMessage = 'force_update_message';
  static const String keyUpdateButtonText = 'update_button_text';
  static const String keySkipButtonText = 'skip_button_text';
  static const String keyMaintenanceMode = 'maintenance_mode';
  static const String keyMaintenanceMessage = 'maintenance_message';

  /// Initialize Firebase Remote Config
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      _remoteConfig = FirebaseRemoteConfig.instance;

      // Configure settings
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 30),
          minimumFetchInterval: const Duration(seconds: 1), // Fetch new config every hour
        ),
      );

      // Set default values
      await _remoteConfig.setDefaults({
        keyMinAppVersion: '1.0.0',
        keyLatestAppVersion: '1.0.0',
        keyForceUpdateEnabled: false,
        keyUpdateMessage: 'A new version is available! Update now for the best experience.',
        keyForceUpdateMessage: 'Please update to the latest version to continue using the app.',
        keyUpdateButtonText: 'Update Now',
        keySkipButtonText: 'Later',
        keyMaintenanceMode: false,
        keyMaintenanceMessage: 'We are currently under maintenance. Please check back soon.',
      });

      // Fetch and activate
      await _remoteConfig.fetchAndActivate();
      
      _initialized = true;
      debugPrint('✅ Firebase Remote Config initialized successfully');
    } catch (e) {
      debugPrint('❌ Failed to initialize Remote Config: $e');
      _initialized = false;
    }
  }

  /// Get minimum required app version (force update if below this)
  String get minAppVersion => _remoteConfig.getString(keyMinAppVersion);

  /// Get latest available app version
  String get latestAppVersion => _remoteConfig.getString(keyLatestAppVersion);

  /// Check if force update is enabled
  bool get isForceUpdateEnabled => _remoteConfig.getBool(keyForceUpdateEnabled);

  /// Get update message for flexible update
  String get updateMessage => _remoteConfig.getString(keyUpdateMessage);

  /// Get force update message
  String get forceUpdateMessage => _remoteConfig.getString(keyForceUpdateMessage);

  /// Get update button text
  String get updateButtonText => _remoteConfig.getString(keyUpdateButtonText);

  /// Get skip button text
  String get skipButtonText => _remoteConfig.getString(keySkipButtonText);

  /// Check if app is in maintenance mode
  bool get isMaintenanceMode => _remoteConfig.getBool(keyMaintenanceMode);

  /// Get maintenance message
  String get maintenanceMessage => _remoteConfig.getString(keyMaintenanceMessage);

  /// Manually fetch latest config
  Future<void> fetchConfig() async {
    try {
      await _remoteConfig.fetchAndActivate();
      debugPrint('✅ Remote Config fetched and activated');
    } catch (e) {
      debugPrint('❌ Failed to fetch Remote Config: $e');
    }
  }

  /// Get all config values (for debugging)
  Map<String, dynamic> getAllConfig() {
    return {
      keyMinAppVersion: minAppVersion,
      keyLatestAppVersion: latestAppVersion,
      keyForceUpdateEnabled: isForceUpdateEnabled,
      keyUpdateMessage: updateMessage,
      keyForceUpdateMessage: forceUpdateMessage,
      keyUpdateButtonText: updateButtonText,
      keySkipButtonText: skipButtonText,
      keyMaintenanceMode: isMaintenanceMode,
      keyMaintenanceMessage: maintenanceMessage,
    };
  }
}
