# Firebase Crashlytics Setup & Usage Guide

## 📋 Overview

Firebase Crashlytics is fully integrated into the IPO Lens app to help monitor crashes, errors, and app performance in production.

## ✅ What's Already Done

### 1. **Dependencies Added**
```yaml
firebase_crashlytics: ^5.0.6
firebase_core: ^4.3.0
```

### 2. **Crashlytics Initialized in main.dart**
- ✅ Automatic crash reporting for Flutter errors
- ✅ Automatic crash reporting for async errors
- ✅ CrashlyticsService wrapper initialized
- ✅ App version logging on startup

### 3. **CrashlyticsService Created**
A comprehensive service wrapper at `lib/core/services/crashlytics_service.dart` with methods for:
- Error logging
- Custom event logging
- User identification
- HTTP error tracking
- Navigation tracking
- Authentication events
- Feature usage tracking
- Business logic errors

### 4. **Provider Integration**
OpenIposProvider now logs:
- ✅ Successful API fetches
- ✅ HTTP errors with full details
- ✅ Invalid response errors
- ✅ Business logic failures

## 🔧 Firebase Console Setup

### Step 1: Enable Crashlytics
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **IPO Lens**
3. Click **Crashlytics** in left menu
4. Click **Enable Crashlytics**

### Step 2: Configure Android (If Not Done)
```bash
# Your Android setup should already be done, but verify:
# android/app/google-services.json exists
# android/app/build.gradle.kts has crashlytics plugin
```

Check `android/app/build.gradle.kts` has:
```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")  // Add this line if missing
}
```

Check `android/build.gradle.kts` has:
```kotlin
buildscript {
    dependencies {
        classpath("com.google.gms:google-services:4.4.2")
        classpath("com.google.firebase:firebase-crashlytics-gradle:3.0.2")  // Add if missing
    }
}
```

### Step 3: Configure iOS (When Ready)
```bash
# For iOS, ensure:
# ios/Runner/GoogleService-Info.plist exists
# ios/Podfile has Firebase Crashlytics pod
```

## 📱 Testing Crashlytics

### Test 1: Force a Test Crash (Debug Mode Only)
```dart
import 'package:ipo_lens/core/services/crashlytics_service.dart';

// In any widget (ONLY FOR TESTING):
ElevatedButton(
  onPressed: () async {
    await CrashlyticsService().testCrash();
  },
  child: Text('Test Crash'),
)
```

### Test 2: Log a Custom Error
```dart
try {
  // Some code that might fail
  throw Exception('Test error for Crashlytics');
} catch (e, stack) {
  await CrashlyticsService().logError(
    e,
    stack,
    reason: 'Testing error logging',
  );
}
```

### Test 3: Check Firebase Console
1. Trigger a crash or error in your app
2. Wait 5-10 minutes
3. Go to Firebase Console → Crashlytics
4. You should see crash reports appearing

## 🎯 Usage Examples

### 1. Basic Error Logging
```dart
try {
  await someRiskyOperation();
} catch (e, stack) {
  await CrashlyticsService().logError(
    e,
    stack,
    reason: 'Failed to perform operation',
  );
}
```

### 2. HTTP Error Logging
```dart
if (response.statusCode != 200) {
  await CrashlyticsService().logHttpError(
    endpoint: '/api/endpoint',
    statusCode: response.statusCode,
    errorMessage: 'Request failed',
    response: response.body,
  );
}
```

### 3. User Identification (On Login)
```dart
// When user logs in:
await CrashlyticsService().setUserId('user_123');

// Log authentication event:
await CrashlyticsService().logAuth(
  action: 'login',
  userId: 'user_123',
  method: 'phone',
);
```

### 4. Custom Event Logging
```dart
// Log feature usage:
await CrashlyticsService().logFeatureUsage(
  'ipo_apply',
  metadata: {
    'ipo_id': '123',
    'amount': 50000,
  },
);
```

