class Harathi {
  final String id;
  final String titleTe;
  final String titleEn;
  final String? titleHi;
  final String category; // ganesh, shiva, venkateswara, lakshmi, durga, hanuman, saibaba, ayyappa, saraswati
  final String lyricsTelugu;
  final String lyricsEnglish;
  final String? lyricsHindi;
  final String meaning;
  final String? imageUrl;
  final String? audioUrl;
  final String? pdfPath; // Local or asset PDF path
  final bool isPremium;

  Harathi({
    required this.id,
    required this.titleTe,
    required this.titleEn,
    this.titleHi,
    required this.category,
    required this.lyricsTelugu,
    required this.lyricsEnglish,
    this.lyricsHindi,
    required this.meaning,
    this.imageUrl,
    this.audioUrl,
    this.pdfPath,
    this.isPremium = false,
  });

  factory Harathi.fromMap(Map<String, dynamic> m, [String? fallbackId]) {
    return Harathi(
      id: m['id'] ?? fallbackId ?? '',
      titleTe: m['titleTe'] ?? '',
      titleEn: m['titleEn'] ?? '',
      titleHi: m['titleHi'],
      category: m['category'] ?? 'ganesh',
      lyricsTelugu: m['lyricsTelugu'] ?? '',
      lyricsEnglish: m['lyricsEnglish'] ?? '',
      lyricsHindi: m['lyricsHindi'],
      meaning: m['meaning'] ?? '',
      imageUrl: m['imageUrl'],
      audioUrl: m['audioUrl'],
      pdfPath: m['pdfPath'],
      isPremium: m['isPremium'] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'titleTe': titleTe,
    'titleEn': titleEn,
    'titleHi': titleHi,
    'category': category,
    'lyricsTelugu': lyricsTelugu,
    'lyricsEnglish': lyricsEnglish,
    'lyricsHindi': lyricsHindi,
    'meaning': meaning,
    'imageUrl': imageUrl,
    'audioUrl': audioUrl,
    'pdfPath': pdfPath,
    'isPremium': isPremium,
  };
}
