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
    await Hive.initFlutter();
    await Hive.openBox(_harathiBox);
    await Hive.openBox(_favoritesBox);
    await Hive.openBox(_bookmarksBox);
    await Hive.openBox(_poojaChecklistBox);
  }

  // --- Harathi Caching ---
  Future<void> cacheHarathis(List<Harathi> list) async {
    final box = Hive.box(_harathiBox);
    for (final h in list) {
      await box.put(h.id, h.toMap());
    }
  }

  List<Harathi> getCachedHarathis() {
    final box = Hive.box(_harathiBox);
    final list = <Harathi>[];
    for (final value in box.values) {
      try {
        final map = Map<String, dynamic>.from(value as Map);
        list.add(Harathi.fromMap(map));
      } catch (_) {}
    }
    return list;
  }

  // --- Favorites ---
  Future<void> toggleFavorite(String id) async {
    final box = Hive.box(_favoritesBox);
    final current = box.get(id, defaultValue: false) as bool;
    await box.put(id, !current);
  }

  bool isFavorite(String id) {
    if (!Hive.isBoxOpen(_favoritesBox)) return false;
    final box = Hive.box(_favoritesBox);
    return (box.get(id, defaultValue: false) as bool?) ?? false;
  }

  List<String> getAllFavorites() {
    if (!Hive.isBoxOpen(_favoritesBox)) return [];
    final box = Hive.box(_favoritesBox);
    return box.keys
        .where((k) => box.get(k, defaultValue: false) == true)
        .map((k) => k.toString())
        .toList();
  }

  // --- Bookmarks ---
  Future<void> toggleBookmark(String id) async {
    final box = Hive.box(_bookmarksBox);
    final current = box.get(id, defaultValue: false) as bool;
    await box.put(id, !current);
  }

  bool isBookmarked(String id) {
    if (!Hive.isBoxOpen(_bookmarksBox)) return false;
    final box = Hive.box(_bookmarksBox);
    return (box.get(id, defaultValue: false) as bool?) ?? false;
  }

  // --- Pooja Step Checklist ---
  Future<void> setPoojaStepCompleted(int stepNumber, bool completed) async {
    final box = Hive.box(_poojaChecklistBox);
    await box.put(stepNumber.toString(), completed);
  }

  bool isPoojaStepCompleted(int stepNumber) {
    if (!Hive.isBoxOpen(_poojaChecklistBox)) return false;
    final box = Hive.box(_poojaChecklistBox);
    return (box.get(stepNumber.toString(), defaultValue: false) as bool?) ?? false;
  }

  Future<void> resetPoojaChecklist() async {
    final box = Hive.box(_poojaChecklistBox);
    await box.clear();
  }

  int getCompletedPoojaStepsCount(int totalSteps) {
    var count = 0;
    for (int i = 1; i <= totalSteps; i++) {
      if (isPoojaStepCompleted(i)) count++;
    }
    return count;
  }
}
