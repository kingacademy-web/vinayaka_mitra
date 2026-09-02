import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/mandali_models.dart';
import '../../providers/language_provider.dart';
import '../../services/mandali_service.dart';

class MandaliHubScreen extends StatefulWidget {
  const MandaliHubScreen({super.key});

  @override
  State<MandaliHubScreen> createState() => _MandaliHubScreenState();
}

class _MandaliHubScreenState extends State<MandaliHubScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _commNameCtrl = TextEditingController(text: 'శ్రీ వినాయక ఉత్సవ కమిటీ');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _commNameCtrl.dispose();
    super.dispose();
  }

  // --- Add Chanda Dialog ---
  void _showAddChandaModal(BuildContext context) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    String paymentMode = 'Cash';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final lang = context.watch<LanguageProvider>();
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
                    lang.t('addChanda'),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.saffron),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      labelText: lang.t('donorName'),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: lang.t('donorPhone'),
                      prefixIcon: const Icon(Icons.phone_outlined),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: amountCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: lang.t('chandaAmount'),
                      prefixIcon: const Icon(Icons.currency_rupee),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: paymentMode,
                    decoration: InputDecoration(labelText: lang.t('paymentMode')),
                    items: [
                      DropdownMenuItem(value: 'Cash', child: Text(lang.t('cash'))),
                      DropdownMenuItem(value: 'UPI', child: Text(lang.t('upi'))),
                      DropdownMenuItem(value: 'Bank', child: Text(lang.t('bank'))),
                    ],
                    onChanged: (val) {
                      if (val != null) setModalState(() => paymentMode = val);
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: notesCtrl,
                    decoration: InputDecoration(labelText: lang.t('notes')),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check_circle),
                      label: Text(lang.t('save')),
                      onPressed: () async {
                        final amt = double.tryParse(amountCtrl.text) ?? 0.0;
                        if (nameCtrl.text.isEmpty || amt <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('దయచేసి దాత పేరు మరియు మొత్తం నమోదు చేయండి.')),
                          );
                          return;
                        }

                        final service = context.read<MandaliService>();
                        final newRecord = ChandaRecord(
                          id: 'chanda_${DateTime.now().millisecondsSinceEpoch}',
                          receiptNo: 'VM-${service.chandas.length + 1}',
                          donorName: nameCtrl.text.trim(),
                          phoneNumber: phoneCtrl.text.trim(),
                          amount: amt,
                          paymentMode: paymentMode,
                          date: DateTime.now(),
                          notes: notesCtrl.text.trim(),
                        );

                        await service.addChanda(newRecord);
                        if (mounted) {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(lang.t('chandaSuccess')),
                              action: SnackBarAction(
                                label: lang.t('shareReceipt'),
                                onPressed: () => service.shareChandaReceipt(
                                  newRecord,
                                  committeeName: _commNameCtrl.text,
                                  lang: lang.currentLanguage,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Add Expense Dialog ---
  void _showAddExpenseModal(BuildContext context) {
    final descCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final paidToCtrl = TextEditingController();
    String category = 'మండపం & డెకరేషన్';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final lang = context.watch<LanguageProvider>();
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
                    lang.t('addExpense'),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.maroon),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: category,
                    decoration: InputDecoration(labelText: lang.t('expenseCategory')),
                    items: const [
                      DropdownMenuItem(value: 'మండపం & డెకరేషన్', child: Text('మండపం & డెకరేషన్')),
                      DropdownMenuItem(value: 'విగ్రహం కొనుగోలు', child: Text('విగ్రహం కొనుగోలు')),
                      DropdownMenuItem(value: 'మైక్ సెట్ & లైటింగ్', child: Text('మైక్ సెట్ & లైటింగ్')),
                      DropdownMenuItem(value: 'పూజారి గారి దక్షిణ', child: Text('పూజారి గారి దక్షిణ')),
                      DropdownMenuItem(value: 'ప్రసాదం & అన్నదానం', child: Text('ప్రసాదం & అన్నదానం')),
                      DropdownMenuItem(value: 'నిమజ్జనం వాహనం', child: Text('నిమజ్జనం వాహనం')),
                      DropdownMenuItem(value: 'ఇతర ఖర్చులు', child: Text('ఇతర ఖర్చులు (Misc)')),
                    ],
                    onChanged: (val) {
                      if (val != null) setModalState(() => category = val);
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descCtrl,
                    decoration: InputDecoration(labelText: lang.t('expenseDesc')),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: amountCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: lang.t('expenseAmount'),
                      prefixIcon: const Icon(Icons.currency_rupee),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: paidToCtrl,
                    decoration: InputDecoration(labelText: lang.t('paidTo')),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.maroon),
                      onPressed: () async {
                        final amt = double.tryParse(amountCtrl.text) ?? 0.0;
                        if (amt <= 0) return;

                        final newExp = ExpenseRecord(
                          id: 'exp_${DateTime.now().millisecondsSinceEpoch}',
                          category: category,
                          description: descCtrl.text.trim(),
                          amount: amt,
                          paidTo: paidToCtrl.text.trim(),
                          date: DateTime.now(),
                        );

                        await context.read<MandaliService>().addExpense(newExp);
                        if (mounted) Navigator.pop(ctx);
                      },
                      child: Text(lang.t('save')),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Add Committee Member Dialog ---
  void _showAddMemberModal(BuildContext context) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final dutyCtrl = TextEditingController();
    String role = 'సభ్యుడు (Member)';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final lang = context.watch<LanguageProvider>();
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
                    lang.t('addMember'),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.deepGold),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: nameCtrl,
                    decoration: InputDecoration(labelText: lang.t('memberName')),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: role,
                    decoration: InputDecoration(labelText: lang.t('memberRole')),
                    items: const [
                      DropdownMenuItem(value: 'అధ్యక్షుడు (President)', child: Text('అధ్యక్షుడు (President)')),
                      DropdownMenuItem(value: 'కార్యదర్శి (Secretary)', child: Text('కార్యదర్శి (Secretary)')),
                      DropdownMenuItem(value: 'కోశాధికారి (Treasurer)', child: Text('కోశాధికారి (Treasurer)')),
                      DropdownMenuItem(value: 'వాలంటీర్ (Volunteer)', child: Text('వాలంటీర్ (Volunteer)')),
                      DropdownMenuItem(value: 'సభ్యుడు (Member)', child: Text('సభ్యుడు (Member)')),
                    ],
                    onChanged: (val) {
                      if (val != null) setModalState(() => role = val);
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(labelText: lang.t('memberPhone')),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: dutyCtrl,
                    decoration: InputDecoration(
                      labelText: lang.t('dutyAssigned'),
                      hintText: 'ఉదా: అన్నదానం పర్యవేక్షణ, మైక్ & కరెంట్',
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (nameCtrl.text.isEmpty) return;

                        final newMember = CommitteeMember(
                          id: 'member_${DateTime.now().millisecondsSinceEpoch}',
                          name: nameCtrl.text.trim(),
                          role: role,
                          phoneNumber: phoneCtrl.text.trim(),
                          dutyAssigned: dutyCtrl.text.trim(),
                        );

                        await context.read<MandaliService>().addMember(newMember);
                        if (mounted) Navigator.pop(ctx);
                      },
                      child: Text(lang.t('save')),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Record Auction Dialog ---
  void _showRecordAuctionModal(BuildContext context) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final bidCtrl = TextEditingController();
    bool isPaid = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final lang = context.watch<LanguageProvider>();
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
                    lang.t('recordAuction'),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.saffron),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: nameCtrl,
                    decoration: InputDecoration(labelText: lang.t('auctionWinner')),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(labelText: lang.t('donorPhone')),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: bidCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: lang.t('bidAmount'),
                      prefixIcon: const Icon(Icons.currency_rupee),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SwitchListTile(
                    title: Text(lang.t('paidStatus')),
                    subtitle: Text(isPaid ? lang.t('paid') : lang.t('pending')),
                    value: isPaid,
                    activeColor: AppColors.greenAuspicious,
                    onChanged: (val) => setModalState(() => isPaid = val),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final amt = double.tryParse(bidCtrl.text) ?? 0.0;
                        if (nameCtrl.text.isEmpty || amt <= 0) return;

                        final newAuction = LadduAuction(
                          id: 'auc_${DateTime.now().millisecondsSinceEpoch}',
                          year: DateTime.now().year,
                          winnerName: nameCtrl.text.trim(),
                          phoneNumber: phoneCtrl.text.trim(),
                          bidAmount: amt,
                          isPaid: isPaid,
                          date: DateTime.now(),
                        );

                        await context.read<MandaliService>().addAuction(newAuction);
                        if (mounted) Navigator.pop(ctx);
                      },
                      child: Text(lang.t('save')),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Add Custom Event Modal ---
  void _showAddEventModal(BuildContext context) {
    final titleCtrl = TextEditingController();
    final timeCtrl = TextEditingController();
    final inchargeCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    int dayNum = 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final lang = context.watch<LanguageProvider>();
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
                    lang.t('addEvent'),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.deepGold),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Text('రోజు (Day): ', style: TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(width: 8),
                      DropdownButton<int>(
                        value: dayNum,
                        items: List.generate(11, (i) => i + 1)
                            .map((d) => DropdownMenuItem(value: d, child: Text('Day $d')))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setModalState(() => dayNum = val);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: titleCtrl,
                    decoration: InputDecoration(labelText: lang.t('eventTitle')),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: timeCtrl,
                    decoration: InputDecoration(labelText: lang.t('eventTime'), hintText: 'ఉదా: సాయంత్రం 06:30 PM'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: inchargeCtrl,
                    decoration: InputDecoration(labelText: lang.t('incharge')),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: 'కార్యక్రమ వివరాలు (Details)'),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (titleCtrl.text.isEmpty) return;

                        final newEv = FestivalEvent(
                          id: 'ev_${DateTime.now().millisecondsSinceEpoch}',
                          dayNumber: dayNum,
                          title: titleCtrl.text.trim(),
                          time: timeCtrl.text.trim(),
                          incharge: inchargeCtrl.text.trim(),
                          description: descCtrl.text.trim(),
                        );

                        await context.read<MandaliService>().addEvent(newEv);
                        if (mounted) Navigator.pop(ctx);
                      },
                      child: Text(lang.t('save')),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final mandali = context.watch<MandaliService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.t('mandaliTitle')),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(icon: const Icon(Icons.receipt_long), text: lang.t('tabChanda')),
            Tab(icon: const Icon(Icons.shopping_bag_outlined), text: lang.t('tabExpenses')),
            Tab(icon: const Icon(Icons.account_balance), text: lang.t('tabAudit')),
            Tab(icon: const Icon(Icons.group), text: lang.t('tabCommittee')),
            Tab(icon: const Icon(Icons.emoji_events), text: lang.t('tabAuction')),
            Tab(icon: const Icon(Icons.calendar_month), text: lang.t('tabSchedule')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. Chanda Tab
          _buildChandaTab(mandali, lang, isDark),

          // 2. Expenses Tab
          _buildExpensesTab(mandali, lang, isDark),

          // 3. Audit & Balance Sheet Tab
          _buildAuditTab(mandali, lang, isDark),

          // 4. Committee Members Tab
          _buildCommitteeTab(mandali, lang, isDark),

          // 5. Laddu Auction Tab
          _buildAuctionTab(mandali, lang, isDark),

          // 6. Schedule Tab
          _buildScheduleTab(mandali, lang, isDark),
        ],
      ),
      floatingActionButton: _buildFabForCurrentTab(context),
    );
  }

  Widget? _buildFabForCurrentTab(BuildContext context) {
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, _) {
        switch (_tabController.index) {
          case 0:
            return FloatingActionButton.extended(
              backgroundColor: AppColors.saffron,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('చందా నమోదు', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              onPressed: () => _showAddChandaModal(context),
            );
          case 1:
            return FloatingActionButton.extended(
              backgroundColor: AppColors.maroon,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('ఖర్చు నమోదు', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              onPressed: () => _showAddExpenseModal(context),
            );
          case 3:
            return FloatingActionButton.extended(
              backgroundColor: AppColors.deepGold,
              icon: const Icon(Icons.person_add, color: Colors.white),
              label: const Text('సభ్యుడి చేరిక', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              onPressed: () => _showAddMemberModal(context),
            );
          case 4:
            return FloatingActionButton.extended(
              backgroundColor: AppColors.saffron,
              icon: const Icon(Icons.gavel, color: Colors.white),
              label: const Text('వేలం నమోదు', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              onPressed: () => _showRecordAuctionModal(context),
            );
          case 5:
            return FloatingActionButton.extended(
              backgroundColor: AppColors.royalGold,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('కార్యక్రమం చేర్చు', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              onPressed: () => _showAddEventModal(context),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  // --- TAB 1: CHANDA ---
  Widget _buildChandaTab(MandaliService m, LanguageProvider lang, bool isDark) {
    return Column(
      children: [
        // Summary Header
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.saffron, AppColors.deepSaffron],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.saffron.withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang.t('totalChanda'),
                    style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${m.totalChandaAmount.toStringAsFixed(0)}',
                    style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${m.chandas.length} దాతలు',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14),
                ),
              ),
            ],
          ),
        ),

        // Chanda List
        Expanded(
          child: m.chandas.isEmpty
              ? const Center(child: Text('ఇంకా చందాలు నమోదు కాలేదు. ➕ పై నొక్కి నమోదు చేయండి.'))
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                  itemCount: m.chandas.length,
                  itemBuilder: (context, index) {
                    final c = m.chandas[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.saffron.withOpacity(0.15),
                          child: const Icon(Icons.receipt, color: AppColors.saffron),
                        ),
                        title: Text(
                          c.donorName,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                        ),
                        subtitle: Text(
                          '${c.receiptNo} • ${c.paymentMode} • ${c.phoneNumber.isNotEmpty ? c.phoneNumber : "No Phone"}',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '₹${c.amount.toStringAsFixed(0)}',
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: AppColors.greenAuspicious),
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              icon: const Icon(Icons.share, color: AppColors.saffron, size: 20),
                              tooltip: lang.t('shareReceipt'),
                              onPressed: () => m.shareChandaReceipt(
                                c,
                                committeeName: _commNameCtrl.text,
                                lang: lang.currentLanguage,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // --- TAB 2: EXPENSES ---
  Widget _buildExpensesTab(MandaliService m, LanguageProvider lang, bool isDark) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceElevated : AppColors.goldSoft,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.maroon.withOpacity(0.4)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang.t('totalExpenses'),
                    style: TextStyle(color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade700, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${m.totalExpensesAmount.toStringAsFixed(0)}',
                    style: const TextStyle(color: AppColors.maroon, fontSize: 26, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.maroon.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${m.expenses.length} ఖర్చులు',
                  style: const TextStyle(color: AppColors.maroon, fontWeight: FontWeight.w800, fontSize: 14),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: m.expenses.isEmpty
              ? const Center(child: Text('ఎలాంటి ఖర్చులు నమోదు కాలేదు.'))
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                  itemCount: m.expenses.length,
                  itemBuilder: (context, index) {
                    final e = m.expenses[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.maroon.withOpacity(0.12),
                          child: const Icon(Icons.money_off, color: AppColors.maroon),
                        ),
                        title: Text(e.category, style: const TextStyle(fontWeight: FontWeight.w700)),
                        subtitle: Text('${e.description} • చెల్లించినది: ${e.paidTo}'),
                        trailing: Text(
                          '₹${e.amount.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.maroon),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // --- TAB 3: AUDIT & BALANCE SHEET ---
  Widget _buildAuditTab(MandaliService m, LanguageProvider lang, bool isDark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Committee Name editor
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ఉత్సవ కమిటీ / మండలి పేరు:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _commNameCtrl,
                    decoration: const InputDecoration(
                      hintText: 'ఉదా: శ్రీ వినాయక యూత్ అసోసియేషన్',
                      prefixIcon: Icon(Icons.festival),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Big Balance Card
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    lang.t('netBalance'),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${m.netBalance.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: m.netBalance >= 0 ? AppColors.greenAuspicious : AppColors.maroon,
                    ),
                  ),
                  const Divider(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(lang.t('totalIncome'), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text(
                            '₹${m.totalIncome.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.greenAuspicious),
                          ),
                        ],
                      ),
                      Container(width: 1, height: 35, color: Colors.grey.shade300),
                      Column(
                        children: [
                          Text(lang.t('totalExpenses'), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text(
                            '₹${m.totalExpensesAmount.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.maroon),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Share Button for WhatsApp
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366), // WhatsApp Green
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 2,
            ),
            icon: const Icon(Icons.share, color: Colors.white),
            label: Text(
              lang.t('shareBalanceSheet'),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
            ),
            onPressed: () => m.shareAuditReport(
              committeeName: _commNameCtrl.text,
              lang: lang.currentLanguage,
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 4: COMMITTEE MEMBERS ---
  Widget _buildCommitteeTab(MandaliService m, LanguageProvider lang, bool isDark) {
    if (m.members.isEmpty) {
      return const Center(child: Text('కమిటీ సభ్యులు ఎవరూ చేర్చబడలేదు. ➕ నొక్కి చేర్చండి.'));
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: m.members.length,
      itemBuilder: (context, index) {
        final mem = m.members[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.royalGold.withOpacity(0.2),
              child: const Icon(Icons.person, color: AppColors.deepGold),
            ),
            title: Text(mem.name, style: const TextStyle(fontWeight: FontWeight.w800)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${mem.role} • ${mem.dutyAssigned}'),
                if (mem.phoneNumber.isNotEmpty) Text('📞 ${mem.phoneNumber}'),
              ],
            ),
            trailing: mem.phoneNumber.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.phone, color: AppColors.greenAuspicious),
                    onPressed: () => launchUrl(Uri.parse('tel:${mem.phoneNumber}')),
                  )
                : null,
          ),
        );
      },
    );
  }

  // --- TAB 5: LADDU AUCTION ---
  Widget _buildAuctionTab(MandaliService m, LanguageProvider lang, bool isDark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFB300), Color(0xFFFF8F00)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text('🏆 గణపతి ప్రసాద లడ్డూ వేలంపాట', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                const Text('ఉత్సవంలో ప్రసాద లడ్డూ దక్కించుకున్న భక్తుల వివరాలు', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (m.auctions.isEmpty)
            const Center(child: Padding(padding: EdgeInsets.all(32), child: Text('ఇంకా లడ్డూ వేలం నమోదు కాలేదు. ➕ నొక్కి నమోదు చేయండి.')))
          else
            ...m.auctions.map((auc) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${auc.year} లడ్డూ విజేత', style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.deepGold)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: auc.isPaid ? AppColors.greenAuspicious.withOpacity(0.15) : Colors.orange.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                auc.isPaid ? 'చెల్లించారు (Paid)' : 'బాకీ (Pending)',
                                style: TextStyle(
                                  color: auc.isPaid ? AppColors.greenAuspicious : Colors.orange.shade900,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(auc.winnerName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 4),
                        Text('వేలం మొత్తం: ₹${auc.bidAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.saffron)),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.share),
                            label: const Text('విజేతను WhatsApp లో ప్రకటించండి'),
                            onPressed: () => m.shareLadduAuction(
                              auc,
                              committeeName: _commNameCtrl.text,
                              lang: lang.currentLanguage,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
        ],
      ),
    );
  }

  // --- TAB 6: SCHEDULE & TIMELINE ---
  Widget _buildScheduleTab(MandaliService m, LanguageProvider lang, bool isDark) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: m.events.length,
      itemBuilder: (context, index) {
        final ev = m.events[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.saffron,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Day ${ev.dayNumber}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        ev.time,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  ev.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  ev.description,
                  style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextSecondary : Colors.black87),
                ),
                const SizedBox(height: 8),
                Text(
                  'బాధ్యత: ${ev.incharge}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.deepGold),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.share, size: 18),
                    label: Text(lang.t('shareInvitation')),
                    onPressed: () => m.shareEventInvitation(
                      ev,
                      committeeName: _commNameCtrl.text,
                      lang: lang.currentLanguage,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
