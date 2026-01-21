# Quick Reference: Firebase Remote Config Parameters

## 🎯 For Flexible Update (Optional)
Set in Firebase Console:
- `latest_app_version`: `1.1.0` (new version)
- `min_app_version`: `1.0.0` (current/old version)
- `force_update_enabled`: `false`

## 🚨 For Force Update (Mandatory)
**Option 1**: Raise minimum version
- `min_app_version`: `1.1.0` (new version)
- `latest_app_version`: `1.1.0`

**Option 2**: Enable force flag
- `force_update_enabled`: `true`
- `latest_app_version`: `1.1.0`

## 🔧 For Maintenance Mode
- `maintenance_mode`: `true`
- `maintenance_message`: "Your custom message"

## 📝 Default Values to Set in Firebase

Copy these into Firebase Remote Config:

| Parameter | Type | Default Value |
|-----------|------|---------------|
| `min_app_version` | String | `1.0.0` |
| `latest_app_version` | String | `1.0.0` |
| `force_update_enabled` | Boolean | `false` |
| `update_message` | String | `A new version is available! Update now for the best experience.` |
| `force_update_message` | String | `Please update to the latest version to continue using the app.` |
| `update_button_text` | String | `Update Now` |
| `skip_button_text` | String | `Later` |
| `maintenance_mode` | Boolean | `false` |
| `maintenance_message` | String | `We are currently under maintenance. Please check back soon.` |

---

## 🔄 When You Release v1.1.0

1. Upload APK/AAB to Play Store
2. Go to Firebase Console → Remote Config
3. Update: `latest_app_version` = `1.1.0`
4. Choose update type (see above)
5. Click "Publish changes"
6. Wait 1 hour (or force close/reopen app)

---

## ⚡ Quick Test

**In Firebase Console:**
1. Set `latest_app_version` to `99.0.0`
2. Publish changes
3. Reopen app
4. You should see update dialog!

---

## 📱 Important Files Created

1. `lib/core/services/remote_config_service.dart` - Firebase config handler
2. `lib/core/services/app_update_service.dart` - Update logic & dialogs
3. `lib/core/services/crashlytics_service.dart` - Crashlytics wrapper
4. `lib/core/widgets/maintenance_screen.dart` - Maintenance UI
5. `FIREBASE_REMOTE_CONFIG_SETUP.md` - Remote Config documentation
6. `CRASHLYTICS_SETUP.md` - Crashlytics documentation

---

## 📊 Crashlytics Quick Usage

```dart
// Import
import 'package:ipo_lens/core/services/crashlytics_service.dart';

// Log error
await CrashlyticsService().logError(e, stack, reason: 'Failed');

// Track user (after login)
await CrashlyticsService().setUserId('user_123');

// Log feature usage
await CrashlyticsService().logFeatureUsage('ipo_apply');

// Clear on logout
await CrashlyticsService().clearUserData();
```

---

## ⚡ Performance Monitoring Quick Usage

```dart
// Import
import 'package:ipo_lens/core/services/performance_service.dart';

// Track any operation
await PerformanceService().trace('my_operation', () => doWork());

// Track API call
await PerformanceService().traceApiCall('fetch_data', () => api.getData());

// Track screen (wrap your screen)
return PerformanceScreenTracker(
  screenName: 'IPO_Details',
  child: Scaffold(...),
);

// Extension method
await fetchData().trackPerformance('fetch_operation');

// Manual control
final id = await PerformanceService().startTrace('my_trace');
// ... do work ...
await PerformanceService().stopTrace(id);
```

---

See **FIREBASE_PERFORMANCE_SETUP.md** for detailed Performance Monitoring guide.
