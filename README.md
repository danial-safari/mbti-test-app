# Personality FYI - MBTI Personality Test App

A production-ready, cross-platform Flutter application for MBTI personality testing powered by the [Personality FYI API](https://personality.fyi/api/). Supports Android, iOS, and Web with full Persian (Farsi) localization and RTL layout support.

---

## Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Setup](#setup)
- [Running the App](#running-the-app)
  - [Web](#web)
  - [Android APK](#android-apk)
  - [Android App Bundle (AAB)](#android-app-bundle-aab)
  - [iOS](#ios)
- [Environment Variables](#environment-variables)
- [Testing](#testing)
- [Localization](#localization)
- [API Reference](#api-reference)
- [Troubleshooting](#troubleshooting)

---

## Features

### Core
- **MBTI Personality Test** - 32 scientifically-backed OEJTS questions fetched from the Personality FYI API
- **One-at-a-time question display** with smooth animated transitions
- **Progress tracking** during the test
- **Back navigation** to change previous answers
- **Personality Result** showing type code, title, description, strengths, weaknesses, cognitive functions, and energy drains

### Extended
- **Career Suggestions** per personality type (static supplementary data)
- **Famous People** with the same type
- **Growth Recommendations** tailored to each type
- **Relationship Compatibility** information
- **Compatibility Checker** - compare any two MBTI types with a visual score
- **Test History** - save and review past results locally
- **Share Results** via native share sheet
- **Personality Type Explorer** - browse all 16 types with full detail tabs

### Persian Translation
- All API response content (descriptions, strengths, weaknesses, etc.) is automatically translated to Persian at **presentation time only**
- Original API data is never modified or stored as translated
- Both original and translated text are cached separately in Hive
- Full **RTL layout** support when Persian is selected
- Seamless language switching between English and Persian

### UI/UX
- **Material 3** design system
- **Dark mode** and **Light mode** with system default option
- **Responsive layout** for mobile, tablet, and web
- **Smooth animations** using `flutter_animate`
- **Bar charts** for confidence visualization using `fl_chart`
- **Vazirmatn** font for beautiful Persian typography

---

## Architecture

The project follows **Clean Architecture** with three layers:

```
┌─────────────────────────────────────┐
│        Presentation Layer           │
│  (Screens, Widgets, Providers)      │
├─────────────────────────────────────┤
│          Domain Layer               │
│  (Entities, Use Cases, Repositories)│
├─────────────────────────────────────┤
│           Data Layer                │
│  (Models, Datasources, Repositories)│
├─────────────────────────────────────┤
│         Core / Infrastructure       │
│  (Network, Storage, DI, Utils)      │
└─────────────────────────────────────┘
```

**State Management:** Riverpod  
**Dependency Injection:** GetIt  
**Routing:** GoRouter  

---

## Tech Stack

| Category | Package | Version |
|---|---|---|
| State Management | `flutter_riverpod` | ^2.4.9 |
| Networking | `dio` | ^5.4.0 |
| Local Storage | `hive` + `hive_flutter` | ^2.2.3 |
| Dependency Injection | `get_it` | ^7.6.7 |
| Routing | `go_router` | ^13.0.1 |
| Environment | `flutter_dotenv` | ^5.1.0 |
| Charts | `fl_chart` | ^0.66.2 |
| Animations | `flutter_animate` | ^4.3.0 |
| Functional | `dartz` | ^0.10.1 |
| Share | `share_plus` | ^7.2.1 |
| Connectivity | `connectivity_plus` | ^5.0.2 |
| PDF | `pdf` + `printing` | ^3.10.7 / ^5.12.0 |

---

## Project Structure

```
food/
├── .env                              # Environment variables
├── analysis_options.yaml             # Lint rules
├── pubspec.yaml                      # Dependencies
│
├── assets/
│   ├── fonts/                        # Vazirmatn font files
│   └── images/                       # App images
│
├── lib/
│   ├── main.dart                     # App entry point
│   ├── app.dart                      # MaterialApp configuration
│   │
│   ├── config/
│   │   ├── env_config.dart           # Environment configuration
│   │   ├── app_theme.dart            # Material 3 theme (light/dark)
│   │   └── app_router.dart           # GoRouter route definitions
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── api_constants.dart    # API endpoints
│   │   │   └── app_constants.dart    # App-wide constants
│   │   ├── errors/
│   │   │   ├── exceptions.dart       # Custom exceptions
│   │   │   └── failures.dart         # Sealed failure classes
│   │   ├── network/
│   │   │   ├── dio_client.dart       # Configured Dio HTTP client
│   │   │   └── network_info.dart     # Connectivity checker
│   │   └── utils/
│   │       └── translation_service.dart # Persian translation with caching
│   │
│   ├── data/
│   │   ├── datasources/
│   │   │   ├── personality_remote_datasource.dart  # API calls
│   │   │   └── personality_local_datasource.dart   # Hive storage
│   │   ├── models/
│   │   │   ├── mbti_type_model.dart
│   │   │   ├── mbti_type_detail_model.dart
│   │   │   ├── test_item_model.dart
│   │   │   ├── score_response_model.dart
│   │   │   └── test_result_model.dart
│   │   ├── repositories/
│   │   │   └── personality_repository_impl.dart
│   │   └── static/
│   │       └── personality_static_data.dart  # Careers, famous people, etc.
│   │
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── mbti_type.dart
│   │   │   ├── mbti_type_detail.dart
│   │   │   ├── test_item.dart
│   │   │   ├── score_response.dart
│   │   │   └── test_result.dart
│   │   ├── repositories/
│   │   │   └── personality_repository.dart    # Abstract interface
│   │   └── usecases/
│   │       ├── get_all_types.dart
│   │       ├── get_type_details.dart
│   │       ├── get_test_items.dart
│   │       ├── score_test.dart
│   │       ├── get_history.dart
│   │       ├── save_result.dart
│   │       ├── get_personality_details.dart
│   │       └── compare_types.dart
│   │
│   ├── di/
│   │   └── injection_container.dart   # GetIt setup
│   │
│   ├── l10n/
│   │   └── app_localizations.dart     # English & Persian strings
│   │
│   └── presentation/
│       ├── providers/
│       │   ├── settings_provider.dart      # Language, theme, onboarding
│       │   ├── test_provider.dart          # Test flow state machine
│       │   ├── history_provider.dart       # Saved results management
│       │   └── translation_provider.dart   # Dynamic content translation
│       ├── screens/
│       │   ├── splash_screen.dart
│       │   ├── onboarding_screen.dart
│       │   ├── home_screen.dart
│       │   ├── test_screen.dart
│       │   ├── result_screen.dart
│       │   ├── personality_detail_screen.dart
│       │   ├── history_screen.dart
│       │   ├── settings_screen.dart
│       │   ├── about_screen.dart
│       │   └── compatibility_screen.dart
│       └── widgets/
│           ├── personality_type_badge.dart
│           └── question_card.dart
│
└── test/
    ├── data/repositories/
    │   └── personality_repository_impl_test.dart
    ├── domain/usecases/
    │   └── get_all_types_test.dart
    └── presentation/screens/
        └── home_screen_test.dart
```

---

## Prerequisites

- **Flutter SDK** >= 3.16.0 (latest stable)
- **Dart SDK** >= 3.2.0
- **Android Studio** or **VS Code** with Flutter plugins
- **Xcode** >= 15.0 (for iOS builds, macOS only)
- **CocoaPods** (for iOS dependencies)
- **Chrome** (for web development)
- A physical device or emulator for testing

Check your Flutter installation:

```bash
flutter doctor
```

---

## Setup

### 1. Clone the project

```bash
cd /Users/danial/Documents/projects/food
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Download the Vazirmatn font

Download from [Google Fonts](https://fonts.google.com/specimen/Vazirmatn) and place these files in `assets/fonts/`:

- `Vazirmatn-Light.ttf` (weight 300)
- `Vazirmatn-Regular.ttf`
- `Vazirmatn-Medium.ttf` (weight 500)
- `Vazirmatn-Bold.ttf` (weight 700)

### 4. Create .env file

The `.env` file already exists. Verify it contains:

```
API_BASE_URL=https://personality.fyi/api/v1
API_TIMEOUT=30000
APP_NAME=Personality FYI
APP_VERSION=1.0.0
```

### 5. Generate Hive adapters (if needed)

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Running the App

### Web

#### Development (Chrome)

```bash
flutter run -d chrome
```

#### Development (with specific port)

```bash
flutter run -d chrome --web-port=8080
```

#### Build for Production

```bash
flutter build web --release --web-renderer html
```

The build output is in `build/web/`. To serve locally:

```bash
cd build/web
python3 -m http.server 8000
```

Then open `http://localhost:8000` in your browser.

#### Deploy to Firebase Hosting

```bash
npm install -g firebase-tools
firebase init hosting
firebase deploy
```

#### Deploy to GitHub Pages

```bash
flutter build web --base-href "/your-repo-name/"
# Copy build/web/ contents to your gh-pages branch
```

---

### Android APK

#### Debug APK

```bash
flutter build apk --debug
```

Output: `build/app/outputs/flutter-apk/app-debug.apk`

#### Release APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

#### Split APKs (recommended for smaller size per ABI)

```bash
flutter build apk --split-per-abi
```

Output files:
- `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk`
- `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`
- `build/app/outputs/flutter-apk/app-x86_64-release.apk`

#### Install on a connected device

```bash
flutter install
```

Or:

```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

#### Android Signing

For release builds, create a signing key:

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Then configure `android/key.properties`:

```properties
storePassword=<your-password>
keyPassword=<your-password>
keyAlias=upload
storeFile=<path-to-upload-keystore.jks>
```

And update `android/app/build.gradle` to use the signing config.

---

### Android App Bundle (AAB)

For Google Play Store submission:

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

This AAB includes all supported ABIs (armeabi-v7a, arm64-v8a, x86_64). Google Play will serve optimized APKs to each device.

#### Verify the bundle

```bash
bundletool build-apks --bundle=build/app/outputs/bundle/release/app-release.aab \
  --output=app.apks
```

---

### iOS

#### Prerequisites

- macOS with Xcode 15+ installed
- CocoaPods installed (`sudo gem install cocoapods`)
- Apple Developer account (for device testing and App Store)

#### Install iOS dependencies

```bash
cd ios
pod install
cd ..
```

#### Run on Simulator

```bash
flutter run -d iPhone
```

To list available simulators:

```bash
xcrun simctl list devices
```

Run on a specific simulator:

```bash
flutter run -d "iPhone 15 Pro"
```

#### Run on Physical Device

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select your team under Signing & Capabilities
3. Set a unique Bundle Identifier
4. Connect your device and select it as the target
5. Run:

```bash
flutter run -d <device-id>
```

#### Build IPA (Release)

```bash
flutter build ipa --release
```

Output: `build/ios/ipa/personality_fyi_app.ipa`

#### Archive for App Store

1. Open Xcode:

```bash
open ios/Runner.xcworkspace
```

2. Select **Product > Archive**
3. Once archiving completes, click **Distribute App**
4. Choose **App Store Connect** and follow the prompts

Or use the command line:

```bash
flutter build ipa --export-options-plist=ios/ExportOptions.plist
```

#### Upload to App Store

Using `altool`:

```bash
xcrun altool --upload-app \
  --type ios \
  --file build/ios/ipa/personality_fyi_app.ipa \
  --apiKey <your-api-key> \
  --apiIssuer <your-issuer-id>
```

Or using Transporter app from the Mac App Store.

---

## Environment Variables

All configuration is in the `.env` file at the project root:

| Variable | Description | Default |
|---|---|---|
| `API_BASE_URL` | Personality FYI API base URL | `https://personality.fyi/api/v1` |
| `API_TIMEOUT` | Request timeout in milliseconds | `30000` |
| `APP_NAME` | Application display name | `Personality FYI` |
| `APP_VERSION` | Application version string | `1.0.0` |

---

## Testing

### Run all tests

```bash
flutter test
```

### Run with coverage

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Run specific test files

```bash
flutter test test/domain/usecases/get_all_types_test.dart
flutter test test/data/repositories/personality_repository_impl_test.dart
flutter test test/presentation/screens/home_screen_test.dart
```

### Widget tests

```bash
flutter test test/presentation/
```

---

## Localization

### Supported Languages

| Language | Code | Direction |
|---|---|---|
| English | `en_US` | LTR |
| Persian (فارسی) | `fa_IR` | RTL |

### How Translation Works

1. **UI Strings** (buttons, labels, titles) are managed via `AppLocalizations` with hardcoded English and Persian maps
2. **API Content** (personality descriptions, strengths, weaknesses, careers) is translated at presentation time using `TranslationService`
3. **Caching**: Translations are cached in Hive (`translation_cache` box) to avoid re-translating
4. **Original Data**: The API response is stored unchanged; only the display layer applies translation

### Adding a New Language

1. Add a new locale map in `lib/l10n/app_localizations.dart`
2. Add the locale to `supportedLocales` in `lib/app.dart`
3. Add translations in the `_localizedStrings` map
4. Add font support if needed (e.g., for Arabic script)

---

## API Reference

This app uses the [Personality FYI API](https://personality.fyi/api/) (free, no auth, CC0 public domain).

### Endpoints Used

| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/v1/types` | List all 16 MBTI types |
| GET | `/api/v1/types/{CODE}` | Full profile for one type |
| GET | `/api/v1/test/items` | 32 OEJTS test questions |
| POST | `/api/v1/test/score` | Score answers and get MBTI type |

### Rate Limits

No hard rate limits. The API recommends staying under ~1,000 requests/minute sustained.

### Data Not in API

The following features use **static data** maintained in `lib/data/static/personality_static_data.dart`:

- Career suggestions per type
- Famous people per type
- Growth recommendations per type
- Relationship compatibility scores
- Relationship descriptions

---

## Troubleshooting

### Common Issues

#### `flutter pub get` fails

```bash
flutter clean
flutter pub get
```

#### Hive adapter not registered

```bash
dart run build_runner build --delete-conflicting-outputs
```

#### iOS build fails with CocoaPods error

```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter build ios
```

#### Web build shows blank page

Make sure you're using the HTML renderer for compatibility:

```bash
flutter build web --web-renderer html
```

#### Font not loading

Ensure the Vazirmatn font files are placed in `assets/fonts/` with the exact filenames specified in `pubspec.yaml`.

#### API not reachable

Check that `API_BASE_URL` in `.env` is correct and your device has internet access. The app checks connectivity before making API calls.

#### Persian text not displaying correctly

Ensure the Vazirmatn font files are included. The app uses `fontFamily: 'Vazirmatn'` for all text.

---

## Build Summary

| Platform | Command | Output |
|---|---|---|
| Web (dev) | `flutter run -d chrome` | Chrome browser |
| Web (release) | `flutter build web --release` | `build/web/` |
| Android APK | `flutter build apk --release` | `build/app/outputs/flutter-apk/app-release.apk` |
| Android AAB | `flutter build appbundle --release` | `build/app/outputs/bundle/release/app-release.aab` |
| iOS (dev) | `flutter run -d iPhone` | Simulator |
| iOS (release) | `flutter build ipa --release` | `build/ios/ipa/*.ipa` |
| Tests | `flutter test` | Test results |

---

## License

- Application code: MIT License
- API data: CC0 (Public Domain) from [Personality FYI](https://personality.fyi/)
- OEJTS test items: Public Domain (Eric Jorgenson)
- Vazirmatn font: OFL (Open Font License)

---

## Credits

- **API**: [Personality FYI](https://personality.fyi/api/) - Free MBTI personality API
- **Test Methodology**: OEJTS 1.2 (Open Extended Jungian Type Scales)
- **Font**: [Vazirmatn](https://fonts.google.com/specimen/Vazirmatn) by Saber Rastikerdar

---

## Support

For issues or questions:
- Check the [Personality FYI API docs](https://personality.fyi/api/)
- Email: hello@personality.fyi
