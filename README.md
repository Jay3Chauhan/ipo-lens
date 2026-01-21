# IPO Lens 📊

A comprehensive Flutter application for tracking and analyzing Initial Public Offerings (IPOs) in the Indian stock market. Stay updated with live IPO data, GMP trends, share allocations, and make informed investment decisions.

## Features ✨

### 📈 IPO Tracking
- **Open IPOs**: View currently open IPOs with real-time data
- **Upcoming IPOs**: Stay ahead with information about upcoming listings
- **Listed IPOs**: Track performance of recently listed companies
- **IPO Details**: Comprehensive information including price bands, lot sizes, and subscription data

### 🔥 Firebase Integration
- **Remote Config**: Dynamic app configuration and feature flags
- **Crashlytics**: Automatic crash reporting and error tracking
- **Performance Monitoring**: Real-time app performance metrics and custom traces
- **Analytics**: User behavior tracking and engagement metrics

### 🔄 App Update Management
- **Flexible Updates**: Optional updates with skip option
- **Force Updates**: Mandatory updates for critical releases
- **Maintenance Mode**: Display maintenance screen when needed
- **Version Control**: Automatic version checking via Firebase Remote Config

### 🎨 Modern UI/UX
- Beautiful, custom-themed interface
- Smooth animations and transitions
- Dark mode support
- Responsive design for all screen sizes
- Pull-to-refresh functionality
- Bottom navigation for easy access

### 📊 IPO Analytics
- GMP (Grey Market Premium) trends
- Peer comparison analysis
- Share allocation statistics
- Subscription data tracking

## Tech Stack 🛠️

- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: Provider
- **Routing**: go_router
- **Backend Services**: 
  - Firebase Core
  - Firebase Remote Config
  - Firebase Crashlytics
  - Firebase Performance Monitoring
  - Firebase Analytics
- **Storage**: 
  - SharedPreferences (local data)
  - Flutter Secure Storage (sensitive data)
  - SQLite (sqflite for local database)
- **Network**: HTTP client with Firebase Performance instrumentation
- **UI Components**: 
  - Custom widgets and animations
  - Lottie animations
  - Custom theme system

## Project Structure 📁

```
lib/
├── core/
│   ├── routes/           # App routing configuration
│   ├── services/         # Firebase and core services
│   │   ├── remote_config_service.dart
│   │   ├── crashlytics_service.dart
│   │   ├── performance_service.dart
│   │   └── app_update_service.dart
│   ├── theme/            # App theming
│   └── widgets/          # Reusable core widgets
│       ├── maintenance_screen.dart
│       ├── update_checker.dart
│       ├── crashlytics_tracker.dart
│       └── performance_tracker.dart
├── features/
│   ├── open-ipos/        # IPO listing and details
│   ├── bids/             # Bid management
│   └── settings/         # App settings
├── utils/
│   ├── consts/           # Constants and API endpoints
│   ├── theme/            # Theme extensions
│   └── widgets/          # Utility widgets
└── main.dart             # App entry point

docs/
├── FIREBASE_REMOTE_CONFIG_SETUP.md
├── CRASHLYTICS_SETUP.md
├── FIREBASE_PERFORMANCE_SETUP.md
├── CRASHLYTICS_INTEGRATION_COMPLETE.md
├── FIREBASE_PERFORMANCE_COMPLETE.md
└── QUICK_REFERENCE.md
```

## Getting Started 🚀

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code
- Firebase account
- Android SDK / Xcode (for iOS)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Jay3Chauhan/ipo-lens.git
   cd ipo-lens
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Add Android and iOS apps to your Firebase project
   - Download and place `google-services.json` in `android/app/`
   - Download and place `GoogleService-Info.plist` in `ios/Runner/`
   - Run Firebase CLI configuration:
     ```bash
     flutterfire configure
     ```

4. **Configure Firebase Remote Config**
   - Go to Firebase Console → Remote Config
   - Add the following parameters:
     - `min_app_version` (String): Minimum required version
     - `latest_app_version` (String): Latest available version
     - `force_update_enabled` (Boolean): Enable force update
     - `force_update_message` (String): Force update message
     - `update_message` (String): Flexible update message
     - `maintenance_mode` (Boolean): Enable maintenance mode
     - `maintenance_message` (String): Maintenance screen message
   
   See [docs/FIREBASE_REMOTE_CONFIG_SETUP.md](docs/FIREBASE_REMOTE_CONFIG_SETUP.md) for detailed setup.

5. **Run the app**
   ```bash
   flutter run
   ```

## Firebase Services Configuration 🔧

### Remote Config
Controls app behavior without requiring app updates:
- Version management
- Feature flags
- Update prompts
- Maintenance mode

### Crashlytics
Automatic crash reporting and error tracking:
- Real-time crash alerts
- Custom error logging
- User identification
- Custom keys for debugging

### Performance Monitoring
Track app performance metrics:
- Custom traces for critical operations
- Automatic HTTP request monitoring
- Screen rendering performance
- Network latency tracking

For detailed setup instructions, see the documentation in the `docs/` folder.

## Building for Production 🏗️

### Android
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Documentation 📚

Comprehensive documentation is available in the `docs/` directory:
- [Firebase Remote Config Setup](docs/FIREBASE_REMOTE_CONFIG_SETUP.md)
- [Crashlytics Setup](docs/CRASHLYTICS_SETUP.md)
- [Performance Monitoring Setup](docs/FIREBASE_PERFORMANCE_SETUP.md)
- [Quick Reference Guide](docs/QUICK_REFERENCE.md)

## Features in Development 🚧

- [ ] Push notifications for IPO updates
- [ ] Advanced analytics dashboard
- [ ] IPO comparison tool
- [ ] Portfolio tracking
- [ ] Price alerts
- [ ] Social sharing features

## Contributing 🤝

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License 📄

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact 📧

Jay Chauhan - [@Jay3Chauhan](https://github.com/Jay3Chauhan)

Project Link: [https://github.com/Jay3Chauhan/ipo-lens](https://github.com/Jay3Chauhan/ipo-lens)

## Acknowledgments 🙏

- Flutter team for the amazing framework
- Firebase for robust backend services
- All contributors and supporters

---

Made with ❤️ using Flutter
