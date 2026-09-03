import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../data/models/mandali_models.dart';

class MandaliService extends ChangeNotifier {
  static final MandaliService _instance = MandaliService._internal();
  factory MandaliService() => _instance;
  MandaliService._internal();

  static const String _chandaBoxName = 'mandali_chanda_box';
  static const String _expenseBoxName = 'mandali_expense_box';
  static const String _committeeBoxName = 'mandali_committee_box';
  static const String _auctionBoxName = 'mandali_auction_box';
  static const String _scheduleBoxName = 'mandali_schedule_box';

  List<ChandaRecord> _chandas = [];
  List<ExpenseRecord> _expenses = [];
  List<CommitteeMember> _members = [];
  List<LadduAuction> _auctions = [];
  List<FestivalEvent> _events = [];

  List<ChandaRecord> get chandas => _chandas;
  List<ExpenseRecord> get expenses => _expenses;
  List<CommitteeMember> get members => _members;
  List<LadduAuction> get auctions => _auctions;
  List<FestivalEvent> get events => _events;

  double get totalChandaAmount => _chandas.fold(0.0, (sum, c) => sum + c.amount);
  double get totalAuctionAmount => _auctions.where((a) => a.isPaid).fold(0.0, (sum, a) => sum + a.bidAmount);
  double get totalIncome => totalChandaAmount + totalAuctionAmount;
  double get totalExpensesAmount => _expenses.fold(0.0, (sum, e) => sum + e.amount);
  double get netBalance => totalIncome - totalExpensesAmount;

  Future<void> init() async {
    try {
      await Hive.openBox(_chandaBoxName);
      await Hive.openBox(_expenseBoxName);
      await Hive.openBox(_committeeBoxName);
      await Hive.openBox(_auctionBoxName);
      await Hive.openBox(_scheduleBoxName);

      _loadAll();
    } catch (e) {
      debugPrint('MandaliService Hive init error: $e');
    }
  }

  void _loadAll() {
    try {
      // Load Chanda
      final chandaBox = Hive.box(_chandaBoxName);
      _chandas = chandaBox.values
          .map((v) => ChandaRecord.fromMap(Map<String, dynamic>.from(v as Map)))
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));

