# Firebase Performance Monitoring Setup & Usage Guide

## 📋 Overview

Firebase Performance Monitoring is fully integrated into the IPO Lens app to help track app performance, network requests, and custom operations in production.

## ✅ What's Already Done

### 1. **Dependencies Added**
```yaml
firebase_performance: ^0.11.1+4
firebase_core: ^4.3.0
```

### 2. **Performance Monitoring Initialized in main.dart**
- ✅ Automatic HTTP request tracking (via wrapped HttpClient)
- ✅ PerformanceService wrapper initialized
- ✅ App startup time tracked
- ✅ HTTP client wrapped with automatic tracking

### 3. **PerformanceService Created**
A comprehensive service wrapper at `lib/core/services/performance_service.dart` with methods for:
- Custom trace creation and management
- HTTP request tracking
- API call performance monitoring
- Database operation tracking
- Screen rendering tracking
- Navigation performance
- Authentication performance
- Feature initialization tracking

### 4. **Provider Integration**
OpenIposProvider now tracks:
- ✅ API call duration for open IPOs
- ✅ API call duration for upcoming IPOs
- ✅ API call duration for listed IPOs
- ✅ Request parameters as trace attributes

### 5. **Automatic HTTP Tracking**
All HTTP requests made through the app's `http.Client` are automatically tracked with:
- ✅ Request URL and method
- ✅ Response status code
- ✅ Request/response payload sizes
- ✅ Request duration

## 🔧 Firebase Console Setup

### Step 1: Enable Performance Monitoring
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **IPO Lens**
3. Click **Performance** in left menu
4. Performance Monitoring should be automatically enabled

### Step 2: Verify Android Configuration
Your Android setup is already done! Verify these files:

**android/app/build.gradle.kts** has:
```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    id("com.google.firebase.firebase-perf")  // ✅ Already added
}
```

### Step 3: Build and Deploy
```bash
flutter clean
flutter pub get
flutter build apk --release
# Or
flutter run --release
```

**Note**: Performance data only appears after your app is used in the wild. It may take 12-24 hours for data to appear in Firebase Console.

## 📱 What Gets Tracked Automatically

### HTTP Requests (All Automatic)
- ✅ Every API call URL
- ✅ Request method (GET, POST, etc.)
- ✅ Response status code
- ✅ Request duration
- ✅ Payload sizes

### App Startup
- ✅ App initialization time
- ✅ Firebase services initialization

### Screen Traces (When You Add Trackers)
- Screen rendering time
- Time spent on each screen

## 🎯 Usage Examples

### 1. Track Any Async Operation
```dart
final result = await PerformanceService().trace(
  'load_user_profile',
  () async {
    return await fetchUserProfile();
  },
  attributes: {'user_id': userId},
  metrics: {'profile_size': profileData.length},
);
```

### 2. Track API Calls
```dart
final data = await PerformanceService().traceApiCall(
  'fetch_ipos',
  () => apiClient.getIpos(),
  parameters: {'category': 'open', 'limit': '50'},
);
```

### 3. Track Screen Performance
```dart
class IPODetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PerformanceScreenTracker(
      screenName: 'IPO_Details',
      attributes: {'ipo_id': ipoId},
      child: Scaffold(...),
    );
  }
}
```

### 4. Track Database Operations
```dart
final users = await PerformanceService().traceDatabaseOperation(
  'fetch_users',
  () => database.getUsers(),
  tableName: 'users',
  recordCount: 50,
);
```

### 5. Track Authentication
```dart
await PerformanceService().traceAuth(
  'phone_login',
  () => authService.loginWithPhone(phoneNumber),
);
```

### 6. Track Navigation
```dart
await PerformanceService().traceNavigation(
  'home',
  'ipo_details',
  () => Navigator.push(context, route),
);
```

