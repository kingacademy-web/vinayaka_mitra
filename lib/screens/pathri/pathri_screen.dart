import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/pathri.dart';
import '../../services/firebase_service.dart';

class PathriScreen extends StatefulWidget {
  const PathriScreen({super.key});

  @override
  State<PathriScreen> createState() => _PathriScreenState();
}

class _PathriScreenState extends State<PathriScreen> {
  final FirebaseService _service = FirebaseService();
  List<Pathri> _pathriList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPathri();
  }

  Future<void> _loadPathri() async {
    final list = await _service.getPathriList();
    setState(() {
      _pathriList = list;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ఏకవింశతి పత్రి పూజ (21 పత్రులు)'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.saffron))
          : _pathriList.isEmpty
              ? const Center(child: Text('పత్రి వివరాలు అందుబాటులో లేవు'))
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: _pathriList.length,
                  itemBuilder: (context, index) {
                    final p = _pathriList[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header: Number + Name + Botanical Name
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: AppColors.greenAuspicious.withOpacity(0.15),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.greenAuspicious.withOpacity(0.4),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${p.number}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.greenAuspicious,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.nameTe,
                                        style: TextStyle(
                                          fontFamily: 'NotoSansTelugu',
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800,
                                          color: isDark ? AppColors.royalGold : AppColors.deepGold,
                                        ),
                                      ),
                                      Text(
                                        p.nameEn,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        'వృక్షశాస్త్ర నామం: ${p.botanicalName}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic,
                                          color: isDark
                                              ? AppColors.darkTextSecondary
                                              : Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const Divider(height: 20),

                            // Worship Mantra
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkChip : AppColors.goldSoft,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                p.mantra,
                                style: TextStyle(
                                  fontFamily: 'NotoSansTelugu',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.royalGold : AppColors.deepMaroon,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Spiritual Significance
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.star_outline, size: 16, color: AppColors.saffron),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    p.importance,
                                    style: TextStyle(
                                      fontSize: 13,
                                      height: 1.4,
                                      color: isDark ? AppColors.darkTextPrimary : Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 6),

                            // Medicinal Benefits
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.healing_outlined,
                                    size: 16, color: AppColors.greenAuspicious),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'ఔషధ గుణాలు: ${p.medicinalBenefits}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      height: 1.4,
                                      color: isDark
                                          ? AppColors.darkTextSecondary
                                          : Colors.grey.shade800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
