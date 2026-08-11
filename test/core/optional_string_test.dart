import 'package:car_history/core/optional_string.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OptionalString', () {
    test('normalize turns blank into null and trims', () {
      expect(OptionalString.normalize(null), isNull);
      expect(OptionalString.normalize(''), isNull);
      expect(OptionalString.normalize('  '), isNull);
      expect(OptionalString.normalize('  Hi  '), 'Hi');
    });
  });
}
