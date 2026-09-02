import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/models/harathi.dart';

class OfflineCacheService {
  static final OfflineCacheService _instance = OfflineCacheService._internal();
  factory OfflineCacheService() => _instance;
  OfflineCacheService._internal();

  static const String _harathiBox = 'harathis_box';
  static const String _favoritesBox = 'favorites_box';
  static const String _bookmarksBox = 'bookmarks_box';
  static const String _poojaChecklistBox = 'pooja_checklist_box';

  Future<void> init() async {
    try {
      await Hive.initFlutter();
      if (!Hive.isBoxOpen(_harathiBox)) await Hive.openBox(_harathiBox);
      if (!Hive.isBoxOpen(_favoritesBox)) await Hive.openBox(_favoritesBox);
      if (!Hive.isBoxOpen(_bookmarksBox)) await Hive.openBox(_bookmarksBox);
      if (!Hive.isBoxOpen(_poojaChecklistBox)) await Hive.openBox(_poojaChecklistBox);
    } catch (e) {
      debugPrint('Hive initialization handled gracefully: $e');
    }
  }

  // --- Harathi Caching ---
  Future<void> cacheHarathis(List<Harathi> list) async {
    try {
      if (!Hive.isBoxOpen(_harathiBox)) await Hive.openBox(_harathiBox);
      final box = Hive.box(_harathiBox);
      for (final h in list) {
        await box.put(h.id, h.toMap());
      }
    } catch (_) {}
  }

  List<Harathi> getCachedHarathis() {
    try {
      if (!Hive.isBoxOpen(_harathiBox)) return [];
      final box = Hive.box(_harathiBox);
      final list = <Harathi>[];
      for (final value in box.values) {
        try {
          final map = Map<String, dynamic>.from(value as Map);
          list.add(Harathi.fromMap(map));
        } catch (_) {}
      }
      return list;
    } catch (_) {
      return [];
    }
  }

  // --- Favorites ---
  Future<void> toggleFavorite(String id) async {
    try {
      if (!Hive.isBoxOpen(_favoritesBox)) await Hive.openBox(_favoritesBox);
      final box = Hive.box(_favoritesBox);
      final current = box.get(id, defaultValue: false) as bool;
      await box.put(id, !current);
    } catch (_) {}
  }

  bool isFavorite(String id) {
    try {
      if (!Hive.isBoxOpen(_favoritesBox)) return false;
      final box = Hive.box(_favoritesBox);
      return (box.get(id, defaultValue: false) as bool?) ?? false;
    } catch (_) {
      return false;
    }
  }

  List<String> getAllFavorites() {
    try {
      if (!Hive.isBoxOpen(_favoritesBox)) return [];
      final box = Hive.box(_favoritesBox);
      return box.keys
          .where((k) => box.get(k, defaultValue: false) == true)
          .map((k) => k.toString())
          .toList();
    } catch (_) {
      return [];
    }
  }

  // --- Bookmarks ---
  Future<void> toggleBookmark(String id) async {
    try {
      if (!Hive.isBoxOpen(_bookmarksBox)) await Hive.openBox(_bookmarksBox);
      final box = Hive.box(_bookmarksBox);
      final current = box.get(id, defaultValue: false) as bool;
      await box.put(id, !current);
    } catch (_) {}
  }

  bool isBookmarked(String id) {
    try {
      if (!Hive.isBoxOpen(_bookmarksBox)) return false;
      final box = Hive.box(_bookmarksBox);
      return (box.get(id, defaultValue: false) as bool?) ?? false;
    } catch (_) {
      return false;
    }
  }

  // --- Pooja Step Checklist ---
  Future<void> setPoojaStepCompleted(int stepNumber, bool completed) async {
    try {
      if (!Hive.isBoxOpen(_poojaChecklistBox)) await Hive.openBox(_poojaChecklistBox);
      final box = Hive.box(_poojaChecklistBox);
      await box.put(stepNumber.toString(), completed);
    } catch (_) {}
  }

  bool isPoojaStepCompleted(int stepNumber) {
    try {
      if (!Hive.isBoxOpen(_poojaChecklistBox)) return false;
      final box = Hive.box(_poojaChecklistBox);
      return (box.get(stepNumber.toString(), defaultValue: false) as bool?) ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> resetPoojaChecklist() async {
    try {
      if (!Hive.isBoxOpen(_poojaChecklistBox)) await Hive.openBox(_poojaChecklistBox);
      final box = Hive.box(_poojaChecklistBox);
      await box.clear();
    } catch (_) {}
  }

  int getCompletedPoojaStepsCount(int totalSteps) {
    var count = 0;
    for (int i = 1; i <= totalSteps; i++) {
      if (isPoojaStepCompleted(i)) count++;
    }
    return count;
  }
}