### 7. Manual Trace Control
```dart
// Start trace
final traceId = await PerformanceService().startTrace('image_processing');

// Do work...
await processImage();

// Add metrics
await PerformanceService().setTraceMetric(traceId, 'image_count', 10);
await PerformanceService().setTraceMetric(traceId, 'total_size_kb', 1024);

// Add attributes
await PerformanceService().setTraceAttribute(traceId, 'format', 'jpeg');

// Stop trace
await PerformanceService().stopTrace(traceId);
```

### 8. Track Feature Initialization
```dart
await PerformanceService().traceFeatureInit(
  'payment_gateway',
  () => initializePaymentGateway(),
);
```

### 9. Extension Method (Easy Way)
```dart
final data = await fetchData().trackPerformance(
  'fetch_dashboard_data',
  attributes: {'user_type': 'premium'},
  metrics: {'cache_hit': 1},
);
```

### 10. Combined Tracking (Performance + Crashlytics)
```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CombinedScreenTracker(
      screenName: 'IPO_Application',
      metadata: {'ipo_id': '123', 'amount': 50000},
      child: Scaffold(...),
    );
  }
}
```

## 📊 What You'll See in Firebase Console

### Performance Dashboard Shows:

#### Traces Section:
- **Custom traces**: Your named operations (e.g., `api_fetch_ipos`, `screen_IPO_Details`)
- **Duration statistics**: Min, max, median, 95th percentile
- **Success rate**: How many completed successfully
- **Frequency**: How often they occur

#### Network Requests Section:
- **All HTTP calls**: Automatically captured
- **Response times**: By endpoint
- **Success rates**: By status code
- **Payload sizes**: Request and response

#### Screen Rendering:
- **First input delay**: How fast UI responds
- **Frame rendering times**: Jank detection
- **Frozen frames**: UI freezes

### Example Metrics You'll See:
```
Custom Traces:
- api_open_ipos: 245ms avg, 450ms p95
- api_upcoming_ipos: 198ms avg, 380ms p95
- screen_IPO_Details: 1.2s avg render time
- auth_phone_login: 3.4s avg

Network Requests:
- GET /ipo/open: 220ms avg, 95% success
- GET /ipo/upcoming: 195ms avg, 98% success
- POST /auth/login: 1.8s avg, 99% success
```

## 🚀 Best Practices

### DO:
✅ Track important user flows (login, IPO application, payment)
✅ Track slow operations (API calls, database queries)
✅ Add meaningful attributes (user_type, category, amount)
✅ Add relevant metrics (item_count, data_size, retry_count)
✅ Use descriptive trace names (snake_case recommended)
✅ Track screen performance for key screens

### DON'T:
❌ Track every tiny operation (creates noise)
❌ Use very long trace names (keep under 100 chars)
❌ Add sensitive data in attributes
❌ Create thousands of unique trace names
❌ Track operations under 100ms (too fast to matter)
❌ Forget to stop traces (causes memory leaks)

## 🎨 Naming Conventions

### Recommended Patterns:
```dart
// Screens
'screen_IPO_Details'
'screen_User_Profile'

// API calls
'api_fetch_ipos'
'api_submit_application'

// Database
'db_insert_user'
'db_query_transactions'

// Authentication
'auth_phone_login'
'auth_verify_otp'

// Features
'init_payment_gateway'
'load_user_preferences'
```

## 🔍 Monitoring Strategy

### Critical Paths to Track:

#### 1. User Onboarding
```dart
await PerformanceService().traceAuth('registration', () => register());
await PerformanceService().traceAuth('kyc_verification', () => verifyKYC());
```

#### 2. IPO Flow
```dart
// Browse IPOs
await PerformanceService().traceApiCall('fetch_ipos', () => getIPOs());

// View details
final traceId = await PerformanceService().startScreenTrace('IPO_Details');

// Apply to IPO
await PerformanceService().trace('ipo_application', () => applyToIPO());
```

