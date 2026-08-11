import 'package:car_history/features/settings/data/backup/backup_json_codec.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BackupJsonCodec parses and formats dates', () {
    final dt = DateTime.utc(2026, 8, 5, 12, 30);
    final encoded = BackupJsonCodec.dt(dt);
    expect(BackupJsonCodec.parseDt(encoded), dt);
    expect(BackupJsonCodec.parseDt(null), isNull);
    expect(BackupJsonCodec.parseDt(''), isNull);
  });

  test('BackupJsonCodec numeric/string helpers', () {
    expect(BackupJsonCodec.asInt(3), 3);
    expect(BackupJsonCodec.asInt(3.9), 3);
    expect(BackupJsonCodec.asDouble(2), 2.0);
    expect(BackupJsonCodec.asString('  a  '), 'a');
    expect(BackupJsonCodec.asString('   '), isNull);
    expect(BackupJsonCodec.sameStr(' a ', 'a'), isTrue);
    expect(BackupJsonCodec.sameDouble(1.0, 1.0000000001), isTrue);
    expect(BackupJsonCodec.mapNullable(null, {1: 2}), isNull);
    expect(BackupJsonCodec.mapNullable(1, {1: 9}), 9);
  });
}
