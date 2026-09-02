class ChandaRecord {
  final String id;
  final String receiptNo;
  final String donorName;
  final String phoneNumber;
  final double amount;
  final String paymentMode; // 'Cash', 'UPI', 'Bank'
  final DateTime date;
  final String? notes;

  ChandaRecord({
    required this.id,
    required this.receiptNo,
    required this.donorName,
    required this.phoneNumber,
    required this.amount,
    required this.paymentMode,
    required this.date,
    this.notes,
  });

  factory ChandaRecord.fromMap(Map<String, dynamic> map) => ChandaRecord(
    id: map['id'] ?? '',
    receiptNo: map['receiptNo'] ?? '',
    donorName: map['donorName'] ?? '',
    phoneNumber: map['phoneNumber'] ?? '',
    amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
    paymentMode: map['paymentMode'] ?? 'Cash',
    date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
    notes: map['notes'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'receiptNo': receiptNo,
    'donorName': donorName,
    'phoneNumber': phoneNumber,
    'amount': amount,
    'paymentMode': paymentMode,
    'date': date.toIso8601String(),
    'notes': notes,
  };
}

class ExpenseRecord {
  final String id;
  final String category;
  final String description;
  final double amount;
  final String paidTo;
  final DateTime date;

  ExpenseRecord({
    required this.id,
    required this.category,
    required this.description,
    required this.amount,
    required this.paidTo,
    required this.date,
  });

  factory ExpenseRecord.fromMap(Map<String, dynamic> map) => ExpenseRecord(
    id: map['id'] ?? '',
    category: map['category'] ?? 'General',
    description: map['description'] ?? '',
    amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
    paidTo: map['paidTo'] ?? '',
    date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'category': category,
    'description': description,
    'amount': amount,
    'paidTo': paidTo,
    'date': date.toIso8601String(),
  };
}

class CommitteeMember {
  final String id;
  final String name;
  final String role;
  final String phoneNumber;
  final String dutyAssigned;

  CommitteeMember({
    required this.id,
    required this.name,
    required this.role,
    required this.phoneNumber,
    required this.dutyAssigned,
  });

  factory CommitteeMember.fromMap(Map<String, dynamic> map) => CommitteeMember(
    id: map['id'] ?? '',
    name: map['name'] ?? '',
    role: map['role'] ?? '',
    phoneNumber: map['phoneNumber'] ?? '',
    dutyAssigned: map['dutyAssigned'] ?? '',
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'role': role,
    'phoneNumber': phoneNumber,
    'dutyAssigned': dutyAssigned,
  };
}

class LadduAuction {
  final String id;
  final int year;
  final String winnerName;
  final String phoneNumber;
  final double bidAmount;
  final bool isPaid;
  final DateTime date;

  LadduAuction({
    required this.id,
    required this.year,
    required this.winnerName,
    required this.phoneNumber,
    required this.bidAmount,
    required this.isPaid,
    required this.date,
  });

  factory LadduAuction.fromMap(Map<String, dynamic> map) => LadduAuction(
    id: map['id'] ?? '',
    year: map['year'] ?? DateTime.now().year,
    winnerName: map['winnerName'] ?? '',
    phoneNumber: map['phoneNumber'] ?? '',
    bidAmount: (map['bidAmount'] as num?)?.toDouble() ?? 0.0,
    isPaid: map['isPaid'] ?? false,
    date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'year': year,
    'winnerName': winnerName,
    'phoneNumber': phoneNumber,
    'bidAmount': bidAmount,
    'isPaid': isPaid,
    'date': date.toIso8601String(),
  };
}

class FestivalEvent {
  final String id;
  final int dayNumber;
  final String title;
  final String time;
  final String incharge;
  final String description;

  FestivalEvent({
    required this.id,
    required this.dayNumber,
    required this.title,
    required this.time,
    required this.incharge,
    required this.description,
  });

  factory FestivalEvent.fromMap(Map<String, dynamic> map) => FestivalEvent(
    id: map['id'] ?? '',
    dayNumber: map['dayNumber'] ?? 1,
    title: map['title'] ?? '',
    time: map['time'] ?? '',
    incharge: map['incharge'] ?? '',
    description: map['description'] ?? '',
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'dayNumber': dayNumber,
    'title': title,
    'time': time,
    'incharge': incharge,
    'description': description,
  };
}
