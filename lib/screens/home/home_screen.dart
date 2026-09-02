import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_utils.dart';
import '../../providers/harathi_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/quick_button.dart';
import '../../widgets/section_header.dart';
import '../admin/admin_panel.dart';
import '../favorites/favorites_screen.dart';
import '../harathulu/library_screen.dart';
import '../harathulu/reader_screen.dart';
import '../mandali/mandali_hub_screen.dart';
import '../onboarding/language_selection_screen.dart';
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
    final lang = context.watch<LanguageProvider>();
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
                    lang.t('appName'),
                    style: TextStyle(
                      fontFamily: 'NotoSansTelugu',
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.royalGold : AppColors.deepGold,
                    ),
                  ),
                ],
              ),
              actions: [
                // Language Switcher Button
                TextButton.icon(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    backgroundColor: isDark ? AppColors.darkSurfaceElevated : AppColors.goldSoft,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.language, size: 16, color: AppColors.saffron),
                  label: Text(
                    lang.currentLanguage == 'te'
                        ? 'తెలుగు'
                        : lang.currentLanguage == 'hi'
                            ? 'हिन्दी'
                            : 'EN',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.royalGold : AppColors.deepGold,
                    ),
                  ),
                  onPressed: () => _push(context, const LanguageSelectionScreen(isFromSettings: true)),
                ),
                const SizedBox(width: 6),
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
                const SizedBox(width: 8),
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
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    lang.currentLanguage == 'hi'
                                        ? '🌺 श्री गणेश चतुर्थी महोत्सव 🌺'
                                        : lang.currentLanguage == 'en'
                                            ? '🌺 Sri Ganesh Chaturthi Festival 🌺'
                                            : '🌺 శ్రీ వినాయక చవితి మహోత్సవం 🌺',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              daysLeft == 0
                                  ? (lang.currentLanguage == 'hi'
                                      ? '🎉 आज श्री विनायक चतुर्थी है!'
                                      : lang.currentLanguage == 'en'
                                          ? '🎉 Today is Vinayaka Chavithi!'
                                          : '🎉 నేడే శ్రీ వినాయక చవితి!')
                                  : (lang.currentLanguage == 'hi'
                                      ? 'उत्सव प्रारंभ में केवल $daysLeft दिन शेष'
                                      : lang.currentLanguage == 'en'
                                          ? 'Only $daysLeft Days left for Festival'
                                          : 'మహోత్సవానికి ఇంకా $daysLeft రోజులు మాత్రమే'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              lang.t('appTagline'),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
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

            // Panchangam Widget
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.wb_sunny_outlined, size: 18, color: AppColors.saffron),
                            const SizedBox(width: 8),
                            Text(
                              lang.currentLanguage == 'hi'
                                  ? 'दैनिक पंचांग (${panchangam.dateFormatted})'
                                  : lang.currentLanguage == 'en'
                                      ? 'Daily Panchangam (${panchangam.dateFormatted})'
                                      : 'నేటి పంచాంగం (${panchangam.dateFormatted})',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: isDark ? AppColors.royalGold : AppColors.deepGold,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _PanchangamItem(
                              title: lang.currentLanguage == 'hi' ? 'तिथि' : lang.currentLanguage == 'en' ? 'Tithi' : 'తిథి',
                              value: panchangam.tithi,
                            ),
                            _PanchangamItem(
                              title: lang.currentLanguage == 'hi' ? 'नक्षत्र' : lang.currentLanguage == 'en' ? 'Nakshatra' : 'నక్షత్రం',
                              value: panchangam.nakshatram,
                            ),
                            _PanchangamItem(
                              title: lang.currentLanguage == 'hi' ? 'अभिजीत मुहूर्त' : lang.currentLanguage == 'en' ? 'Muhurtham' : 'ముహూర్తం',
                              value: panchangam.abhijitMuhurtham,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Mitra Mandali & Association Banner Entry
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                child: InkWell(
                  onTap: () => _push(context, const MandaliHubScreen()),
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFB71C1C), Color(0xFFE65100)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE65100).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text('🚩', style: TextStyle(fontSize: 26)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lang.t('mandaliTitle'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                lang.t('mandaliSubtitle'),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Quick Actions Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    label: lang.t('poojaVidhanam'),
                    iconColor: AppColors.deepGold,
                    onTap: () => _push(context, const PoojaVidhanamScreen()),
                  ),
                  QuickButton(
                    icon: Icons.local_fire_department,
                    label: lang.t('harathulu'),
                    iconColor: AppColors.saffron,
                    onTap: () => _push(context, const LibraryScreen()),
                  ),
                  QuickButton(
                    icon: Icons.auto_stories,
                    label: lang.t('vrathaKatha'),
                    iconColor: AppColors.maroon,
                    onTap: () => _push(context, const VrathaKathaScreen()),
                  ),
                  QuickButton(
                    icon: Icons.eco,
                    label: lang.t('pathriPooja'),
                    iconColor: AppColors.greenAuspicious,
                    onTap: () => _push(context, const PathriScreen()),
                  ),
                  QuickButton(
                    icon: Icons.restaurant,
                    label: lang.t('prasadam'),
                    iconColor: const Color(0xFFE65100),
                    onTap: () => _push(context, const PrasadamScreen()),
                  ),
                  QuickButton(
                    icon: Icons.favorite,
                    label: lang.t('favorites'),
                    iconColor: AppColors.maroon,
                    onTap: () => _push(context, const FavoritesScreen()),
                  ),
                ]),
              ),
            ),

            // Section: Featured Harathi
            SliverToBoxAdapter(
              child: SectionHeader(
                title: lang.currentLanguage == 'hi'
                    ? 'नित्य मंगल आरती'
                    : lang.currentLanguage == 'en'
                        ? 'Featured Harathi'
                        : 'నిత్య మంగళ హారతి',
                subtitle: lang.currentLanguage == 'hi'
                    ? 'भक्ति भाव से पाठ करें'
                    : lang.currentLanguage == 'en'
                        ? 'Read with devotion'
                        : 'భక్తితో పఠించండి',
              ),
            ),

            // Featured Harathi Card
            SliverToBoxAdapter(
              child: Consumer<HarathiProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator(color: AppColors.saffron)),
                    );
                  }

                  if (provider.allHarathis.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  final featured = provider.allHarathis.first;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      child: InkWell(
                        onTap: () => _push(context, ReaderScreen(harathi: featured)),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.local_fire_department, color: AppColors.saffron, size: 22),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      featured.titleTe,
                                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (featured.pdfPath != null)
                                    const Icon(Icons.picture_as_pdf, color: AppColors.saffron, size: 20),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                featured.lyricsTelugu.split('\n').take(3).join('\n'),
                                style: TextStyle(
                                  fontFamily: 'NotoSansTelugu',
                                  fontSize: 13,
                                  height: 1.6,
                                  color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade700,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${lang.t('viewAll')} ➔',
                                    style: const TextStyle(
                                      color: AppColors.saffron,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

class _PanchangamItem extends StatelessWidget {
  final String title;
  final String value;

  const _PanchangamItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
      ],
    );
  }
}
