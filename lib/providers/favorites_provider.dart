import 'package:flutter/material.dart';
import '../services/offline_cache_service.dart';

class FavoritesProvider extends ChangeNotifier {
  final OfflineCacheService _cache = OfflineCacheService();

  bool isFavorite(String id) => _cache.isFavorite(id);
  bool isBookmarked(String id) => _cache.isBookmarked(id);

  Future<void> toggleFavorite(String id) async {
    await _cache.toggleFavorite(id);
    notifyListeners();
  }

  Future<void> toggleBookmark(String id) async {
    await _cache.toggleBookmark(id);
    notifyListeners();
  }
}
