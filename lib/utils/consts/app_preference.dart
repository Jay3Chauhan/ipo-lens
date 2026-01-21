import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ipo_lens/utils/consts/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreference {
  AppPreference._();
  static final AppPreference _instance = AppPreference._();

  factory AppPreference() {
    return _instance;
  }

  static late SharedPreferences _prefs;

  // Initialize Secure Storage with encrypted options for Android
  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  /// Call this in main() before runApp()
  static Future<void> initMySharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Clears BOTH Secure Storage and SharedPreferences
  /// Useful for total Logout
  Future<void> clearAllData() async {
    await _secureStorage.deleteAll();
    await _prefs.clear();
  }

  // ============================================================
  // SECTION 1: SECURE STORAGE (Sensitive Data)
  // Returns Futures because decryption is asynchronous
  // ============================================================

  /// Set & Get UserToken (SECURE)
  Future<void> setAuthToken(String value) async {
    await _secureStorage.write(key: Constant.authToken, value: value);
  }

  /// Note: Now returns a Future<String> instead of String
  Future<String> getAuthToken() async {
    final value = await _secureStorage.read(key: Constant.authToken);
    return value ?? '';
  }

  Future<void> removeAuthToken() async {
    await _secureStorage.delete(key: Constant.authToken);
  }

  /// Set & Get UserID (SECURE)
  Future<void> setUserID(String value) async {
    await _secureStorage.write(key: Constant.userID, value: value);
  }

  Future<String> getUserID() async {
    final value = await _secureStorage.read(key: Constant.userID);
    return value ?? '';
  }

  Future<void> removeUserID() async {
    await _secureStorage.delete(key: Constant.userID);
  }

  /// Clear all secure storage data (tokens, user ID, etc.)
  /// Call this during logout to ensure complete cleanup
  Future<void> clearSecureStorage() async {
    await _secureStorage.deleteAll();
  }

  // ============================================================
  // SECTION 2: SHARED PREFERENCES (UI & Config Data)
  // Kept synchronous for performance/preventing UI flash
  // ============================================================

  /// Theme Preferences
  Future<void> setThemeMode(String themeMode) async {
    await _prefs.setString(Constant.selectedThemeMode, themeMode);
  }

  String getThemeMode() {
    final String? value = _prefs.getString(Constant.selectedThemeMode);
    return value ?? 'system';
  }

  /// First Launch Detection
  Future<void> setFirstLaunch(bool value) async {
    await _prefs.setBool(Constant.isFirstLaunch, value);
  }

  bool isFirstLaunch() {
    final bool? value = _prefs.getBool(Constant.isFirstLaunch);
    // Default to true if key doesn't exist (first time ever)
    return value ?? true;
  }

  /// Verify User Response Model (Can generally stay in Prefs if not strictly sensitive,
  /// otherwise move to secure storage like AuthToken)
  Future<void> setVerifyUserResponse(String jsonString) async {
    await _prefs.setString(Constant.verifyUserResponseModel, jsonString);
  }

  String getVerifyUserResponse() {
    return _prefs.getString(Constant.verifyUserResponseModel) ?? '';
  }

  // ============================================================
  // SECTION 3: SETTINGS / PROFILE CACHE
  // ============================================================

  Future<void> setUserMobileNumber(String value) async {
    await _prefs.setString(Constant.userMobileNumber, value);
  }

  String? getUserMobileNumber() {
    final v = _prefs.getString(Constant.userMobileNumber);
    return (v == null || v.trim().isEmpty) ? null : v;
  }

  Future<void> setUserPanNumber(String value) async {
    await _prefs.setString(Constant.userPanNumber, value);
  }

  String? getUserPanNumber() {
    final v = _prefs.getString(Constant.userPanNumber);
    return (v == null || v.trim().isEmpty) ? null : v;
  }

  Future<void> setBankProfileJson(String value) async {
    await _prefs.setString(Constant.bankProfileJson, value);
  }

  String getBankProfileJson() {
    return _prefs.getString(Constant.bankProfileJson) ?? '';
  }

  // ============================================================
  // SECTION 4: APP PREFERENCES (Settings toggles)
  // ============================================================

  Future<void> setMaskBalances(bool value) async {
    await _prefs.setBool(Constant.prefMaskBalances, value);
  }

  bool getMaskBalances() {
    return _prefs.getBool(Constant.prefMaskBalances) ?? false;
  }

  Future<void> setBiometricLock(bool value) async {
    await _prefs.setBool(Constant.prefBiometricLock, value);
  }

  bool getBiometricLock() {
    return _prefs.getBool(Constant.prefBiometricLock) ?? false;
  }

  Future<void> setNotificationsEnabled(bool value) async {
    await _prefs.setBool(Constant.prefNotificationsEnabled, value);
  }

  bool getNotificationsEnabled() {
    return _prefs.getBool(Constant.prefNotificationsEnabled) ?? true;
  }

  Future<void> setAutoRefresh(bool value) async {
    await _prefs.setBool(Constant.prefAutoRefresh, value);
  }

  bool getAutoRefresh() {
    return _prefs.getBool(Constant.prefAutoRefresh) ?? true;
  }
}