      // Load Expenses
      final expBox = Hive.box(_expenseBoxName);
      _expenses = expBox.values
          .map((v) => ExpenseRecord.fromMap(Map<String, dynamic>.from(v as Map)))
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));

      // Load Members
      final commBox = Hive.box(_committeeBoxName);
      _members = commBox.values
          .map((v) => CommitteeMember.fromMap(Map<String, dynamic>.from(v as Map)))
          .toList();

      // Load Auctions
      final aucBox = Hive.box(_auctionBoxName);
      _auctions = aucBox.values
          .map((v) => LadduAuction.fromMap(Map<String, dynamic>.from(v as Map)))
          .toList();

      // Load Schedule
      final schBox = Hive.box(_scheduleBoxName);
      _events = schBox.values
          .map((v) => FestivalEvent.fromMap(Map<String, dynamic>.from(v as Map)))
          .toList()
        ..sort((a, b) => a.dayNumber.compareTo(b.dayNumber));

      if (_events.isEmpty) {
        _seedDefaultEvents();
      }

      notifyListeners();
    } catch (e) {
      debugPrint('MandaliService load error: $e');
    }
  }

  Future<void> _seedDefaultEvents() async {
    final defaults = [
      FestivalEvent(
        id: 'event_1',
        dayNumber: 1,
        title: 'మహా గణపతి ప్రతిష్టాపన & షోడశోపచార పూజ',
        time: 'ఉదయం 08:30 AM',
        incharge: 'ప్రెసిడెంట్ & కార్యదర్శి',
        description: 'విఘ్నేశ్వరుని మృత్తికా విగ్రహ ప్రతిష్టాపన, కలశ స్థాపన, నిత్య హారతి మరియు తీర్థప్రసాద వితరణ.',
      ),
      FestivalEvent(
        id: 'event_2',
        dayNumber: 3,
        title: 'శ్రీ లలితా సహస్రనామ పారాయణ & కుంకుమార్చన',
        time: 'సాయంత్రం 06:00 PM',
        incharge: 'మహిళా మండలి సభ్యులు',
        description: 'మహిళలందరి చేత సామూహిక కుంకుమార్చన, గణపతి అథర్వశీర్ష పఠనం.',
      ),
      FestivalEvent(
        id: 'event_3',
        dayNumber: 5,
        title: 'మహా అన్నదాన కార్యక్రమం (ప్రసాద వితరణ)',
        time: 'మధ్యాహ్నం 12:30 PM',
        incharge: 'అన్నదాన కమిటీ బృందం',
        description: 'కాలనీ మరియు భక్తజనులందరికీ స్వామివారి మహా అన్నప్రసాద వితరణ.',
      ),
      FestivalEvent(
        id: 'event_4',
        dayNumber: 7,
        title: 'భక్తి సంగీత విభావరి & సాంస్కృతిక పోటీలు',
        time: 'సాయంత్రం 07:00 PM',
        incharge: 'యువజన మిత్ర మండలి',
        description: 'పిల్లలకు భక్తి గీతాలు, శ్లోకాల పోటీలు, భజన మండలి వారిచే కోలాట సంబరం.',
      ),
      FestivalEvent(
        id: 'event_5',
        dayNumber: 9,
        title: 'మహా మంగళ హారతి, లడ్డూ వేలంపాట & నిమజ్జన శోభాయాత్ర',
        time: 'మధ్యాహ్నం 03:00 PM',
        incharge: 'మిత్ర మండలి సంపూర్ణ కమిటీ',
        description: 'స్వామివారి ప్రసాద లడ్డూ బహిరంగ వేలంపాట, డప్పు వాయిద్యాలతో ఘనంగా నిమజ్జన ఊరేగింపు.',
      ),
    ];

    try {
      final box = Hive.box(_scheduleBoxName);
      for (final ev in defaults) {
        await box.put(ev.id, ev.toMap());
        _events.add(ev);
      }
      _events.sort((a, b) => a.dayNumber.compareTo(b.dayNumber));
      notifyListeners();
    } catch (_) {}
  }

  // --- CRUD Operations ---

  Future<void> addChanda(ChandaRecord c) async {
    final box = Hive.box(_chandaBoxName);
    await box.put(c.id, c.toMap());
    _chandas.insert(0, c);
    notifyListeners();
  }

  Future<void> deleteChanda(String id) async {
    final box = Hive.box(_chandaBoxName);
    await box.delete(id);
    _chandas.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  Future<void> addExpense(ExpenseRecord e) async {
    final box = Hive.box(_expenseBoxName);
    await box.put(e.id, e.toMap());
    _expenses.insert(0, e);
    notifyListeners();
  }

  Future<void> deleteExpense(String id) async {
    final box = Hive.box(_expenseBoxName);
    await box.delete(id);
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  Future<void> addMember(CommitteeMember m) async {
    final box = Hive.box(_committeeBoxName);
    await box.put(m.id, m.toMap());
    _members.add(m);
    notifyListeners();
  }

  Future<void> deleteMember(String id) async {
    final box = Hive.box(_committeeBoxName);
    await box.delete(id);
    _members.removeWhere((m) => m.id == id);
    notifyListeners();
  }

  Future<void> addAuction(LadduAuction a) async {
    final box = Hive.box(_auctionBoxName);
    await box.put(a.id, a.toMap());
    _auctions.insert(0, a);
    notifyListeners();
  }

  Future<void> addEvent(FestivalEvent ev) async {
    final box = Hive.box(_scheduleBoxName);
    await box.put(ev.id, ev.toMap());
    _events.add(ev);
    _events.sort((a, b) => a.dayNumber.compareTo(b.dayNumber));
    notifyListeners();
  }

  // --- WhatsApp Sharing Ready Templates ---

  void shareChandaReceipt(ChandaRecord c, {String committeeName = 'శ్రీ వినాయక ఉత్సవ కమిటీ', String lang = 'te'}) {
    final dateStr = DateFormat('dd-MM-yyyy, hh:mm a').format(c.date);

    String message;
    if (lang == 'hi') {
      message = '''
🚩 *${committeeName}* 🚩
🕉️ *आधिकारिक चंदा रसीद (Donation Receipt)* 🕉️

📄 *रसीद संख्या:* ${c.receiptNo}
📅 *दिनांक:* ${dateStr}
👤 *दाता का नाम:* ${c.donorName}
💰 *चंदा राशि:* ₹${c.amount.toStringAsFixed(0)}/-
💳 *भुगतान का प्रकार:* ${c.paymentMode}
${c.notes != null && c.notes!.isNotEmpty ? "📝 विवरण: ${c.notes}\n" : ""}
गणेश जी की असीम कृपा आपके और आपके परिवार पर सदा बनी रहे। आपके सहयोग के लिए हार्दिक धन्यवाद! 🙏

— *विनायक मित्र (Vinayaka Mitra)*
''';
    } else if (lang == 'en') {
      message = '''
🚩 *${committeeName}* 🚩
🕉️ *Official Chanda / Donation Receipt* 🕉️

📄 *Receipt No:* ${c.receiptNo}
📅 *Date:* ${dateStr}
👤 *Donor Name:* ${c.donorName}
💰 *Donation Amount:* ₹${c.amount.toStringAsFixed(0)}/-
💳 *Payment Mode:* ${c.paymentMode}
${c.notes != null && c.notes!.isNotEmpty ? "📝 Remarks: ${c.notes}\n" : ""}
May Lord Ganesha shower his choicest blessings upon you and your family. Thank you for your generous contribution! 🙏

— *Vinayaka Mitra App*
''';
    } else {
      message = '''
🚩 *${committeeName}* 🚩
🕉️ *అధికారిక చందా రశీదు (Chanda Receipt)* 🕉️

📄 *రశీదు సంఖ్య:* ${c.receiptNo}
📅 *తేదీ & సమయం:* ${dateStr}
👤 *దాత పేరు:* ${c.donorName}
💰 *చందా మొత్తం:* ₹${c.amount.toStringAsFixed(0)}/-
💳 *చెల్లింపు విధానం:* ${c.paymentMode}
${c.notes != null && c.notes!.isNotEmpty ? "📝 వివరాలు: ${c.notes}\n" : ""}
శ్రీ విఘ్నేశ్వరుని కృపాకటాక్షాలు మీ కుటుంబానికి ఎల్లప్పుడూ కలగాలని ప్రార్థిస్తున్నాము. మీ సహాయానికి హృదయపూర్వక ధన్యవాదాలు! 🙏

— *వినాయక మిత్ర (Vinayaka Mitra)*
''';
    }

    Share.share(message);
  }

  void shareAuditReport({String committeeName = 'శ్రీ వినాయక ఉత్సవ కమిటీ', String lang = 'te'}) {
    final dateStr = DateFormat('dd-MM-yyyy').format(DateTime.now());

    String message;
    if (lang == 'hi') {
      message = '''
📊 *${committeeName} - उत्सव आय-व्यय रिपोर्ट* 📊
📅 *दिनांक:* ${dateStr}

📈 *कुल आय (Total Income):*
• भक्तों द्वारा चंदा: ₹${totalChandaAmount.toStringAsFixed(0)}
• लड्डू नीलामी: ₹${totalAuctionAmount.toStringAsFixed(0)}
➡️ *सकल आय:* ₹${totalIncome.toStringAsFixed(0)}

📉 *कुल खर्च (Total Expenses):*
• पंडाल, प्रसाद, दक्षिणा, लाइट आदि: ₹${totalExpensesAmount.toStringAsFixed(0)}

💰 *समिति के पास शेष बचत (Net Balance):*
➡️ *₹${netBalance.toStringAsFixed(0)}/-*

सभी कॉलोनी वासियों एवं भक्तों की पारदर्शी जानकारी के लिए प्रस्तुत। 🙏
— *विनायक मित्र*
''';
    } else if (lang == 'en') {
      message = '''
📊 *${committeeName} - Financial Audit Report* 📊
📅 *Date:* ${dateStr}

📈 *Total Inflow / Income:*
• Chanda Collections: ₹${totalChandaAmount.toStringAsFixed(0)}
• Laddu Auction: ₹${totalAuctionAmount.toStringAsFixed(0)}
➡️ *Gross Inflow:* ₹${totalIncome.toStringAsFixed(0)}

📉 *Total Outflow / Expenses:*
• Decoration, Pandit, Annadanam, Lighting, etc.: ₹${totalExpensesAmount.toStringAsFixed(0)}

💰 *Net Balance in Hand:*
➡️ *₹${netBalance.toStringAsFixed(0)}/-*

Presented with complete transparency for all residents and committee members. 🙏
— *Vinayaka Mitra*
''';
    } else {
      message = '''
📊 *${committeeName} - ఆదాయ-వ్యయాల లెక్కల నివేదిక* 📊
📅 *తేదీ:* ${dateStr}

📈 *మొత్తం ఆదాయం (Total Income):*
• భక్తుల చందాలు: ₹${totalChandaAmount.toStringAsFixed(0)}
• ప్రసాదం లడ్డూ వేలం: ₹${totalAuctionAmount.toStringAsFixed(0)}
➡️ *మొత్తం సమకూరిన నిధి:* ₹${totalIncome.toStringAsFixed(0)}

📉 *మొత్తం అయిన ఖర్చులు (Total Expenses):*
• మండపం, పూజారి దక్షిణ, అన్నదానం, లైటింగ్, మైక్ సెట్, నిమజ్జనం: ₹${totalExpensesAmount.toStringAsFixed(0)}

💰 *చేతిలో మిగిలిన నిల్వ (Net Balance):*
➡️ *₹${netBalance.toStringAsFixed(0)}/-*

కాలనీ వాసులందరి పారదర్శక సమాచారం మరియు ఆడిట్ కొరకు సమర్పించబడింది. 🙏
— *వినాయక మిత్ర (Vinayaka Mitra)*
''';
    }

    Share.share(message);
  }

  void shareEventInvitation(FestivalEvent ev, {String committeeName = 'శ్రీ వినాయక ఉత్సవ కమిటీ', String lang = 'te'}) {
    String message;
    if (lang == 'hi') {
      message = '''
🕉️ *${committeeName}* 🕉️
🌸 *दिवस ${ev.dayNumber} - पावन उत्सव आमंत्रण* 🌸

✨ *कार्यक्रम:* ${ev.title}
⏰ *समय:* ${ev.time}
👤 *प्रभारी:* ${ev.incharge}

📜 *विवरण:*
${ev.description}

आप सभी सपरिवार सादर आमंत्रित हैं। पधारकर भगवान श्री गणेश का आशीर्वाद एवं प्रसाद ग्रहण करें! 🙏

— *विनायक मित्र*
''';
    } else if (lang == 'en') {
      message = '''
🕉️ *${committeeName}* 🕉️
🌸 *Day ${ev.dayNumber} - Divine Festival Invitation* 🌸

✨ *Event:* ${ev.title}
⏰ *Time:* ${ev.time}
👤 *In-charge:* ${ev.incharge}

📜 *Description:*
${ev.description}

You are cordially invited with family and friends to receive Lord Ganesha's blessings and holy prasadam! 🙏

— *Vinayaka Mitra*
''';
    } else {
      message = '''
🕉️ *${committeeName}* 🕉️
🌸 *${ev.dayNumber}వ రోజు - దివ్య ఉత్సవ ఆహ్వానం* 🌸

✨ *కార్యక్రమం:* ${ev.title}
⏰ *సమయం:* ${ev.time}
👤 *బాధ్యత:* ${ev.incharge}

📜 *కార్యక్రమ వివరాలు:*
${ev.description}

భక్తులందరూ కుటుంబ సమేతంగా విచ్చేసి స్వామివారి తీర్థప్రసాదాలు స్వీకరించి, కృపకు పాత్రులు కావలసిందిగా కోరుతున్నాము! 🙏

— *వినాయక మిత్ర (Vinayaka Mitra)*
''';
    }

    Share.share(message);
  }

  void shareLadduAuction(LadduAuction a, {String committeeName = 'శ్రీ వినాయక ఉత్సవ కమిటీ', String lang = 'te'}) {
    final dateStr = DateFormat('dd-MM-yyyy').format(a.date);

    String message;
    if (lang == 'hi') {
      message = '''
🏆 *${committeeName}* 🏆
🎊 *श्री महागणपति महाप्रसाद लड्डू नीलामी परिणाम* 🎊

📅 *दिनांक:* ${dateStr}
👑 *भाग्यशाली विजेता:* ${a.winnerName}
💰 *अंतिम विजयी बोली:* ₹${a.bidAmount.toStringAsFixed(0)}/-

लड्डू विजेता भक्त को हार्दिक बधाई एवं शुभकामनाएं! भगवान विघ्नहर्ता आपके घर में सुख-समृद्धि और ऐश्वर्य प्रदान करें। 🪔

— *विनायक मित्र*
''';
    } else if (lang == 'en') {
      message = '''
🏆 *${committeeName}* 🏆
🎊 *Sri Maha Ganapathi Prasadam Laddu Auction Result* 🎊

📅 *Date:* ${dateStr}
👑 *Proud Winning Bidder:* ${a.winnerName}
💰 *Winning Bid Amount:* ₹${a.bidAmount.toStringAsFixed(0)}/-

Hearty congratulations to the winner! May Lord Ganesha bless your family with boundless joy, health, and prosperity. 🪔

— *Vinayaka Mitra*
''';
    } else {
      message = '''
🏆 *${committeeName}* 🏆
🎊 *శ్రీ మహా గణపతి మహా ప్రసాద లడ్డూ వేలంపాట విజేత* 🎊

📅 *తేదీ:* ${dateStr}
👑 *అదృష్ట విజేత:* ${a.winnerName}
💰 *గెలుచుకున్న వేలం మొత్తం:* ₹${a.bidAmount.toStringAsFixed(0)}/-

లడ్డూ ప్రసాదం దక్కించుకున్న భక్తునికి మరియు వారి కుటుంబానికి హృదయపూర్వక అభినందనలు! స్వామివారి ఆశీస్సులతో మీ ఇంట సిరిసంపదలు, ఆయురారోగ్యాలు వర్ధిల్లాలని ఆకాంక్షిస్తున్నాము. 🪔

— *వినాయక మిత్ర (Vinayaka Mitra)*
''';
    }

    Share.share(message);
  }
}
