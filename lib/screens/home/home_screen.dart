import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_utils.dart';
import '../../providers/harathi_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/quick_button.dart';
import '../../widgets/section_header.dart';
import '../admin/admin_panel.dart';
import '../harathulu/library_screen.dart';
import '../harathulu/reader_screen.dart';
import '../map/pandal_map_screen.dart';
import '../pathri/pathri_screen.dart';
import '../pooja/pooja_vidhanam_screen.dart';
import '../prasadam/prasadam_screen.dart';
import '../vratha_katha/vratha_katha_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _push(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final panchangam = DevotionalDateUtils.getTodaysPanchangam();
    final daysLeft = DevotionalDateUtils.getDaysUntilGaneshChaturthi();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Top App Bar
            SliverAppBar(
              floating: true,
              pinned: true,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🪔 ', style: TextStyle(fontSize: 22)),
                  Text(
                    'వినాయక మిత్ర',
                    style: TextStyle(
                      fontFamily: 'NotoSansTelugu',
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.royalGold : AppColors.deepGold,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  tooltip: 'Admin Panel',
                  icon: const Icon(Icons.admin_panel_settings_outlined),
                  onPressed: () => _push(context, const AdminPanel()),
                ),
                IconButton(
                  tooltip: isDark ? 'లైట్ మోడ్' : 'డార్క్ మోడ్',
                  icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode_outlined),
                  onPressed: () => context.read<ThemeProvider>().toggle(),
                ),
              ],
            ),

            // Hero Festival Countdown Banner
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [const Color(0xFF5E2B0C), const Color(0xFF2A1505)]
                          : [AppColors.deepGold, AppColors.saffron],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.saffron.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -10,
                        bottom: -10,
                        child: Icon(
                          Icons.self_improvement,
                          size: 140,
                          color: Colors.white.withOpacity(0.12),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'శ్రీ గణేశ చతుర్థి శుభాకాంక్షలు',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'ఓం శ్రీ మహాగణాధిపతయే నమః',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              daysLeft == 0
                                  ? '🎉 నేడే పవిత్ర వినాయక చవితి పండుగ!'
                                  : 'వినాయక చవితికి ఇంకా $daysLeft రోజుల సమయం కలదు',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.95),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Daily Panchangam Summary Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.wb_sunny_outlined, size: 18, color: AppColors.saffron),
                            const SizedBox(width: 8),
                            Text(
                              'నేటి పంచాంగం & ముహూర్తం',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: isDark ? AppColors.royalGold : AppColors.deepGold,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              DevotionalDateUtils.formatTeluguDate(DateTime.now()),
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _PanchangamItem(
                              label: 'తిథి',
                              value: panchangam['tithi']!,
                            ),
                            _PanchangamItem(
                              label: 'నక్షత్రం',
                              value: panchangam['nakshatram']!,
                            ),
                            _PanchangamItem(
                              label: 'అభిజిత్ ముహూర్తం',
                              value: panchangam['muhurtham']!,
                              highlight: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Section: Devotional Features
            const SliverToBoxAdapter(
              child: SectionHeader(
                title: 'పూజా సేవా విభాగాలు',
                subtitle: 'సమగ్ర భక్తి సంకలనం మరియు పూజా సామగ్రి',
              ),
            ),

            // Quick Actions Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                delegate: SliverChildListDelegate([
                  QuickButton(
                    icon: Icons.menu_book,
                    label: 'పూజా విధానం',
                    iconColor: AppColors.deepGold,
                    onTap: () => _push(context, const PoojaVidhanamScreen()),
                  ),
                  QuickButton(
                    icon: Icons.local_fire_department,
                    label: 'హారతులు',
                    iconColor: AppColors.saffron,
                    onTap: () => _push(context, const LibraryScreen()),
                  ),
                  QuickButton(
                    icon: Icons.auto_stories,
                    label: 'వ్రత కథ',
                    iconColor: AppColors.maroon,
                    onTap: () => _push(context, const VrathaKathaScreen()),
                  ),
                  QuickButton(
                    icon: Icons.eco,
                    label: '21 పత్రి పూజ',
                    iconColor: AppColors.greenAuspicious,
                    onTap: () => _push(context, const PathriScreen()),
                  ),
                  QuickButton(
                    icon: Icons.restaurant,
                    label: 'నైవేద్యం/ప్రసాదం',
                    iconColor: const Color(0xFFE65100),
                    onTap: () => _push(context, const PrasadamScreen()),
                  ),
                  QuickButton(
                    icon: Icons.location_on_outlined,
                    label: 'పందల్ & ఘాట్‌లు',
                    iconColor: const Color(0xFF1976D2),
                    onTap: () => _push(context, const PandalMapScreen()),
                  ),
                ]),
              ),
            ),

            // Section: Featured Harathi
            const SliverToBoxAdapter(
              child: SectionHeader(
                title: 'నిత్య మంగళ హారతి',
                subtitle: 'భక్తితో పఠించండి',
              ),
            ),

            // Featured Harathi Card
            SliverToBoxAdapter(
              child: Consumer<HarathiProvider>(
                builder: (context, provider, _) {
                  final list = provider.allHarathis;
                  if (list.isEmpty) return const SizedBox.shrink();
                  final featured = list.first;

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    child: Card(
                      child: InkWell(
                        onTap: () => _push(context, ReaderScreen(harathi: featured)),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: AppColors.goldSoft,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.auto_awesome,
                                  color: AppColors.saffron,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      featured.titleTe,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      featured.titleEn,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: isDark
                                            ? AppColors.darkTextSecondary
                                            : Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.deepGold),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PanchangamItem extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _PanchangamItem({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
            fontSize: 12,
            color: highlight
                ? (isDark ? AppColors.royalGold : AppColors.maroon)
                : (isDark ? AppColors.darkTextPrimary : Colors.black87),
          ),
        ),
      ],
    );
  }
}
