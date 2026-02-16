import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _isFirstLaunch = true;
  String _userName = 'User';

  ThemeMode get themeMode => _themeMode;
  bool get isFirstLaunch => _isFirstLaunch;
  String get userName => _userName;

  AppStateProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isFirstLaunch = prefs.getBool('firstLaunch') ?? true;
    _userName = prefs.getString('userName') ?? 'User';
    final themeModeIndex = prefs.getInt('themeMode') ?? 0;
    _themeMode = ThemeMode.values[themeModeIndex];
    notifyListeners();
  }

  Future<void> setFirstLaunchComplete() async {
    _isFirstLaunch = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('firstLaunch', false);
    notifyListeners();
  }

  Future<void> setUserName(String name) async {
    _userName = name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
    notifyListeners();
  }
}
