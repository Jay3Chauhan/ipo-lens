abstract interface class Constant {
  static const String authToken = "_userToken";
  static const String userID = "_userID";
  static const String loginResponseModel = 'login_response_model';
  static const String isFirstLaunch = 'is_first_launch';
  static const String selectedThemeMode = 'selected_theme_mode';
  static const String verifyUserResponseModel = "verify_user_response_model";

  // Settings/Profile cache
  static const String userMobileNumber = 'user_mobile_number';
  static const String userPanNumber = 'user_pan_number';
  static const String bankProfileJson = 'bank_profile_json';

  static const String finvuTermsURL = "https://finvu.in/terms";

  // App preferences (Settings toggles)
  static const String prefMaskBalances = 'pref_mask_balances';
  static const String prefBiometricLock = 'pref_biometric_lock';
  static const String prefNotificationsEnabled = 'pref_notifications_enabled';
  static const String prefAutoRefresh = 'pref_auto_refresh';
}
