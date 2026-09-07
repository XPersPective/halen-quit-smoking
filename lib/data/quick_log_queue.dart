/// Cross-isolate queue for quick-log requests coming from surfaces that run
/// outside the main isolate (Android widget broadcast / QS tile / notification
/// action / iOS interactive widget intent).
///
/// The callback only enqueues — the main isolate drains the queue (on
/// startup, on app resume and on widget-click events) and inserts the
/// cigarette with the proper [RecordSource].
library;

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/entities.dart';

const _queueKey = 'halen_quick_log_queue';

/// Background entry point: registered with home_widget as the
/// interactivity/background callback and with the notification plugin as the
/// action-response handler. Must stay a top-level function.
@pragma('vm:entry-point')
Future<void> quickLogCallback(Uri? uri) async {
  final source = uri?.queryParameters['source'] ?? 'widget';
  final prefs = await SharedPreferences.getInstance();
  final queue = prefs.getStringList(_queueKey) ?? <String>[];
  queue.add(source);
  await prefs.setStringList(_queueKey, queue);
}

/// Reads and clears the queue. Returns the recorded sources in order.
Future<List<RecordSource>> drainQuickLogQueue() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getStringList(_queueKey) ?? <String>[];
  if (raw.isNotEmpty) {
    await prefs.setStringList(_queueKey, <String>[]);
  }
  return [
    for (final entry in raw)
      RecordSource.values.firstWhere(
        (s) => s.name == entry,
        orElse: () => RecordSource.widget,
      ),
  ];
}
