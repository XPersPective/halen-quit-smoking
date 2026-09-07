import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/dates.dart';
import '../data/db/app_database.dart';
import '../data/repositories/record_repository.dart';
import 'providers.dart';

final recordRepositoryProvider = Provider<RecordRepository>((ref) {
  return RecordRepository(ref.watch(databaseProvider));
});

/// Reactive feed of every cigarette record, ordered by time. Data volumes
/// (thousands of rows per year) make full-feed watching cheap and keep every
/// day view correct across midnight without rescheduling streams.
final cigaretteEventsProvider = StreamProvider<List<CigaretteEventRow>>((ref) {
  return ref.watch(databaseProvider).recordDao.watchAll();
});

/// Reactive feed of craving events.
final cravingEventsProvider = StreamProvider<List<CravingEventRow>>((ref) {
  return ref.watch(databaseProvider).cravingDao.watchAll();
});

/// Events recorded on the local day of [now].
List<CigaretteEventRow> eventsOnDay(
  List<CigaretteEventRow> events,
  DateTime now,
) =>
    events.where((e) => e.ts.isSameLocalDayAs(now)).toList();
