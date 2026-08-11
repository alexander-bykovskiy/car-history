import 'package:car_history/features/settings/domain/privacy_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('privacy policy URL points at public GitHub docs', () {
    expect(
      kPrivacyPolicyUrl,
      'https://github.com/alexander-bykovskiy/car-history/blob/main/docs/PRIVACY.md',
    );
  });
}
