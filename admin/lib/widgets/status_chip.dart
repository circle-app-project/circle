import 'package:flutter/material.dart';

import '../core/enums.dart';

/// A small colored chip representing an [HlaTestStatus].
class StatusChip extends StatelessWidget {
  const StatusChip(this.status, {super.key});

  final HlaTestStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    late final Color bg;
    late final Color fg;
    if (status.isCancelledState) {
      bg = scheme.errorContainer;
      fg = scheme.onErrorContainer;
    } else if (status.isResultsReady) {
      bg = const Color(0xFFD7F5E0);
      fg = const Color(0xFF0B6B36);
    } else {
      bg = scheme.primaryContainer;
      fg = scheme.onPrimaryContainer;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 14, color: fg),
          const SizedBox(width: 6),
          Text(
            status.label,
            style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
