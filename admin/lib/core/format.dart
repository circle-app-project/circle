import 'package:intl/intl.dart';

/// Formats a (UTC) timestamp in the viewer's local time, e.g. "Jun 24, 2026 · 3:30 PM".
String formatDateTime(DateTime dt) =>
    DateFormat('MMM d, y · h:mm a').format(dt.toLocal());

String formatDate(DateTime dt) => DateFormat('MMM d, y').format(dt.toLocal());
