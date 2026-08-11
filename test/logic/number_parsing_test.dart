import 'package:car_history/core/number_parsing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parseFlexibleDouble accepts comma and dot', () {
    expect(parseFlexibleDouble('12,5'), 12.5);
    expect(parseFlexibleDouble('12.5'), 12.5);
    expect(parseFlexibleDouble(''), isNull);
    expect(parseFlexibleDouble('  '), isNull);
    expect(parseFlexibleDouble('abc'), isNull);
  });
}
