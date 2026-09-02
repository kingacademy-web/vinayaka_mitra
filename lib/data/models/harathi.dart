class Harathi {
  final String id;
  final String titleTe;
  final String titleEn;
  final String category; // ganesh, shiva, venkateswara, lakshmi, durga, hanuman, saibaba, ayyappa, saraswati
  final String lyricsTelugu;
  final String lyricsEnglish;
  final String meaning;
  final String? imageUrl;
  final String? audioUrl;
  final bool isPremium;

  Harathi({
    required this.id,
    required this.titleTe,
    required this.titleEn,
    required this.category,
    required this.lyricsTelugu,
    required this.lyricsEnglish,
    required this.meaning,
    this.imageUrl,
    this.audioUrl,
    this.isPremium = false,
  });

  factory Harathi.fromMap(Map<String, dynamic> m, [String? fallbackId]) {
    return Harathi(
      id: m['id'] ?? fallbackId ?? '',
      titleTe: m['titleTe'] ?? '',
      titleEn: m['titleEn'] ?? '',
      category: m['category'] ?? 'ganesh',
      lyricsTelugu: m['lyricsTelugu'] ?? '',
      lyricsEnglish: m['lyricsEnglish'] ?? '',
      meaning: m['meaning'] ?? '',
      imageUrl: m['imageUrl'],
      audioUrl: m['audioUrl'],
      isPremium: m['isPremium'] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'titleTe': titleTe,
    'titleEn': titleEn,
    'category': category,
    'lyricsTelugu': lyricsTelugu,
    'lyricsEnglish': lyricsEnglish,
    'meaning': meaning,
    'imageUrl': imageUrl,
    'audioUrl': audioUrl,
    'isPremium': isPremium,
  };
}
