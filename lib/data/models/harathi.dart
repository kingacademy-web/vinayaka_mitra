import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory Harathi.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>? ?? {};
    return Harathi(
      id: doc.id,
      titleTe: d['titleTe'] ?? '',
      titleEn: d['titleEn'] ?? '',
      category: d['category'] ?? 'ganesh',
      lyricsTelugu: d['lyricsTelugu'] ?? '',
      lyricsEnglish: d['lyricsEnglish'] ?? '',
      meaning: d['meaning'] ?? '',
      imageUrl: d['imageUrl'],
      audioUrl: d['audioUrl'],
      isPremium: d['isPremium'] ?? false,
    );
  }

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
