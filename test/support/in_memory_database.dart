import 'package:car_history/shared/data/db/app_database.dart';
import 'package:car_history/shared/data/db/database_seed_texts.dart';
import 'package:drift/native.dart';

/// In-memory [AppDatabase] with English seed texts for unit/integration tests.
AppDatabase createInMemoryDatabase() {
  return AppDatabase(
    executor: NativeDatabase.memory(),
    seeds: DatabaseSeedTexts.english,
  );
}

/// Creates an in-memory DB and waits until schema/seeds are ready.
Future<AppDatabase> openInMemoryDatabase() async {
  final db = createInMemoryDatabase();
  await db.customSelect('SELECT 1').get();
  return db;
}
