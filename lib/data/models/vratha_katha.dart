class KathaChapter {
  final int chapterNumber;
  final String titleTe;
  final String titleEn;
  final String contentTe;
  final String? sloka;
  final String? slokaMeaning;

  KathaChapter({
    required this.chapterNumber,
    required this.titleTe,
    required this.titleEn,
    required this.contentTe,
    this.sloka,
    this.slokaMeaning,
  });

  factory KathaChapter.fromMap(Map<String, dynamic> m) => KathaChapter(
    chapterNumber: m['chapterNumber'] ?? 1,
    titleTe: m['titleTe'] ?? '',
    titleEn: m['titleEn'] ?? '',
    contentTe: m['contentTe'] ?? '',
    sloka: m['sloka'],
    slokaMeaning: m['slokaMeaning'],
  );

  Map<String, dynamic> toMap() => {
    'chapterNumber': chapterNumber,
    'titleTe': titleTe,
    'titleEn': titleEn,
    'contentTe': contentTe,
    'sloka': sloka,
    'slokaMeaning': slokaMeaning,
  };
}
