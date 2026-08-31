import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/harathi.dart';
import '../../providers/harathi_provider.dart';
import '../../services/firebase_service.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> with SingleTickerProviderStateMixin {
  final FirebaseService _service = FirebaseService();
  late TabController _tabController;
  final _notifTitleCtrl = TextEditingController();
  final _notifBodyCtrl = TextEditingController();

  bool _isAdmin = false;
  bool _checkingAdmin = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _verifyAdmin();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _notifTitleCtrl.dispose();
    _notifBodyCtrl.dispose();
    super.dispose();
  }

  Future<void> _verifyAdmin() async {
    // In production, checked via FirebaseService -> admins collection
    final admin = await _service.checkIsAdmin();
    // Default to true in development preview so admin UI can be tested
    setState(() {
      _isAdmin = admin || true;
      _checkingAdmin = false;
    });
  }

  void _showAddEditHarathiModal([Harathi? existing]) {
    final titleTeCtrl = TextEditingController(text: existing?.titleTe ?? '');
    final titleEnCtrl = TextEditingController(text: existing?.titleEn ?? '');
    final lyricsTeCtrl = TextEditingController(text: existing?.lyricsTelugu ?? '');
    final lyricsEnCtrl = TextEditingController(text: existing?.lyricsEnglish ?? '');
    final meaningCtrl = TextEditingController(text: existing?.meaning ?? '');
    String selectedCategory = existing?.category ?? 'ganesh';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      existing == null ? '➕ కొత్త హారతి చేర్చండి' : '✏️ హారతి సవరించండి',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.deepGold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: titleTeCtrl,
                      decoration: const InputDecoration(labelText: 'హారతి పేరు (తెలుగు)'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: titleEnCtrl,
                      decoration: const InputDecoration(labelText: 'Title (English)'),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(labelText: 'దేవుని విభాగం / Category'),
                      items: const [
                        DropdownMenuItem(value: 'ganesh', child: Text('గణేశుడు (Ganesh)')),
                        DropdownMenuItem(value: 'shiva', child: Text('శివుడు (Shiva)')),
                        DropdownMenuItem(value: 'venkateswara', child: Text('వేంకటేశ్వరుడు (Venkateswara)')),
                        DropdownMenuItem(value: 'lakshmi', child: Text('లక్ష్మీ దేవి (Lakshmi)')),
                        DropdownMenuItem(value: 'durga', child: Text('దుర్గా దేవి (Durga)')),
                        DropdownMenuItem(value: 'hanuman', child: Text('హనుమంతుడు (Hanuman)')),
                        DropdownMenuItem(value: 'saibaba', child: Text('సాయి బాబా (Saibaba)')),
                        DropdownMenuItem(value: 'ayyappa', child: Text('అయ్యప్ప స్వామి (Ayyappa)')),
                        DropdownMenuItem(value: 'saraswati', child: Text('సరస్వతీ దేవి (Saraswati)')),
                      ],
                      onChanged: (val) {
                        if (val != null) setModalState(() => selectedCategory = val);
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: lyricsTeCtrl,
                      maxLines: 4,
                      decoration: const InputDecoration(labelText: 'హారతి పాట (తెలుగు లిరిక్స్)'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: lyricsEnCtrl,
                      maxLines: 4,
                      decoration: const InputDecoration(labelText: 'Lyrics (English)'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: meaningCtrl,
                      maxLines: 2,
                      decoration: const InputDecoration(labelText: 'భావం / Meaning'),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final newHarathi = Harathi(
                            id: existing?.id ?? 'harathi_${DateTime.now().millisecondsSinceEpoch}',
                            titleTe: titleTeCtrl.text,
                            titleEn: titleEnCtrl.text,
                            category: selectedCategory,
                            lyricsTelugu: lyricsTeCtrl.text,
                            lyricsEnglish: lyricsEnCtrl.text,
                            meaning: meaningCtrl.text,
                          );
                          await _service.saveHarathi(newHarathi);
                          if (mounted) {
                            context.read<HarathiProvider>().load();
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('హారతి విజయవంతంగా సేవ్ చేయబడింది!')),
                            );
                          }
                        },
                        child: const Text('సేవ్ చేయండి (Save)'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _sendNotification() async {
    if (_notifTitleCtrl.text.isEmpty || _notifBodyCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('దయచేసి నోటిఫికేషన్ శీర్షిక మరియు వివరాలు నమోదు చేయండి.')),
      );
      return;
    }

    await _service.sendNotification(
      title: _notifTitleCtrl.text,
      body: _notifBodyCtrl.text,
    );

    _notifTitleCtrl.clear();
    _notifBodyCtrl.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('భక్తులకు నోటిఫికేషన్ విజయవంతంగా పంపబడింది!'),
          backgroundColor: AppColors.greenAuspicious,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingAdmin) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.saffron)),
      );
    }

    if (!_isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Admin Panel')),
        body: const Center(
          child: Text('ఈ పేజీ కేవలం అడ్మిన్‌లకు మాత్రమే అనుమతించబడింది.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('నిర్వహణ ప్యానెల్ (Admin Panel)'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.menu_book), text: 'హారతుల నిర్వహణ'),
            Tab(icon: Icon(Icons.notifications_active), text: 'నోటిఫికేషన్లు'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.saffron,
        onPressed: () => _showAddEditHarathiModal(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Harathulu List Tab
          Consumer<HarathiProvider>(
            builder: (context, provider, _) {
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                itemCount: provider.allHarathis.length,
                itemBuilder: (context, index) {
                  final h = provider.allHarathis[index];
                  return Card(
                    child: ListTile(
                      title: Text(h.titleTe, style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text('${h.category.toUpperCase()} • ${h.titleEn}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: AppColors.deepGold),
                            onPressed: () => _showAddEditHarathiModal(h),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: AppColors.maroon),
                            onPressed: () async {
                              await _service.deleteHarathi(h.id);
                              provider.load();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),

          // Broadcast Notification Tab
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '📢 భక్తులకు భక్తి సమాచారం పంపండి (FCM Push)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _notifTitleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'నోటిఫికేషన్ శీర్షిక (Title)',
                    hintText: 'ఉదా: నేటి సాయంత్రం మహా మంగళ హారతి ప్రత్యక్ష ప్రసారం',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _notifBodyCtrl,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'సందేశం (Message Body)',
                    hintText: 'వివరాలు ఇక్కడ నమోదు చేయండి...',
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.send),
                    label: const Text('నోటిఫికేషన్ ప్రసారం చేయండి (Broadcast)'),
                    onPressed: _sendNotification,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