#### 3. Payment Flow
```dart
await PerformanceService().traceFeatureInit('payment', () => initPayment());
await PerformanceService().trace('process_payment', () => processPayment());
```

### Performance Budgets:

Set goals for key operations:
- API calls: < 500ms
- Screen rendering: < 1s
- Authentication: < 3s
- Database queries: < 200ms
- Image loading: < 300ms

## 🐛 Debugging Slow Performance

### Finding Bottlenecks:

1. **Check Firebase Console** → Performance → Traces
2. **Sort by duration** (95th percentile)
3. **Look for outliers** (operations taking 2-3x longer than median)
4. **Check attributes** to identify patterns (e.g., slow only for specific categories)
5. **Review network requests** for slow APIs

### Common Issues:

#### Slow API Calls:
- Check response payload size
- Consider pagination/limiting data
- Implement caching
- Review server performance

#### Slow Screen Rendering:
- Reduce widget rebuilds
- Use `const` constructors
- Implement lazy loading
- Optimize images (compression, caching)

#### Slow Database Operations:
- Add database indexes
- Reduce query complexity
- Implement batch operations
- Consider local caching

## 📈 Advanced Usage

### Custom Metrics for Business Logic:
```dart
final traceId = await PerformanceService().startTrace('ipo_application');

// Track business metrics
await PerformanceService().setTraceMetric(traceId, 'amount_invested', 50000);
await PerformanceService().setTraceMetric(traceId, 'lot_size', 10);
await PerformanceService().setTraceAttribute(traceId, 'payment_method', 'upi');

await submitApplication();
await PerformanceService().stopTrace(traceId);
```

### Conditional Tracking:
```dart
// Only track for specific scenarios
if (isNewUser || isHighValueTransaction) {
  await PerformanceService().trace('special_flow', () => processFlow());
}
```

### Tracking with Retry Logic:
```dart
final traceId = await PerformanceService().startTrace('api_with_retry');
int retryCount = 0;

while (retryCount < 3) {
  try {
    final result = await apiCall();
    await PerformanceService().setTraceMetric(traceId, 'retry_count', retryCount);
    await PerformanceService().stopTrace(traceId);
    return result;
  } catch (e) {
    retryCount++;
  }
}
```

## 📝 Integration Checklist

- [x] Firebase Performance dependency added
- [x] Firebase Performance initialized in main.dart
- [x] PerformanceService created
- [x] HTTP client wrapped for automatic tracking
- [x] API calls tracked in OpenIposProvider
- [x] App startup time tracked
- [x] Helper widgets created (PerformanceScreenTracker, CombinedScreenTracker)
- [ ] Add screen trackers to key screens (you should do)
- [ ] Track authentication flows (you should do)
- [ ] Track payment flows (you should do)
- [ ] Build and release app to see data (you need to do)
- [ ] Monitor Firebase Console regularly (ongoing)

## 🎓 Additional Resources

- [Firebase Performance Docs](https://firebase.google.com/docs/perf-mon)
- [Flutter Performance Package](https://pub.dev/packages/firebase_performance)
- [Performance Best Practices](https://firebase.google.com/docs/perf-mon/best-practices)
- [Understanding Performance Data](https://firebase.google.com/docs/perf-mon/get-started-flutter)

## ⚡ Quick Reference

### Start/Stop Trace:
```dart
final id = await PerformanceService().startTrace('my_trace');
// ... do work ...
await PerformanceService().stopTrace(id);
```

### One-line Wrapper:
```dart
await PerformanceService().trace('my_operation', () => doWork());
```

### Extension Method:
```dart
await myAsyncOperation().trackPerformance('operation_name');
```

### Screen Tracking:
```dart
return PerformanceScreenTracker(
  screenName: 'My_Screen',
  child: Scaffold(...),
);
```

---

**Ready to monitor!** 🚀 Your app now automatically tracks all HTTP requests and you can add custom traces for any operation. Data will appear in Firebase Console after 12-24 hours of real usage.
