class PoojaStep {
  final int stepNumber;
  final String nameTe;
  final String nameEn;
  final String mantra;
  final String vidhi; // Explanation & action steps
  final List<String> samagriRequired;
  final String? audioUrl;

  PoojaStep({
    required this.stepNumber,
    required this.nameTe,
    required this.nameEn,
    required this.mantra,
    required this.vidhi,
    required this.samagriRequired,
    this.audioUrl,
  });

  factory PoojaStep.fromMap(Map<String, dynamic> m) => PoojaStep(
    stepNumber: m['stepNumber'] ?? 1,
    nameTe: m['nameTe'] ?? '',
    nameEn: m['nameEn'] ?? '',
    mantra: m['mantra'] ?? '',
    vidhi: m['vidhi'] ?? '',
    samagriRequired: (m['samagriRequired'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [],
    audioUrl: m['audioUrl'],
  );

  Map<String, dynamic> toMap() => {
    'stepNumber': stepNumber,
    'nameTe': nameTe,
    'nameEn': nameEn,
    'mantra': mantra,
    'vidhi': vidhi,
    'samagriRequired': samagriRequired,
    'audioUrl': audioUrl,
  };
}
