# Firebase Remote Config Setup Guide for In-App Updates

## 📋 Overview
This implementation allows you to control app updates remotely through Firebase Remote Config. You can send flexible updates (optional) or force updates (mandatory) to users.

---

## 🔧 Firebase Console Setup

### Step 1: Access Firebase Remote Config
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project: **ipo_lens**
3. In the left sidebar, click on **"Remote Config"** under the **Engage** section

### Step 2: Create Remote Config Parameters

Click **"Add parameter"** for each of the following:

#### 1. **min_app_version** (Force Update Threshold)
- **Parameter key**: `min_app_version`
- **Default value**: `1.0.0`
- **Description**: Minimum required version. Users below this version will be forced to update.
- **Data type**: String

#### 2. **latest_app_version** (Latest Available Version)
- **Parameter key**: `latest_app_version`
- **Default value**: `1.0.0`
- **Description**: Latest version available on the store.
- **Data type**: String

#### 3. **force_update_enabled** (Enable Force Update)
- **Parameter key**: `force_update_enabled`
- **Default value**: `false`
- **Description**: If true, all users below latest_app_version will be forced to update.
- **Data type**: Boolean

#### 4. **update_message** (Flexible Update Message)
- **Parameter key**: `update_message`
- **Default value**: `A new version is available! Update now for the best experience.`
- **Description**: Message shown for optional updates.
- **Data type**: String

#### 5. **force_update_message** (Force Update Message)
- **Parameter key**: `force_update_message`
- **Default value**: `Please update to the latest version to continue using the app.`
- **Description**: Message shown for mandatory updates.
- **Data type**: String

#### 6. **update_button_text** (Update Button Label)
- **Parameter key**: `update_button_text`
- **Default value**: `Update Now`
- **Description**: Text for the update button.
- **Data type**: String

#### 7. **skip_button_text** (Skip Button Label)
- **Parameter key**: `skip_button_text`
- **Default value**: `Later`
- **Description**: Text for the skip button (only shown in flexible updates).
- **Data type**: String

#### 8. **maintenance_mode** (Maintenance Mode)
- **Parameter key**: `maintenance_mode`
- **Default value**: `false`
- **Description**: If true, app shows maintenance screen to all users.
- **Data type**: Boolean

#### 9. **maintenance_message** (Maintenance Message)
- **Parameter key**: `maintenance_message`
- **Default value**: `We are currently under maintenance. Please check back soon.`
- **Description**: Message shown during maintenance mode.
- **Data type**: String

### Step 3: Publish Changes
After adding all parameters, click **"Publish changes"** button at the top.

---

## 📱 Usage Scenarios

### Scenario 1: Flexible Update (Optional)
**Current app version**: 1.0.0  
**Firebase Config**:
```
min_app_version: 1.0.0
latest_app_version: 1.1.0
force_update_enabled: false
```
**Result**: User sees an optional update dialog with "Update Now" and "Later" buttons.

---

### Scenario 2: Force Update (Mandatory)
**Current app version**: 1.0.0  
**Firebase Config**:
```
min_app_version: 1.1.0
latest_app_version: 1.1.0
force_update_enabled: false
```
**Result**: User must update to continue using the app. No skip button.

---

### Scenario 3: Force Update for All (Even Recent Versions)
**Current app version**: 1.1.0  
**Firebase Config**:
```
min_app_version: 1.0.0
latest_app_version: 1.2.0
force_update_enabled: true
```
**Result**: Even users on 1.1.0 will be forced to update to 1.2.0.

---

### Scenario 4: Maintenance Mode
**Firebase Config**:
```
maintenance_mode: true
maintenance_message: "We're adding exciting new features. Back in 2 hours!"
```
**Result**: All users see maintenance screen, regardless of version.

---

## 🎯 How to Trigger Updates

### When you release version 1.1.0 on Play Store:

