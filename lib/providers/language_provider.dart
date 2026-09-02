import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/localization/app_strings.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _prefLanguageKey = 'selected_app_language';
  static const String _prefHasChosenKey = 'has_chosen_initial_language';

  String _currentLanguage = 'te'; // default Telugu
  bool _hasChosenLanguage = true; // by default true until checked

  String get currentLanguage => _currentLanguage;
  bool get hasChosenLanguage => _hasChosenLanguage;

  LanguageProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString(_prefLanguageKey) ?? 'te';
    _hasChosenLanguage = prefs.getBool(_prefHasChosenKey) ?? false;
    notifyListeners();
  }

  Future<void> setLanguage(String langCode) async {
    _currentLanguage = langCode;
    _hasChosenLanguage = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefLanguageKey, langCode);
    await prefs.setBool(_prefHasChosenKey, true);
  }

  String t(String key) {
    return AppStrings.tr(_currentLanguage, key);
  }
}
