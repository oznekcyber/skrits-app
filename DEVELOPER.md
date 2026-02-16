# Developer Documentation - Skrits App

## 🏗️ Architecture Overview

### Tech Stack
- **Framework**: Flutter 3.0+
- **Language**: Dart 3.0+
- **State Management**: Provider
- **Local Storage**: SharedPreferences + Hive
- **Platform**: Android (Pixel 9a target)

### Design Pattern
- MVVM (Model-View-ViewModel) with Provider
- Separation of concerns
- Reactive state management

---

## 📁 Project Structure

```
skrits-app/
├── android/                    # Android platform code
│   ├── app/
│   │   ├── build.gradle       # App-level Gradle config
│   │   └── src/main/
│   │       ├── kotlin/        # MainActivity
│   │       ├── AndroidManifest.xml
│   │       └── res/           # Android resources
│   ├── build.gradle           # Project-level Gradle
│   └── gradle.properties
│
├── assets/                     # Static assets
│   ├── images/
│   └── fonts/
│
├── lib/                        # Flutter source code
│   ├── main.dart              # App entry point
│   ├── theme.dart             # Theme configuration
│   │
│   ├── models/                # Data models
│   │   ├── topic.dart         # Topic model
│   │   ├── flashcard.dart     # Flashcard model
│   │   └── study_session.dart # Session model
│   │
│   ├── providers/             # State management
│   │   ├── app_state_provider.dart    # App-level state
│   │   └── topics_provider.dart       # Topics & flashcards
│   │
│   └── screens/               # UI screens
│       ├── splash_screen.dart
│       ├── hook_screen.dart
│       ├── auth_screen.dart
│       ├── dashboard_screen.dart
│       ├── create_topic_screen.dart
│       ├── feed_screen.dart
│       ├── progress_screen.dart
│       └── settings_screen.dart
│
├── test/                       # Unit & widget tests
├── pubspec.yaml               # Dependencies
├── analysis_options.yaml      # Linter rules
├── README.md                  # Project overview
├── USER_GUIDE.md             # End-user documentation
└── DEVELOPER.md              # This file
```

---

## 🔧 Setup Instructions

### Prerequisites
```bash
# Flutter SDK
flutter --version  # Should be 3.0.0+

# Android Studio with:
# - Android SDK
# - Android emulator or physical device
```

### Installation
```bash
# Clone repository
git clone https://github.com/oznekcyber/skrits-app.git
cd skrits-app

# Install dependencies
flutter pub get

# Run on Android
flutter run
```

### Development Mode
```bash
# Hot reload enabled
flutter run

# Run with specific device
flutter devices
flutter run -d <device-id>

# Run in debug mode
flutter run --debug

# Run in release mode
flutter run --release
```

---

## 🎨 Theme System

### Color Palette
```dart
// Primary Colors
primaryOrange: #FF6A00

// Dark Theme
darkBackground: #0A0A0A
darkCardBackground: #23170F

// Light Theme
lightBackground: #F8F7F5
lightCardBackground: #FFFFFF
```

### Theme Implementation
Located in `lib/theme.dart`:
- `AppTheme.darkTheme`: Dark mode configuration
- `AppTheme.lightTheme`: Light mode configuration
- Uses Google Fonts (Spline Sans)
- Material 3 design system

### Usage
```dart
// Access theme in widgets
Theme.of(context).colorScheme.primary
Theme.of(context).textTheme.headlineSmall
```

---

## 🔄 State Management

### Providers

#### 1. AppStateProvider
**Location**: `lib/providers/app_state_provider.dart`

**Manages**:
- Theme mode (light/dark/system)
- First launch detection
- User name

**Methods**:
```dart
setThemeMode(ThemeMode mode)
setFirstLaunchComplete()
setUserName(String name)
```

**Usage**:
```dart
// Read
context.watch<AppStateProvider>()

// Write
context.read<AppStateProvider>().setThemeMode(ThemeMode.dark)
```

#### 2. TopicsProvider
**Location**: `lib/providers/topics_provider.dart`

**Manages**:
- Topics list
- Flashcards per topic
- CRUD operations

**Methods**:
```dart
createTopic(String title, List<Flashcard> cards)
getFlashcards(String topicId)
updateTopicProgress(String id, int completed, int time)
deleteTopic(String topicId)
getMostRecentTopic()
```

**Usage**:
```dart
// Create topic
await context.read<TopicsProvider>().createTopic(
  'Machine Learning',
  flashcardsList
);

// Get flashcards
final cards = context.watch<TopicsProvider>()
  .getFlashcards(topicId);
```

---

## 📊 Data Models

