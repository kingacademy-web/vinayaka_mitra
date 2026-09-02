import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/harathi_provider.dart';
import '../harathulu/reader_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favProvider = context.watch<FavoritesProvider>();
    final harathiProvider = context.watch<HarathiProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final favoriteHarathis = harathiProvider.allHarathis
        .where((h) => favProvider.isFavorite(h.id) || favProvider.isBookmarked(h.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ఇష్టమైన హారతులు & బుక్‌మార్క్‌లు'),
      ),
      body: favoriteHarathis.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 64,
                      color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'ఇంకా ఎలాంటి హారతులు ఇష్టమైనవిగా ఎంచుకోలేదు',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'హారతుల విభాగంలో గుండె గుర్తు (❤️) లేదా బుక్‌మార్క్ పై నొక్కి ఇక్కడ సులభంగా యాక్సెస్ చేసుకోండి.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: favoriteHarathis.length,
              itemBuilder: (context, index) {
                final h = favoriteHarathis[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    leading: CircleAvatar(
                      backgroundColor: isDark ? AppColors.darkSurfaceElevated : AppColors.goldSoft,
                      child: const Icon(
                        Icons.local_fire_department,
                        color: AppColors.saffron,
                      ),
                    ),
                    title: Text(
                      h.titleTe,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    subtitle: Text(
                      '${h.category.toUpperCase()} • ${h.titleEn}',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade600,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: AppColors.maroon),
                      onPressed: () => favProvider.toggleFavorite(h.id),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReaderScreen(harathi: h),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
