import 'package:flutter/services.dart';

/// Allows digits plus decimal separators used in locale-agnostic number fields.
final List<TextInputFormatter> decimalNumberInputFormatters = [
  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
];
