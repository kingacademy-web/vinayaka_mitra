import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/harathi_provider.dart';
import 'reader_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<(String, String, IconData)> _categories = const [
    ('ganesh', 'గణేశుడు', Icons.filter_vintage),
    ('shiva', 'శివుడు', Icons.temple_hindu),
    ('venkateswara', 'వేంకటేశ్వరుడు', Icons.self_improvement),
    ('lakshmi', 'లక్ష్మీ దేవి', Icons.spa),
    ('durga', 'దుర్గా దేవి', Icons.local_fire_department),
    ('hanuman', 'హనుమంతుడు', Icons.bolt),
    ('saibaba', 'సాయి బాబా', Icons.volunteer_activism),
    ('ayyappa', 'అయ్యప్ప స్వామి', Icons.landscape),
    ('saraswati', 'సరస్వతీ దేవి', Icons.school),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HarathiProvider>();
    final favProvider = context.watch<FavoritesProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('హారతుల సంగ్రహం'),
      ),
      body: Column(
        children: [
          // Search Input Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: provider.search,
              decoration: InputDecoration(
                hintText: 'హారతి లేదా దేవుని పేరు వెతకండి…',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          provider.search('');
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Categories Horizontal Filter
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                if (index == 0) {
                  final isSelected = provider.selectedCategory == null;
                  return ChoiceChip(
                    label: const Text('అన్నీ (All)'),
                    selected: isSelected,
                    onSelected: (_) => provider.setCategory(null),
                  );
                }
                final (id, name, _) = _categories[index - 1];
                final isSelected = provider.selectedCategory == id;
                return ChoiceChip(
                  label: Text(name),
                  selected: isSelected,
                  onSelected: (_) => provider.setCategory(id),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Harathi List Content
          Expanded(
            child: provider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.saffron),
                  )
                : provider.harathis.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 56,
                              color: isDark ? AppColors.darkTextSecondary : Colors.grey,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'ఎలాంటి హారతులు లభించలేదు',
                              style: TextStyle(
                                fontSize: 16,
                                color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: provider.harathis.length,
                        itemBuilder: (context, index) {
                          final h = provider.harathis[index];
                          final isFav = favProvider.isFavorite(h.id);

                          return Card(
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: isDark
                                    ? AppColors.darkSurfaceElevated
                                    : AppColors.goldSoft,
                                child: Icon(
                                  Icons.local_fire_department,
                                  color: isDark ? AppColors.royalGold : AppColors.deepGold,
                                ),
                              ),
                              title: Text(
                                h.titleTe,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  h.titleEn,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : Colors.grey.shade700,
                                  ),
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  isFav ? Icons.favorite : Icons.favorite_border,
                                  color: isFav ? AppColors.maroon : Colors.grey,
                                ),
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
          ),
        ],
      ),
    );
  }
}
