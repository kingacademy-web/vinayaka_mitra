import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  /// Attempt anonymous login for seamless guest access
  Future<void> signInAnonymously() async {
    try {
      final auth = FirebaseAuth.instance;
      if (auth.currentUser == null) {
        await auth.signInAnonymously();
      }
    } catch (_) {
      // Offline or Firebase not configured - continue as guest
    }
  }

  /// Check if the currently signed-in user is an admin
  Future<bool> checkIsAdmin() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return false;
      final doc = await FirebaseFirestore.instance
          .collection('admins')
          .doc(uid)
          .get()
          .timeout(const Duration(seconds: 4));
      return doc.exists;
    } catch (_) {
      return false;
    }
  }

  /// Get Harathulu with 3-tier fallback: Firestore -> Hive Box -> Asset Seeds
  Future<List<Harathi>> getHarathis({String? category}) async {
    try {
      final query = FirebaseFirestore.instance.collection('harathis');
      final QuerySnapshot snap = (category != null && category.isNotEmpty)
          ? await query
              .where('category', isEqualTo: category)
              .limit(150)
              .get(const GetOptions(source: Source.serverAndCache))
              .timeout(const Duration(seconds: 5))
          : await query
              .limit(150)
              .get(const GetOptions(source: Source.serverAndCache))
              .timeout(const Duration(seconds: 5));

      if (snap.docs.isNotEmpty) {
        final list = snap.docs.map(Harathi.fromFirestore).toList();
        await _cache.cacheHarathis(list);
        return list;
      }
    } catch (_) {}

    // Fallback 1: Hive Cache
    final cached = _cache.getCachedHarathis();
    if (cached.isNotEmpty) {
      return (category == null || category.isEmpty)
          ? cached
          : cached.where((h) => h.category == category).toList();
    }

    // Fallback 2: Bundled JSON Seed Data
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
  Future<List<Pathri>> getPathriList() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('pathri')
          .orderBy('number')
          .get(const GetOptions(source: Source.serverAndCache))
          .timeout(const Duration(seconds: 4));
      if (snap.docs.isNotEmpty) {
        return snap.docs.map((d) => Pathri.fromMap(d.data())).toList();
      }
    } catch (_) {}
    return _seed.loadPathriList();
  }

  /// Fetch 16 Pooja steps
  Future<List<PoojaStep>> getPoojaSteps() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('pooja_steps')
          .orderBy('stepNumber')
          .get(const GetOptions(source: Source.serverAndCache))
          .timeout(const Duration(seconds: 4));
      if (snap.docs.isNotEmpty) {
        return snap.docs.map((d) => PoojaStep.fromMap(d.data())).toList();
      }
    } catch (_) {}
    return _seed.loadPoojaSteps();
  }

  /// Fetch Prasadam recipes
  Future<List<Recipe>> getRecipes() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('recipes')
          .get(const GetOptions(source: Source.serverAndCache))
          .timeout(const Duration(seconds: 4));
      if (snap.docs.isNotEmpty) {
        return snap.docs.map((d) => Recipe.fromMap(d.data(), d.id)).toList();
      }
    } catch (_) {}
    return _seed.loadRecipes();
  }

  /// Fetch Vratha Katha
  Future<List<KathaChapter>> getVrathaKatha() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('vratha_katha')
          .orderBy('chapterNumber')
          .get(const GetOptions(source: Source.serverAndCache))
          .timeout(const Duration(seconds: 4));
      if (snap.docs.isNotEmpty) {
        return snap.docs.map((d) => KathaChapter.fromMap(d.data())).toList();
      }
    } catch (_) {}
    return _seed.loadVrathaKatha();
  }

  /// Admin write operation: Save or Update a Harathi
  Future<void> saveHarathi(Harathi h) async {
    await FirebaseFirestore.instance
        .collection('harathis')
        .doc(h.id)
        .set(h.toMap(), SetOptions(merge: true));
  }

  /// Admin delete operation
  Future<void> deleteHarathi(String id) async {
    await FirebaseFirestore.instance.collection('harathis').doc(id).delete();
  }

  /// Admin broadcast notification trigger
  Future<void> sendNotification({required String title, required String body}) async {
    await FirebaseFirestore.instance.collection('notifications').add({
      'title': title,
      'body': body,
      'sentAt': FieldValue.serverTimestamp(),
    });
  }
}
