import '../data/models/harathi.dart';
import '../data/models/pathri.dart';
import '../data/models/pooja_step.dart';
import '../data/models/recipe.dart';
import '../data/models/vratha_katha.dart';
import 'offline_cache_service.dart';
import 'seed_data_service.dart';

class FirebaseService {
  final OfflineCacheService _cache = OfflineCacheService();
  final SeedDataService _seed = SeedDataService();

  /// Standalone mode guest initialization
  Future<void> signInAnonymously() async {}

  /// Check admin permission for admin panel
  Future<bool> checkIsAdmin() async => true;

  /// Get Harathulu with local cache and bundled seed data
  Future<List<Harathi>> getHarathis({String? category}) async {
    final cached = _cache.getCachedHarathis();
    if (cached.isNotEmpty) {
      return (category == null || category.isEmpty)
          ? cached
          : cached.where((h) => h.category == category).toList();
    }

    final seedList = await _seed.loadHarathis();
    if (seedList.isNotEmpty) {
      await _cache.cacheHarathis(seedList);
      return (category == null || category.isEmpty)
          ? seedList
          : seedList.where((h) => h.category == category).toList();
    }

    return [];
  }

  /// Fetch 21 Pathri list
  Future<List<Pathri>> getPathriList() async => _seed.loadPathriList();

  /// Fetch 16 Pooja steps
  Future<List<PoojaStep>> getPoojaSteps() async => _seed.loadPoojaSteps();

  /// Fetch Prasadam recipes
  Future<List<Recipe>> getRecipes() async => _seed.loadRecipes();

  /// Fetch Vratha Katha
  Future<List<KathaChapter>> getVrathaKatha() async => _seed.loadVrathaKatha();

  /// Save or Update a Harathi
  Future<void> saveHarathi(Harathi h) async {
    final list = _cache.getCachedHarathis();
    final index = list.indexWhere((item) => item.id == h.id);
    if (index >= 0) {
      list[index] = h;
    } else {
      list.add(h);
    }
    await _cache.cacheHarathis(list);
  }

  /// Delete a Harathi
  Future<void> deleteHarathi(String id) async {
    final list = _cache.getCachedHarathis();
    list.removeWhere((item) => item.id == id);
    await _cache.cacheHarathis(list);
  }

  /// Broadcast notification placeholder
  Future<void> sendNotification({required String title, required String body}) async {}
}
