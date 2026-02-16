import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'providers/app_state_provider.dart';
import 'providers/topics_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/hook_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/create_topic_screen.dart';
import 'screens/feed_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set portrait orientation only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
        ChangeNotifierProvider(create: (_) => TopicsProvider()),
      ],
      child: Consumer<AppStateProvider>(
        builder: (context, appState, _) {
          return MaterialApp(
            title: 'Skrits',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: appState.themeMode,
            home: const SplashScreen(),
            routes: {
              '/splash': (context) => const SplashScreen(),
              '/hook': (context) => const HookScreen(),
              '/auth': (context) => const AuthScreen(),
              '/dashboard': (context) => const DashboardScreen(),
              '/create-topic': (context) => const CreateTopicScreen(),
              '/progress': (context) => const ProgressScreen(),
              '/settings': (context) => const SettingsScreen(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == '/feed') {
                final topicId = settings.arguments as String;
                return MaterialPageRoute(
                  builder: (context) => FeedScreen(topicId: topicId),
                );
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
