import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/harathi.dart';
import '../services/firebase_service.dart';

class HarathiProvider extends ChangeNotifier {
  final FirebaseService _service;

  List<Harathi> _allHarathis = [];
  String _query = '';
  String? _selectedCategory; // null = all categories
  double _fontSize = 18.0;
  bool _isLoading = false;
  String? _errorMessage;

  HarathiProvider(this._service) {
    _loadFontSize();
  }

  List<Harathi> get allHarathis => _allHarathis;
  String? get selectedCategory => _selectedCategory;
  String get query => _query;
  double get fontSize => _fontSize;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<Harathi> get harathis {
    return _allHarathis.where((h) {
      final matchesCategory = _selectedCategory == null ||
          _selectedCategory!.isEmpty ||
          h.category.toLowerCase() == _selectedCategory!.toLowerCase();

      final matchesQuery = _query.isEmpty ||
          h.titleTe.toLowerCase().contains(_query.toLowerCase()) ||
          h.titleEn.toLowerCase().contains(_query.toLowerCase()) ||
          h.lyricsTelugu.contains(_query) ||
          h.lyricsEnglish.toLowerCase().contains(_query.toLowerCase());

      return matchesCategory && matchesQuery;
    }).toList();
  }

  Future<void> load({String? category}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allHarathis = await _service.getHarathis(category: category);
    } catch (e) {
      _errorMessage = 'హారతులు లోడ్ చేయడంలో లోపం ఏర్పడింది';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void search(String q) {
    _query = q.trim();
    notifyListeners();
  }

  void setCategory(String? category) {
    if (_selectedCategory == category) {
      _selectedCategory = null; // Toggle off if already selected
    } else {
      _selectedCategory = category;
    }
    notifyListeners();
  }

  // --- Dynamic Font Size Controller ---
  Future<void> increaseFont() => _setFontSize(_fontSize + 2.0);
  Future<void> decreaseFont() => _setFontSize(_fontSize - 2.0);

  Future<void> _setFontSize(double size) async {
    if (size < 14.0 || size > 32.0) return;
    _fontSize = size;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('devotional_font_size', size);
    } catch (_) {}
  }

  Future<void> _loadFontSize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedSize = prefs.getDouble('devotional_font_size');
      if (savedSize != null) {
        _fontSize = savedSize;
        notifyListeners();
      }
    } catch (_) {}
  }
}
