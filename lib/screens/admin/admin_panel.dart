import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
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
    final admin = await _service.checkIsAdmin();
    setState(() {
      _isAdmin = admin;
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

    String? pickedPdfPath = existing?.pdfPath;
    String? pickedPdfName = existing?.pdfPath != null ? existing!.pdfPath!.split('/').last : null;

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

                    // PDF Document Picker Section
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.saffron.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.saffron.withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.picture_as_pdf, color: AppColors.saffron),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  pickedPdfName != null
                                      ? 'జతచేసిన PDF: $pickedPdfName'
                                      : 'PDF డాక్యుమెంట్ జతచేయండి (ఐచ్ఛికం)',
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (pickedPdfPath != null)
                                IconButton(
                                  icon: const Icon(Icons.close, size: 18, color: AppColors.maroon),
                                  tooltip: 'PDF తొలగించు',
                                  onPressed: () {
                                    setModalState(() {
                                      pickedPdfPath = null;
                                      pickedPdfName = null;
                                    });
                                  },
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.upload_file, size: 18),
                              label: Text(pickedPdfPath != null ? 'వేరే PDF మార్చండి' : '📄 PDF అప్‌లోడ్ చేయండి'),
                              onPressed: () async {
                                final result = await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['pdf'],
                                );
                                if (result != null && result.files.single.path != null) {
                                  final originalFile = File(result.files.single.path!);
                                  final appDir = await getApplicationDocumentsDirectory();
                                  final fileName = 'harathi_${DateTime.now().millisecondsSinceEpoch}.pdf';
                                  final savedFile = await originalFile.copy('${appDir.path}/$fileName');
                                  setModalState(() {
                                    pickedPdfPath = savedFile.path;
                                    pickedPdfName = result.files.single.name;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
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
                      maxLines: 3,
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
                          if (titleTeCtrl.text.isEmpty && titleEnCtrl.text.isEmpty) return;

                          final newHarathi = Harathi(
                            id: existing?.id ?? 'harathi_${DateTime.now().millisecondsSinceEpoch}',
                            titleTe: titleTeCtrl.text.isNotEmpty ? titleTeCtrl.text : titleEnCtrl.text,
                            titleEn: titleEnCtrl.text.isNotEmpty ? titleEnCtrl.text : titleTeCtrl.text,
                            category: selectedCategory,
                            lyricsTelugu: lyricsTeCtrl.text,
                            lyricsEnglish: lyricsEnCtrl.text,
                            meaning: meaningCtrl.text,
                            pdfPath: pickedPdfPath,
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
    if (_notifTitleCtrl.text.isEmpty || _notifBodyCtrl.text.isEmpty) return;

    await _service.sendNotification(
      title: _notifTitleCtrl.text,
      body: _notifBodyCtrl.text,
    );

    _notifTitleCtrl.clear();
    _notifBodyCtrl.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('నోటిఫికేషన్ విజయవంతంగా నమోదు చేయబడింది!'),
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
                      leading: h.pdfPath != null
                          ? const Icon(Icons.picture_as_pdf, color: AppColors.saffron)
                          : const Icon(Icons.local_fire_department, color: AppColors.deepGold),
                      title: Text(h.titleTe, style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text('${h.category.toUpperCase()} • ${h.titleEn}${h.pdfPath != null ? " [PDF]" : ""}'),
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
                  '📢 భక్తులకు భక్తి సమాచారం పంపండి',
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
                    label: const Text('నోటిఫికేషన్ నమోదు చేయండి'),
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