### 5. Navigation Tracking
```dart
// In your router or navigation code:
await CrashlyticsService().logNavigation('/ipo-details/123');
```

### 6. Business Logic Errors (Non-Fatal)
```dart
if (ipoAmount < minimumAmount) {
  await CrashlyticsService().logBusinessError(
    operation: 'ipo_application',
    error: 'Amount below minimum',
    context: {
      'requested_amount': ipoAmount,
      'minimum_amount': minimumAmount,
      'ipo_id': ipoId,
    },
  );
}
```

### 7. Set Custom Keys for Context
```dart
// Set app state context:
await CrashlyticsService().setCustomKeys({
  'user_type': 'premium',
  'kyc_verified': true,
  'last_ipo_applied': '2026-01-20',
});
```

### 8. Clear User Data (On Logout)
```dart
// When user logs out:
await CrashlyticsService().clearUserData();
```

## 📊 What You'll See in Firebase Console

### Crash Reports Include:
- **Stack traces**: Full error stack
- **Device info**: Model, OS version, screen size
- **Custom keys**: All keys you set with `setCustomKey()`
- **Logs**: All messages logged with `log()`
- **User ID**: If set with `setUserId()`
- **App version**: Set automatically on app start

### Crashlytics Dashboard Shows:
- **Crash-free users**: Percentage of users without crashes
- **Most common crashes**: Ranked by frequency
- **Affected versions**: Which app versions have issues
- **Device breakdown**: Crashes by device model
- **Timeline**: When crashes occurred

## 🚀 Best Practices

### DO:
✅ Log errors at important failure points (API calls, data parsing, file I/O)
✅ Set user IDs after authentication
✅ Add custom keys for app state context
✅ Log business logic errors for debugging
✅ Clear user data on logout for privacy
✅ Use meaningful error reasons

### DON'T:
❌ Log sensitive user data (passwords, credit cards, PII)
❌ Log every single action (creates noise)
❌ Use test crashes in production builds
❌ Ignore non-fatal errors (log them!)
❌ Forget to check Crashlytics dashboard regularly

## 🔍 Monitoring & Alerts

### Set Up Alerts
1. Go to Firebase Console → Crashlytics
2. Click **Alerts** tab
3. Set up alerts for:
   - New issues detected
   - Regression issues (old crashes returning)
   - Velocity alerts (crash rate increases)

### Regular Monitoring
- Check dashboard weekly for new issues
- Monitor crash-free users percentage (aim for 99%+)
- Prioritize fixing high-frequency crashes
- Track crash trends over time

## 🐛 Debugging Tips

### Finding Root Cause
1. **Check stack trace**: Where did the crash occur?
2. **Review custom keys**: What was app state?
3. **Read logs**: What actions led to the crash?
4. **Check affected devices**: Device-specific issue?
5. **Compare versions**: Was it introduced in latest release?

### Reproducing Crashes
1. Note device model and OS from crash report
2. Follow exact steps from logs
3. Set app to same state (custom keys)
4. Try on similar device if possible

## 📝 Integration Checklist

- [x] Firebase Crashlytics dependency added
- [x] Firebase initialized in main.dart
- [x] Crashlytics auto-capture configured
- [x] CrashlyticsService created and initialized
- [x] Error logging added to OpenIposProvider
- [x] App version logged on startup
- [ ] Test crash triggered (you should test)
- [ ] Crashlytics enabled in Firebase Console (you need to do)
- [ ] Alerts configured (optional, recommended)
- [ ] Team access set up (optional)

## 🎓 Additional Resources

- [Firebase Crashlytics Docs](https://firebase.google.com/docs/crashlytics)
- [Flutter Crashlytics Package](https://pub.dev/packages/firebase_crashlytics)
- [Crashlytics Best Practices](https://firebase.google.com/docs/crashlytics/best-practices)

---

**Ready to go!** 🎉 Your app now automatically reports crashes and errors to Firebase Crashlytics. Check the Firebase Console to see reports after testing.
