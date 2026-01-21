import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:ipo_lens/core/routes/app_router.dart';
import 'package:ipo_lens/core/services/app_update_service.dart';
import 'package:ipo_lens/core/services/crashlytics_service.dart';
import 'package:ipo_lens/core/services/performance_service.dart';
import 'package:ipo_lens/core/theme/app_theme.dart';
import 'package:ipo_lens/features/open-ipos/Provider/open_ipos_provider.dart';
import 'package:ipo_lens/firebase_options.dart';
import 'package:ipo_lens/utils/consts/app_preference.dart';
import 'package:ipo_lens/utils/consts/api_endpoints.dart';
import 'package:ipo_lens/utils/providers/bottom_nav_provider.dart';
import 'package:ipo_lens/utils/theme/theme_provider.dart';
import 'package:ipo_lens/utils/wigets/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;

// ...

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize critical services in parallel for faster startup
  final results = await Future.wait([
    AppPreference.initMySharedPreferences(),
    _initializeFirebase(),
  ]);
  
  final firebaseAvailable = results[1] as bool;

  // Start app immediately, initialize other services in background
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => BottomNavProvider()),

        Provider<http.Client>(
          create: (_) {
            final baseClient = http.Client();
            // Wrap with Performance Monitoring if available
            return firebaseAvailable 
                ? PerformanceService().wrapHttpClient(baseClient)
                : baseClient;
          },
          dispose: (_, client) => client.close(),
        ),
        ChangeNotifierProvider(
          create: (context) => OpenIposProvider(
            client: context.read<http.Client>(),
            baseUrl: ApiEndpoints.ipoLensBaseUrl,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

Future<bool> _initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Set up error handlers immediately
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    // Initialize services in background (non-blocking)
    _initializeFirebaseServices();
    
    return true;
  } catch (e) {
    debugPrint('❌ Firebase initialization failed: $e');
    FlutterError.onError = FlutterError.presentError;
    return false;
  }
}

Future<void> _initializeFirebaseServices() async {
  // Run all Firebase service initializations in parallel
  await Future.wait([
    _initCrashlytics(),
    _initPerformance(),
    _initRemoteConfig(),
  ], eagerError: false);
}

Future<void> _initCrashlytics() async {
  try {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    await CrashlyticsService().initialize();
    await CrashlyticsService().log('App started');
    await CrashlyticsService().setCustomKey('app_version', '1.0.0');
    debugPrint('✅ Crashlytics initialized');
  } catch (e) {
    debugPrint('❌ Crashlytics init failed: $e');
  }
}

Future<void> _initPerformance() async {
  try {
    await Future.delayed(const Duration(milliseconds: 100));
    await PerformanceService().initialize();
    debugPrint('✅ Performance Monitoring initialized');
  } catch (e) {
    debugPrint('❌ Performance init failed: $e');
  }
}

Future<void> _initRemoteConfig() async {
  try {
    await AppUpdateService().initialize();
    debugPrint('✅ Remote Config initialized');
  } catch (e) {
    debugPrint('❌ Remote Config init failed: $e');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    // // Initialize Finvu SDK
    // if (!_finvuInitialized) {
    //   final finvuProvider = Provider.of<FinvuProvider>(context, listen: false);
    //   finvuProvider.initializeSDK();
    //   Future.delayed(const Duration(microseconds: 500), () {
    //     finvuProvider.connectToService();
    //   });
    //   _finvuInitialized = true;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, appProvider, _) {
        return MaterialApp.router(
          title: 'Portfolio Tracker',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: appProvider.themeMode,
          scaffoldMessengerKey: CustomSnackBar.messengerKey,
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
