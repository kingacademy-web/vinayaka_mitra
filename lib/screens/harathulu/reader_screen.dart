import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/harathi.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/harathi_provider.dart';

class ReaderScreen extends StatefulWidget {
  final Harathi harathi;

  const ReaderScreen({super.key, required this.harathi});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _isFullscreen = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _shareContent() {
    final h = widget.harathi;
    final shareText = '''
🪔 ${h.titleTe} (${h.titleEn}) 🪔

${h.lyricsTelugu}

భావం:
${h.meaning}

— వినాయక మిత్ర (Vinayaka Mitra Devotional App)
''';
    Share.share(shareText);
  }

  @override
  Widget build(BuildContext context) {
    final h = widget.harathi;
    final provider = context.watch<HarathiProvider>();
    final favProvider = context.watch<FavoritesProvider>();
    final isBookmarked = favProvider.isBookmarked(h.id);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: _isFullscreen
          ? null
          : AppBar(
              title: Text(
                h.titleTe,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              actions: [
                // Decrease Font (A-)
                IconButton(
                  tooltip: 'అక్షరాల పరిమాణం తగ్గించు',
                  icon: const Icon(Icons.text_decrease),
                  onPressed: provider.decreaseFont,
                ),
                // Increase Font (A+)
                IconButton(
                  tooltip: 'అక్షరాల పరిమాణం పెంచు',
                  icon: const Icon(Icons.text_increase),
                  onPressed: provider.increaseFont,
                ),
                // Bookmark Toggle
                IconButton(
                  tooltip: 'బుక్‌మార్క్',
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: isBookmarked ? AppColors.saffron : null,
                  ),
                  onPressed: () => favProvider.toggleBookmark(h.id),
                ),
                // Share Lyrics
                IconButton(
                  tooltip: 'షేర్ చేయండి',
                  icon: const Icon(Icons.share_outlined),
                  onPressed: _shareContent,
                ),
                // Fullscreen Mode
                IconButton(
                  tooltip: 'పూర్తి స్క్రీన్',
                  icon: const Icon(Icons.fullscreen),
                  onPressed: () => setState(() => _isFullscreen = true),
                ),
              ],
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'తెలుగు'),
                  Tab(text: 'English'),
                  Tab(text: 'భావం / Meaning'),
                ],
              ),
            ),
      body: GestureDetector(
        onTap: _isFullscreen ? () => setState(() => _isFullscreen = false) : null,
        child: Column(
          children: [
            // PDF Banner if attached
            if (h.pdfPath != null && h.pdfPath!.isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.saffron,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                  label: const Text(
                    '📄 పూర్తి PDF తెరవండి (Open PDF Document)',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                  ),
                  onPressed: () async {
                    try {
                      await OpenFilex.open(h.pdfPath!);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('PDF తెరవడం వీలుపడలేదు: $e')),
                        );
                      }
                    }
                  },
                ),
              ),

            // Lyrics & Meaning Tabs
            Expanded(
              child: Stack(
                children: [
                  TabBarView(
                    controller: _tabController,
                    children: [
                      _ReaderBody(
                        text: h.lyricsTelugu.isNotEmpty
                            ? h.lyricsTelugu
                            : 'ఈ హారతికి లిరిక్స్ లేవు. పైన ఉన్న PDF బటన్ నొక్కి పూర్తి పత్రం చదవండి.',
                        fontSize: provider.fontSize,
                      ),
                      _ReaderBody(
                        text: h.lyricsEnglish.isNotEmpty
                            ? h.lyricsEnglish
                            : 'No English lyrics available. Please open the attached PDF above.',
                        fontSize: provider.fontSize,
                      ),
                      _ReaderBody(
                        text: h.meaning.isNotEmpty
                            ? h.meaning
                            : 'స్వామివారి దివ్య మంగళ హారతి.',
                        fontSize: provider.fontSize,
                        isMeaning: true,
                      ),
                    ],
                  ),
                  if (_isFullscreen)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: SafeArea(
                        child: Container(
                          decoration: BoxDecoration(
                            color: (isDark ? Colors.black : Colors.white).withOpacity(0.85),
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.goldBorder),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.fullscreen_exit),
                            onPressed: () => setState(() => _isFullscreen = false),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReaderBody extends StatelessWidget {
  final String text;
  final double fontSize;
  final bool isMeaning;

  const _ReaderBody({
    required this.text,
    required this.fontSize,
    this.isMeaning = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Center(
        child: SelectableText(
          text,
          textAlign: isMeaning ? TextAlign.start : TextAlign.center,
          style: TextStyle(
            fontFamily: 'NotoSansTelugu',
            fontSize: fontSize,
            height: 1.9,
            fontWeight: isMeaning ? FontWeight.w500 : FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.deepMaroon,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