1. **Go to Firebase Console → Remote Config**
2. **Edit** `latest_app_version` parameter
3. **Change value** from `1.0.0` to `1.1.0`
4. **Decide update type**:
   - **Optional**: Keep `min_app_version` at `1.0.0` and `force_update_enabled` as `false`
   - **Mandatory**: Change `min_app_version` to `1.1.0` OR set `force_update_enabled` to `true`
5. **Click** "Publish changes"

Within 1 hour (or based on your fetch interval), users will receive the update prompt.

---

## 🔄 Testing Updates

### Test Flexible Update:
```
min_app_version: 1.0.0
latest_app_version: 2.0.0
force_update_enabled: false
```

### Test Force Update:
```
min_app_version: 2.0.0
latest_app_version: 2.0.0
force_update_enabled: false
```

### Test Maintenance Mode:
```
maintenance_mode: true
```

After changing values in Firebase, **force refresh** the app or wait for the fetch interval (1 hour by default).

---

## 📝 Important Notes

1. **Version Format**: Always use semantic versioning (e.g., `1.0.0`, `1.2.3`)
2. **App Version**: Update `version` in `pubspec.yaml` before building APK/AAB
3. **Play Store URL**: Update package name in `app_update_service.dart` if needed
4. **Fetch Interval**: Config is fetched every 1 hour. Change in `remote_config_service.dart` if needed
5. **Testing**: Use debug builds to test. The fetch interval is shorter in debug mode

---

## 🚀 Installation Steps

1. **Install dependencies**:
```bash
flutter pub get
```

2. **Build and release new version**:
```bash
flutter build appbundle --release
```

3. **Upload to Play Store**

4. **Update Firebase Remote Config** with new version number

5. **Publish changes** in Firebase Console

---

## 🎨 Customization

### Change Dialog Design
Edit `UpdateDialog` widget in `lib/core/services/app_update_service.dart`

### Change Check Timing
Edit delay in `lib/core/widgets/update_checker.dart`:
```dart
await Future.delayed(const Duration(seconds: 2)); // Change this
```

### Change Fetch Interval
Edit in `lib/core/services/remote_config_service.dart`:
```dart
minimumFetchInterval: const Duration(hours: 1), // Change this
```

---

## 🔍 Debugging

Check logs for:
```
✅ Firebase Remote Config initialized successfully
📱 Current version: 1.0.0
📱 Min version: 1.0.0
📱 Latest version: 1.1.0
```

---

## 📊 Example Configuration for Production

### Normal Release (Optional Update):
```json
{
  "min_app_version": "1.0.0",
  "latest_app_version": "1.1.0",
  "force_update_enabled": false,
  "update_message": "New features added! Update to enjoy a better experience.",
  "update_button_text": "Update Now",
  "skip_button_text": "Maybe Later"
}
```

### Critical Bug Fix (Force Update):
```json
{
  "min_app_version": "1.1.0",
  "latest_app_version": "1.1.0",
  "force_update_enabled": false,
  "force_update_message": "A critical security update is required. Please update now.",
  "update_button_text": "Update Now"
}
```

### Scheduled Maintenance:
```json
{
  "maintenance_mode": true,
  "maintenance_message": "We're performing scheduled maintenance. Will be back at 10 PM IST."
}
```

---

## ✅ Checklist

- [ ] Firebase project created
- [ ] Remote Config enabled in Firebase Console
- [ ] All 9 parameters added in Remote Config
- [ ] Parameters published in Firebase Console
- [ ] Dependencies installed (`flutter pub get`)
- [ ] Package name updated in `app_update_service.dart`
- [ ] App version matches in `pubspec.yaml` and Play Store
- [ ] Tested with different version scenarios
- [ ] Play Store URL is correct

---

## 🆘 Troubleshooting

**Issue**: Update dialog not showing  
**Solution**: Check if Firebase is initialized correctly and Remote Config values are published

**Issue**: Wrong version comparison  
**Solution**: Ensure version format is `X.Y.Z` (e.g., 1.0.0, not 1.0)

**Issue**: Can't skip force update  
**Solution**: This is intentional. Force updates cannot be skipped.

---

That's it! Your in-app update system is ready. 🎉
