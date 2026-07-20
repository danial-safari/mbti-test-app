# MBTI Test

A simple MBTI personality test Flutter application that uses the [Personality FYI API](https://personality.fyi) to determine your MBTI personality type.

## Features

- **Splash Screen** — Animated splash with auto-navigation
- **Home Screen** — Hero banner, start test button, and grid of all 16 MBTI personality types
- **Personality Test** — 32 Likert-scale questions fetched from API, with auto-advance on answer selection
- **Result Screen** — Displays your MBTI type with a confidence bar chart, share functionality, and navigation to details
- **Personality Detail Screen** — Tabbed view with strengths, weaknesses, career suggestions, and famous people for each type
- **RTL Support** — Full right-to-left layout for Persian (Farsi) text
- **Dark Mode** — Supports system light/dark theme

## Project Structure

```
lib/
├── main.dart                          # App entry point, theme, routing
├── utils/
│   └── constants.dart                 # Colors, API URL, MBTI type definitions
├── models/
│   ├── test_item.dart                 # Test question model
│   └── score_response.dart            # API result model
├── services/
│   └── api_service.dart               # HTTP GET & POST requests
└── screens/
    ├── splash_screen.dart             # Animated splash screen
    ├── home_screen.dart               # Home with type grid
    ├── test_screen.dart               # Questions with Likert scale
    ├── result_screen.dart             # Result with chart & share
    └── personality_detail_screen.dart  # Tabbed type details
```

## Key Flutter Concepts

| Concept | Where Used |
|---------|-----------|
| **StatefulWidget** | `SplashScreen`, `TestScreen`, `PersonalityDetailScreen` |
| **StatelessWidget** | `HomeScreen`, `ResultScreen` |
| **Named Routes & Navigation** | `Navigator.pushNamed`, `pushReplacementNamed`, `popUntil` |
| **HTTP Requests** | `http` package — GET for questions, POST for scoring |
| **Async/Await** | API calls with loading states and error handling |
| **Animations** | `flutter_animate` for fade-in and slide effects |
| **Charts** | `fl_chart` for confidence bar chart |
| **TabBar** | `TabController` with `TabBarView` in detail screen |
| **Share** | `share_plus` for sharing personality results |

## API

The app uses the **Personality FYI API**:

- **Base URL:** `https://personality.fyi/api/v1`
- **GET `/test/items`** — Returns 32 test questions with Likert scale axes
- **POST `/test/score`** — Accepts an array of 32 answers (1-5), returns personality type and confidence scores

## Dependencies

| Package | Purpose |
|---------|---------|
| `http` | HTTP requests to API |
| `flutter_animate` | UI animations |
| `share_plus` | Share results |
| `fl_chart` | Confidence bar chart |

## Getting Started

### Prerequisites

- Flutter SDK `>=3.16.0`
- Dart SDK `>=3.2.0`
- Android SDK (for building APK)
- Java 21 (for Gradle builds)

### Install

```bash
git clone https://github.com/danial-safari/mbti-test-app.git
cd mbti-test-app
flutter pub get
flutter run
```

### Run in Chrome (Web)

```bash
flutter run -d chrome
```

To build a release version for web:

```bash
flutter build web
```

The web build will be in `build/web/`. You can serve it locally:

```bash
cd build/web
python3 -m http.server 8000
```

Then open `http://localhost:8000` in Chrome.

> **Note:** If Chrome is not detected, list available devices with `flutter devices` and use the correct device ID (e.g., `flutter run -d chrome` or `flutter run -d web-server`).

### Build APK

```bash
export JAVA_HOME="/opt/homebrew/opt/openjdk@21"
export PATH="$JAVA_HOME/bin:$PATH"
export ANDROID_HOME=/opt/homebrew/share/android-commandlinetools
flutter build apk --release
```

The APK will be at `build/app/outputs/flutter-apk/app-release.apk`.

## License

This project is for educational purposes.