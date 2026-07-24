// lib/core/utils/timestamp_formatter.dart
//
// Timestamp Formatter — Indonesian Locale
// Zero-Trust Attendance Protocol
// ═══════════════════════════════════════════════════
// Format HH:MM WIB, tanggal lokal Indonesia.

import 'package:intl/intl.dart';

/// Utility class for consistent timestamp and date formatting.
///
/// All timestamps use WIB (UTC+7) timezone.
/// All date labels use Indonesian locale.
class TimestampFormatter {
  TimestampFormatter._();

  /// Format time as "HH.mm WIB" (e.g., "06.55 WIB")
  static String timeWIB(DateTime dateTime) {
    final wib = dateTime.toUtc().add(const Duration(hours: 7));
    return '${DateFormat('HH.mm').format(wib)} WIB';
  }

  /// Format time as "HH:mm" (e.g., "06:55")
  static String timeShort(DateTime dateTime) {
    final wib = dateTime.toUtc().add(const Duration(hours: 7));
    return DateFormat('HH:mm').format(wib);
  }

  /// Format date as "dd MMM yyyy" (e.g., "20 Nov 2025")
  static String dateMedium(DateTime dateTime) {
    return DateFormat('dd MMM yyyy', 'id_ID').format(dateTime);
  }

  /// Format date as "EEEE, dd MMMM yyyy" (e.g., "Rabu, 20 November 2025")
  static String dateFull(DateTime dateTime) {
    return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(dateTime);
  }

  /// Format short day name (e.g., "Wed", "Mon")
  static String dayNameShort(DateTime dateTime) {
    return DateFormat('EEE').format(dateTime);
  }

  /// Format day number (e.g., "20")
  static String dayNumber(DateTime dateTime) {
    return DateFormat('dd').format(dateTime);
  }

  /// Format date range for DateRangeNavigator.
  /// "Sun 10 – Sat 23 November 2025"
  static String dateRange(DateTime start, DateTime end) {
    final startFormatted = DateFormat('EEE dd').format(start);
    final endFormatted = DateFormat('EEE dd MMMM yyyy').format(end);
    return '$startFormatted – $endFormatted';
  }

  /// Format relative time (e.g., "2 menit lalu", "1 jam lalu")
  static String relativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    return dateMedium(dateTime);
  }
}
