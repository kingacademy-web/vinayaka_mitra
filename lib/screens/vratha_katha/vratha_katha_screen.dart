import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/vratha_katha.dart';
import '../../services/firebase_service.dart';

class VrathaKathaScreen extends StatefulWidget {
  const VrathaKathaScreen({super.key});

  @override
  State<VrathaKathaScreen> createState() => _VrathaKathaScreenState();
}

class _VrathaKathaScreenState extends State<VrathaKathaScreen> {
  final FirebaseService _service = FirebaseService();
  List<KathaChapter> _chapters = [];
  bool _isLoading = true;
  double _fontSize = 16.0;

  @override
  void initState() {
    super.initState();
    _loadKatha();
  }

  Future<void> _loadKatha() async {
    final list = await _service.getVrathaKatha();
    setState(() {
      _chapters = list;
      _isLoading = false;
    });
  }

  void _shareDoshaNivarana() {
    const text = '''
🌙 చంద్రదర్శన దోష నివారణ మంత్రం 🌙

సింహః ప్రసేనమవధీత్ సింహో జాంబవతా హతః |
సుకుమారక మా రోదీః తవ హ్యేష స్యమంతకః ||

భావం: సింహము ప్రసేనుడిని చంపెను, ఆ సింహమును జాంబవంతుడు చంపెను. ఓ సుకుమారా! ఏడవకు, ఈ శమంతకమణి నీదే.

(వినాయక చవితి నాడు చంద్రుడిని చూసినవారు ఈ శ్లోకాన్ని పఠించి అక్షింతలు శిరస్సుపై ధరించవలెను)
— వినాయక మిత్ర
''';
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('శ్రీ వినాయక వ్రత కథ'),
        actions: [
          IconButton(
            tooltip: 'అక్షరాల పరిమాణం తగ్గించు',
            icon: const Icon(Icons.text_decrease),
            onPressed: () {
              if (_fontSize > 13) setState(() => _fontSize -= 1.5);
            },
          ),
          IconButton(
            tooltip: 'అక్షరాల పరిమాణం పెంచు',
            icon: const Icon(Icons.text_increase),
            onPressed: () {
              if (_fontSize < 26) setState(() => _fontSize += 1.5);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.saffron))
          : _chapters.isEmpty
              ? const Center(child: Text('వ్రత కథ వివరాలు అందుబాటులో లేవు'))
              : ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Special Dosha Nivarana Banner
                    Card(
                      color: isDark ? const Color(0xFF332014) : AppColors.goldSoft,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.nightlight_round, color: AppColors.saffron),
                                const SizedBox(width: 8),
                                Text(
                                  'చంద్రదర్శన దోష నివారణ మంత్రం',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                    color: isDark ? AppColors.royalGold : AppColors.maroon,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.share, size: 18),
                                  onPressed: _shareDoshaNivarana,
                                ),
                              ],
                            ),
                            const Divider(),
                            const Text(
                              'సింహః ప్రసేనమవధీత్ సింహో జాంబవతా హతః |\nసుకుమారక మా రోదీః తవ హ్యేష స్యమంతకః ||',
                              style: TextStyle(
                                fontFamily: 'NotoSansTelugu',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                height: 1.8,
                                color: AppColors.saffron,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'ఈ శ్లోకమును చదివి అక్షింతలను తలపై వేసుకున్నచో చవితి చంద్రుని చూసిన దోషము తొలగిపోవును.',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Chapters list
                    ..._chapters.map((chapter) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ExpansionTile(
                          initiallyExpanded: chapter.chapterNumber == 1,
                          leading: CircleAvatar(
                            backgroundColor: isDark
                                ? AppColors.darkSurfaceElevated
                                : AppColors.goldSoft,
                            child: Text(
                              '${chapter.chapterNumber}',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: isDark ? AppColors.royalGold : AppColors.deepGold,
                              ),
                            ),
                          ),
                          title: Text(
                            chapter.titleTe,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            chapter.titleEn,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade600,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SelectableText(
                                    chapter.contentTe,
                                    style: TextStyle(
                                      fontFamily: 'NotoSansTelugu',
                                      fontSize: _fontSize,
                                      height: 1.8,
                                      color: isDark ? AppColors.darkTextPrimary : Colors.black87,
                                    ),
                                  ),
                                  if (chapter.sloka != null) ...[
                                    const SizedBox(height: 12),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? AppColors.darkChip
                                            : AppColors.goldSoft.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: AppColors.goldBorder.withOpacity(0.4),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            chapter.sloka!,
                                            style: TextStyle(
                                              fontFamily: 'NotoSansTelugu',
                                              fontSize: _fontSize,
                                              fontWeight: FontWeight.w700,
                                              color: isDark
                                                  ? AppColors.royalGold
                                                  : AppColors.deepGold,
                                              height: 1.7,
                                            ),
                                          ),
                                          if (chapter.slokaMeaning != null) ...[
                                            const SizedBox(height: 6),
                                            Text(
                                              chapter.slokaMeaning!,
                                              style: TextStyle(
                                                fontSize: _fontSize - 2,
                                                fontStyle: FontStyle.italic,
                                                color: isDark
                                                    ? AppColors.darkTextSecondary
                                                    : Colors.grey.shade700,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
    );
  }
}
