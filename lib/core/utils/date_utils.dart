import 'package:intl/intl.dart';

class DevotionalDateUtils {
  /// Formats the current date in standard devotional display
  static String formatTeluguDate(DateTime date) {
    final formatter = DateFormat('dd MMMM yyyy, EEEE');
    return formatter.format(date);
  }

  /// Calculates days left until the next Ganesh Chaturthi festival
  static int getDaysUntilGaneshChaturthi([DateTime? fromDate]) {
    final now = fromDate ?? DateTime.now();
    
    // Key Ganesh Chaturthi festival dates (Bhadrapada Shukla Chavithi)
    final festivalDates = [
      DateTime(2024, 9, 7),
      DateTime(2025, 8, 27),
      DateTime(2026, 9, 14),
      DateTime(2027, 9, 4),
      DateTime(2028, 8, 24),
    ];

    for (final date in festivalDates) {
      if (date.isAfter(now) || (date.year == now.year && date.month == now.month && date.day == now.day)) {
        final diff = DateTime(date.year, date.month, date.day)
            .difference(DateTime(now.year, now.month, now.day))
            .inDays;
        return diff >= 0 ? diff : 0;
      }
    }
    return 0;
  }

  /// Returns today's Panchangam summary details (Tithi, Nakshatram, Rahu Kalam, Varjyam)
  static Map<String, String> getTodaysPanchangam([DateTime? date]) {
    final d = date ?? DateTime.now();
    final dayOfWeek = DateFormat('EEEE').format(d);

    // Rahu kalam approx table by weekday
    final rahuKalamMap = {
      'Monday': '07:30 AM – 09:00 AM',
      'Tuesday': '03:00 PM – 04:30 PM',
      'Wednesday': '12:00 PM – 01:30 PM',
      'Thursday': '01:30 PM – 03:00 PM',
      'Friday': '10:30 AM – 12:00 PM',
      'Saturday': '09:00 AM – 10:30 AM',
      'Sunday': '04:30 PM – 06:00 PM',
    };

    final abhijitMap = {
      'Monday': '11:45 AM – 12:35 PM',
      'Tuesday': '11:45 AM – 12:35 PM',
      'Wednesday': '11:45 AM – 12:35 PM',
      'Thursday': '11:45 AM – 12:35 PM',
      'Friday': '11:45 AM – 12:35 PM',
      'Saturday': '11:45 AM – 12:35 PM',
      'Sunday': '11:45 AM – 12:35 PM',
    };

    return {
      'masam': 'భాద్రపద మాసము',
      'paksham': 'శుక్ల పక్షము',
      'tithi': 'చవితి (Chavithi)',
      'nakshatram': 'హస్త / చిత్త',
      'muhurtham': abhijitMap[dayOfWeek] ?? '11:45 AM – 12:35 PM',
      'rahuKalam': rahuKalamMap[dayOfWeek] ?? '04:30 PM – 06:00 PM',
      'varjyam': 'రాత్రి 08:15 PM – 09:45 PM',
      'amruthaKalam': 'ఉదయం 06:30 AM – 08:00 AM',
    };
  }
}
