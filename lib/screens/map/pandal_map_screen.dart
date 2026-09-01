import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/pandal.dart';
import '../../services/firebase_service.dart';

class PandalMapScreen extends StatefulWidget {
  const PandalMapScreen({super.key});

  @override
  State<PandalMapScreen> createState() => _PandalMapScreenState();
}

class _PandalMapScreenState extends State<PandalMapScreen> {
  final FirebaseService _service = FirebaseService();
  List<Pandal> _allPandals = [];
  List<Pandal> _filteredPandals = [];
  String _selectedFilter = 'all'; // 'all', 'pandal', 'immersion'
  String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final list = await _service.getPandals();
    setState(() {
      _allPandals = list;
      _applyFilter();
      _isLoading = false;
    });
  }

  void _applyFilter() {
    _filteredPandals = _allPandals.where((p) {
      final matchesType = _selectedFilter == 'all' || p.type == _selectedFilter;
      final matchesSearch = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.address.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.specialAttraction.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesType && matchesSearch;
    }).toList();
  }

  Future<void> _openGoogleMaps(double lat, double lng, String name) async {
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('మ్యాప్స్ ఓపెన్ చేయడం వీలుపడలేదు.')),
        );
      }
    }
  }

  Future<void> _callContact(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _sharePandal(Pandal p) {
    Share.share(
      '🪔 ${p.name}\n📍 చిరునామా: ${p.address}\n🌟 విశిష్టత: ${p.specialAttraction}\n📏 విగ్రహం ఎత్తు: ${p.idolHeight}\n\n🗺️ గూగుల్ మ్యాప్స్ లొకేషన్:\nhttps://www.google.com/maps/search/?api=1&query=${p.lat},${p.lng}\n\nవినాయక మిత్ర యాప్ ద్వారా పంపబడింది 🕉️',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('పందల్ & నిమజ్జన ఘాట్‌లు'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.saffron))
          : Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'పందల్ పేరు లేదా ఏరియా శోధించండి...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.saffron),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 20),
                              onPressed: () {
                                setState(() {
                                  _searchQuery = '';
                                  _applyFilter();
                                });
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: isDark ? AppColors.darkSurface : Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                        _applyFilter();
                      });
                    },
                  ),
                ),

                // Category Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Row(
                    children: [
                      _buildFilterChip('అన్నీ (${_allPandals.length})', 'all'),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        '🪔 పందల్స్ (${_allPandals.where((p) => p.type != 'immersion').length})',
                        'pandal',
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        '🌊 నిమజ్జన ఘాట్‌లు (${_allPandals.where((p) => p.type == 'immersion').length})',
                        'immersion',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),

                // List
                Expanded(
                  child: _filteredPandals.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainTestThemeCenter(),
                            children: [
                              Icon(Icons.location_off_outlined, size: 64, color: Colors.grey.shade400),
                              const SizedBox(height: 12),
                              Text(
                                'వివరాలు ఏవీ లభించలేదు',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredPandals.length,
                          itemBuilder: (context, index) {
                            final p = _filteredPandals[index];
                            return _buildPandalCard(p, isDark);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  MainAxisAlignment MainTestThemeCenter() => MainAxisAlignment.center;

  Widget _buildFilterChip(String label, String type) {
    final isSelected = _selectedFilter == type;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected ? Colors.white : null,
          fontSize: 13,
        ),
      ),
      selected: isSelected,
      selectedColor: AppColors.saffron,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppColors.saffron : Colors.grey.shade400,
        ),
      ),
      onSelected: (_) {
        setState(() {
          _selectedFilter = type;
          _applyFilter();
        });
      },
    );
  }

  Widget _buildPandalCard(Pandal p, bool isDark) {
    final isImmersion = p.type == 'immersion';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isImmersion
                        ? Colors.blue.withOpacity(0.15)
                        : AppColors.saffron.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isImmersion ? '🌊 నిమజ్జన ఘాట్' : '🪔 వినాయక పందల్',
                    style: TextStyle(
                      color: isImmersion ? Colors.blue.shade800 : AppColors.deepGold,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '📏 ${p.idolHeight}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Title
            Text(
              p.name,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
            ),
            const SizedBox(height: 4),

            // Address
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.place_outlined, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    p.address,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Special attraction
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.saffron.withOpacity(0.08)
                    : AppColors.softGold.withOpacity(0.35),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.stars_rounded, size: 18, color: AppColors.saffron),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      p.specialAttraction,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.saffron,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.directions, size: 18),
                    label: const Text(
                      'రూట్ మ్యాప్ (Directions)',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                    onPressed: () => _openGoogleMaps(p.lat, p.lng, p.name),
                  ),
                ),
                const SizedBox(width: 8),
                if (p.contact != null && p.contact!.isNotEmpty) ...[
                  IconButton.filledTonal(
                    tooltip: 'కాల్ చేయండి',
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.greenAuspicious.withOpacity(0.15),
                      foregroundColor: AppColors.greenAuspicious,
                    ),
                    icon: const Icon(Icons.phone, size: 20),
                    onPressed: () => _callContact(p.contact!),
                  ),
                  const SizedBox(width: 6),
                ],
                IconButton.filledTonal(
                  tooltip: 'షేర్ చేయండి',
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey.withOpacity(0.15),
                  ),
                  icon: const Icon(Icons.share, size: 20),
                  onPressed: () => _sharePandal(p),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