### Topic Model
```dart
class Topic {
  final String id;              // UUID
  final String title;
  final DateTime createdAt;
  DateTime lastStudied;
  final int totalCards;
  int completedCards;
  int totalStudyTime;           // seconds
  
  double get completionPercentage;
}
```

### Flashcard Model
```dart
enum FlashcardType { concept, diagram, question }

class Flashcard {
  final String id;              // UUID
  final String topicId;
  final FlashcardType type;
  final String title;
  final String content;
  final String? imageUrl;       // Optional for diagram cards
  final String? answer;         // Optional for question cards
  bool isCompleted;
}
```

### StudySession Model
```dart
class StudySession {
  final String topicId;
  final DateTime startTime;
  DateTime? endTime;
  int cardsViewed;
  
  int get duration;  // Calculated in seconds
}
```

---

## 🛣️ Navigation Flow

```
SplashScreen (2-3s)
    ↓
HookScreen (first time only)
    ↓
AuthScreen
    ↓
DashboardScreen ←→ BottomNav
    ├── CreateTopicScreen → FeedScreen
    ├── ProgressScreen
    └── SettingsScreen
```

### Route Configuration
Located in `lib/main.dart`:
```dart
routes: {
  '/splash': SplashScreen,
  '/hook': HookScreen,
  '/auth': AuthScreen,
  '/dashboard': DashboardScreen,
  '/create-topic': CreateTopicScreen,
  '/progress': ProgressScreen,
  '/settings': SettingsScreen,
}

// Dynamic route
onGenerateRoute: (settings) {
  if (settings.name == '/feed') {
    return FeedScreen(topicId: settings.arguments);
  }
}
```

---

## 🎯 Key Features Implementation

### 1. Vertical Scrolling Feed

**File**: `lib/screens/feed_screen.dart`

**Implementation**:
```dart
PageView.builder(
  controller: _pageController,
  scrollDirection: Axis.vertical,
  itemCount: flashcards.length,
  onPageChanged: (index) {
    // Track progress
  },
  itemBuilder: (context, index) {
    return FlashcardView(flashcard: flashcards[index]);
  },
)
```

**Features**:
- Vertical page snapping
- Preloading for smooth scrolling
- Progress tracking
- Session management

### 2. Flashcard Generation

**File**: `lib/screens/create_topic_screen.dart`

**Current Implementation**:
- Mock AI generation with 3-second delay
- Creates 6 sample flashcards
- Mix of concept and question cards

**Future Enhancement**:
```dart
// Real AI integration
Future<List<Flashcard>> generateFlashcards(String topic) async {
  final response = await aiService.generate(topic);
  return parseFlashcards(response);
}
```

### 3. Progress Tracking

**File**: `lib/screens/progress_screen.dart`

**Metrics**:
- Total study minutes
- Number of sessions
- Average session duration
- Topics completed
- Per-topic breakdown

**Data Source**:
```dart
// Aggregated from topics
final totalMinutes = topics.fold<int>(
  0,
  (sum, topic) => sum + (topic.totalStudyTime ~/ 60),
);
```

### 4. Theme Switching

**Implementation**:
```dart
// In main.dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: appState.themeMode,  // Dynamic
)

// Toggle in settings
appState.setThemeMode(ThemeMode.dark);
```

---

## 💾 Data Persistence

### SharedPreferences
**Used for**:
- First launch flag
- User name
- Theme preference
- Topics list
- Flashcards per topic

**Implementation**:
```dart
// Save
final prefs = await SharedPreferences.getInstance();
await prefs.setString('topics', json.encode(topicsList));

// Load
final topicsJson = prefs.getString('topics');
if (topicsJson != null) {
  final decoded = json.decode(topicsJson);
  topics = decoded.map((json) => Topic.fromJson(json)).toList();
}
```

### Future: Hive
**Planned for**:
- Faster performance
- Type-safe storage
- Encryption support

---

## 🎨 UI Components

### Reusable Widgets

