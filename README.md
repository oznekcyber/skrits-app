# Skrits App

**Scroll. Learn. Repeat.**

A Flutter Android app that transforms doom scrolling into productive learning through AI-generated flashcards in a vertical, social media-style feed.

## 🎯 Features

- **Vertical Scrolling Feed**: TikTok-style learning experience with smooth vertical scrolling
- **AI-Generated Flashcards**: Create study topics and get instant flashcards
- **Multiple Card Types**: Concept cards, question cards, and diagram cards
- **Progress Tracking**: Monitor your learning journey with detailed statistics
- **Theme Support**: Beautiful dark and light themes with orange accent
- **Smooth Animations**: Polished UI with engaging animations throughout

## 📱 Screens

1. **Splash Screen** - Animated entry with brand logo
2. **Hook Screen** - First-time user onboarding
3. **Authentication** - Sign in/Sign up flow
4. **Dashboard** - Home hub with topics and continue learning
5. **Create Topic** - Generate AI flashcards from topics
6. **Learning Feed** - Vertical scrolling flashcard experience
7. **Progress** - Study statistics and insights
8. **Settings** - Theme, preferences, and account management

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Android Studio with Flutter plugin
- Pixel 9a Virtual Device (or any Android device/emulator)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/oznekcyber/skrits-app.git
cd skrits-app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 🎨 Design

The app uses a design system inspired by the Stitch UI exports with:
- Primary color: Orange (#FF6A00)
- Dark background: Matte black (#0A0A0A)
- Light background: Off-white (#F8F7F5)
- Font: Spline Sans (via Google Fonts)
- Glass-morphism effects and smooth animations

## 📦 Dependencies

- **provider**: State management
- **google_fonts**: Spline Sans typography
- **shared_preferences**: Local data persistence
- **hive**: Advanced local storage
- **flutter_tts**: Text-to-speech (planned)
- **intl**: Date formatting
- **uuid**: Unique ID generation

## 🏗️ Architecture

```
lib/
├── main.dart
├── theme.dart
├── models/
│   ├── topic.dart
│   ├── flashcard.dart
│   └── study_session.dart
├── providers/
│   ├── app_state_provider.dart
│   └── topics_provider.dart
└── screens/
    ├── splash_screen.dart
    ├── hook_screen.dart
    ├── auth_screen.dart
    ├── dashboard_screen.dart
    ├── create_topic_screen.dart
    ├── feed_screen.dart
    ├── progress_screen.dart
    └── settings_screen.dart
```

## 🎯 MVP Features

✅ Vertical scrolling learning feed
✅ Topic creation with AI-simulated generation
✅ Progress tracking
✅ Dark/Light theme support
✅ Multiple flashcard types
✅ Study statistics
✅ Local data persistence

## 🔮 Future Features

- Real AI integration for flashcard generation
- Text-to-speech (TTS) narration
- File upload for lecture materials
- Learning modes (Silent, Auto Voice, Focus)
- Gamification elements
- Social features
- Study reminders
- Community topics

## 📄 License

This project is part of a portfolio/learning exercise.

## 👤 Author

oznekcyber

---

**Stop doomscrolling. Start brainscrolling.** 🧠