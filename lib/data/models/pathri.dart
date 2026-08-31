class Pathri {
  final int number;
  final String nameTe;
  final String nameEn;
  final String botanicalName;
  final String mantra;
  final String importance;
  final String medicinalBenefits;
  final String imageUrl;

  Pathri({
    required this.number,
    required this.nameTe,
    required this.nameEn,
    required this.botanicalName,
    required this.mantra,
    required this.importance,
    required this.medicinalBenefits,
    required this.imageUrl,
  });

  factory Pathri.fromMap(Map<String, dynamic> m) => Pathri(
    number: m['number'] ?? 0,
    nameTe: m['nameTe'] ?? '',
    nameEn: m['nameEn'] ?? '',
    botanicalName: m['botanicalName'] ?? '',
    mantra: m['mantra'] ?? '',
    importance: m['importance'] ?? '',
    medicinalBenefits: m['medicinalBenefits'] ?? '',
    imageUrl: m['imageUrl'] ?? 'assets/images/pathri/default.png',
  );

  Map<String, dynamic> toMap() => {
    'number': number,
    'nameTe': nameTe,
    'nameEn': nameEn,
    'botanicalName': botanicalName,
    'mantra': mantra,
    'importance': importance,
    'medicinalBenefits': medicinalBenefits,
    'imageUrl': imageUrl,
  };
}