#### Glass Panel Effect
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.black.withOpacity(0.3),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: Colors.white.withOpacity(0.1),
    ),
  ),
  // Backdrop filter for blur
)
```

#### Progress Circle
```dart
CircularProgressIndicator(
  value: percentage / 100,
  strokeWidth: 6,
  backgroundColor: Colors.grey[300],
  valueColor: AlwaysStoppedAnimation<Color>(primary),
)
```

#### Animated Text Entry
```dart
FadeTransition(
  opacity: animation,
  child: SlideTransition(
    position: Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(animation),
    child: Text(...),
  ),
)
```

---

## 🧪 Testing

### Unit Tests
```dart
// test/models/topic_test.dart
test('Topic completion percentage calculates correctly', () {
  final topic = Topic(
    totalCards: 10,
    completedCards: 5,
  );
  expect(topic.completionPercentage, 50.0);
});
```

### Widget Tests
```dart
// test/screens/dashboard_test.dart
testWidgets('Dashboard shows greeting', (tester) async {
  await tester.pumpWidget(MyApp());
  expect(find.textContaining('Good'), findsOneWidget);
});
```

### Integration Tests
```dart
// integration_test/app_test.dart
testWidgets('Complete user flow', (tester) async {
  // Splash -> Hook -> Auth -> Dashboard
  await tester.pumpAndSettle();
  // ... navigate and verify
});
```

---

## 🚀 Build & Release

### Debug Build
```bash
flutter build apk --debug
# Output: build/app/outputs/flutter-apk/app-debug.apk
```

### Release Build
```bash
# Generate signing key
keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias skrits

# Update android/app/build.gradle with signing config

# Build
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### App Bundle (for Play Store)
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

---

## 🐛 Debugging

### Common Issues

#### 1. Build Failures
```bash
# Clear build cache
flutter clean
flutter pub get
flutter build apk
```

#### 2. Hot Reload Not Working
- Check for syntax errors
- Restart app: Press 'R' in terminal
- Full restart: Press 'Shift+R'

#### 3. State Not Updating
```dart
// Ensure using notifyListeners()
class MyProvider extends ChangeNotifier {
  void updateData() {
    _data = newData;
    notifyListeners();  // Important!
  }
}
```

### Debug Tools
```bash
# Flutter DevTools
flutter pub global activate devtools
flutter pub global run devtools

# Analyze code
flutter analyze

# Format code
flutter format lib/
```

---

## 📈 Performance Optimization

### Best Practices
1. **Use const constructors** where possible
2. **Avoid rebuilds**: Use `Consumer` or `Selector` from Provider
3. **Lazy loading**: Load data as needed
4. **Image optimization**: Compress images
5. **List performance**: Use `ListView.builder` for long lists

### Code Examples
```dart
// Bad: Rebuilds entire tree
Widget build(BuildContext context) {
  final provider = context.watch<MyProvider>();
  return ExpensiveWidget(data: provider.data);
}

// Good: Rebuilds only when needed
Widget build(BuildContext context) {
  return Consumer<MyProvider>(
    builder: (context, provider, child) {
      return ExpensiveWidget(data: provider.data);
    },
  );
}
```

---

## 🔒 Security Considerations

### Current Implementation
- No hardcoded secrets
- Local data only (SharedPreferences)
- No external API calls (yet)

### Future Enhancements
- Use Hive encryption for sensitive data
- Implement proper authentication with JWT
- Secure API communication with HTTPS
- Add certificate pinning
- Implement biometric authentication

---

## 🔮 Roadmap

### Phase 1: MVP ✅
- Core screens
- Basic functionality
- Local storage
- Theme support

### Phase 2: AI Integration
- Real AI flashcard generation
- NLP for content extraction
- Custom AI models

### Phase 3: Advanced Features
- TTS narration
- File upload
- Learning modes
- Advanced analytics

### Phase 4: Social & Gamification
- User profiles
- Community topics
- Leaderboards
- Achievements

---

## 📝 Code Style Guide

### Naming Conventions
```dart
// Classes: PascalCase
class MyAwesomeClass {}

// Variables: camelCase
final myVariable = 'value';

// Private: prefix with _
class _PrivateWidget extends StatelessWidget {}

// Constants: SCREAMING_SNAKE_CASE
const MAX_CARDS = 50;
```

### File Organization
```dart
// 1. Imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 2. Public classes
class MyWidget extends StatelessWidget {}

// 3. Private classes
class _PrivateHelper {}
```

### Comments
```dart
/// Documentation comment for public APIs
/// 
/// Describes what the class/method does
class MyClass {
  // Implementation comment
  // Explains how something works
  void myMethod() {
    // TODO: Future enhancement
  }
}
```

---

## 🤝 Contributing

### Workflow
1. Fork the repository
2. Create feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open Pull Request

### Code Review Checklist
- [ ] Code follows style guide
- [ ] Tests pass
- [ ] No new warnings
- [ ] Documentation updated
- [ ] Commits are meaningful

---

## 📞 Support

### For Developers
- **GitHub Issues**: Bug reports and feature requests
- **Discussions**: Architecture and design decisions
- **Wiki**: Additional documentation (future)

### Resources
- [Flutter Docs](https://docs.flutter.dev/)
- [Provider Package](https://pub.dev/packages/provider)
- [Material Design 3](https://m3.material.io/)

---

**Happy Coding! 🚀**
