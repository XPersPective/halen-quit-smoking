import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/db/app_database.dart';
import '../data/quick_log_queue.dart';
import '../data/repositories/record_repository.dart';
import '../data/widget_service.dart';
import 'providers.dart';

/// Drains the quick-log queue (widget / tile / control / notification taps)
/// and records each entry with its source (report §13).
class QuickLogController {
  QuickLogController(this._db);

  final AppDatabase _db;

  /// Returns how many records were inserted.
  Future<int> drain() async {
    final sources = await drainQuickLogQueue();
    if (sources.isEmpty) {
      return 0;
    }
    final repository = RecordRepository(_db);
    for (final source in sources) {
      await repository.logCigarette(source: source);
    }
    // Widget numbers changed → push the fresh state.
    await WidgetService(_db).refresh();
    return sources.length;
  }
}

/// Widget service bound to the app database.
final widgetServiceProvider =
    Provider<WidgetService>((ref) => WidgetService(ref.watch(databaseProvider)));
