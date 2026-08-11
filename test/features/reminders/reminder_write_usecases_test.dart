import 'package:car_history/features/reminders/data/reminder_repository_impl.dart';
import 'package:car_history/features/reminders/domain/entities/reminder.dart';
import 'package:car_history/features/reminders/domain/usecases/reminder_write_usecases.dart';
import 'package:car_history/shared/data/db/app_database.dart';
import 'package:car_history/shared/data/db/database_seed_texts.dart';
import 'package:car_history/shared/data/odometer_repository_impl.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late SaveReminderUseCase save;
  late int carId;

  setUp(() async {
    db = AppDatabase(
      executor: NativeDatabase.memory(),
      seeds: DatabaseSeedTexts.english,
    );
    await db.customSelect('SELECT 1').get();
    carId = (await db.select(db.cars).getSingle()).id;
    final repo = ReminderRepositoryImpl(
      db,
      odometerRepository: OdometerRepositoryImpl(db),
    );
    save = SaveReminderUseCase(repo);
  });

  tearDown(() async {
    await db.close();
  });

  test('SaveReminderUseCase creates a reminder', () async {
    final outcome = await save.create(
      ReminderInput(
        carId: carId,
        title: 'Inspect brakes',
        dueAt: DateTime(2024, 5, 1),
      ),
    );
    expect(outcome.result, ReminderSaveResult.created);
    expect(outcome.reminder?.title, 'Inspect brakes');
  });

  test('SaveReminderUseCase rejects empty title', () async {
    final outcome = await save.create(
      ReminderInput(
        carId: carId,
        title: '  ',
        dueAt: DateTime(2024, 5, 1),
      ),
    );
    expect(outcome.result, ReminderSaveResult.emptyTitle);
  });
}
