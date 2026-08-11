import 'package:flutter/widgets.dart';

import '../../../../core/number_formatting.dart';
import '../../../../core/number_parsing.dart';
import 'fueling_form_prepare.dart';

/// Keeps quantity ↔ total in sync from price and the last-edited amount field.
class FuelingAmountSync {
  FuelingAmountField lastEdited = FuelingAmountField.quantity;
  bool _syncing = false;

  void recalculate({
    required TextEditingController priceController,
    required TextEditingController quantityController,
    required TextEditingController totalController,
    FuelingAmountField? edited,
  }) {
    if (_syncing) return;
    _syncing = true;
    try {
      if (edited != null) {
        lastEdited = edited;
      }

      final price = parseFlexibleDouble(priceController.text);
      if (price == null || price <= 0) return;

      if (lastEdited == FuelingAmountField.total) {
        final total = parseFlexibleDouble(totalController.text);
        if (total == null || total <= 0) return;
        setControllerText(quantityController, total / price);
      } else {
        final quantity = parseFlexibleDouble(quantityController.text);
        if (quantity == null || quantity <= 0) return;
        setControllerText(totalController, price * quantity);
      }
    } finally {
      _syncing = false;
    }
  }

  void writePrepared({
    required TextEditingController quantityController,
    required TextEditingController totalController,
    required double quantity,
    required double total,
  }) {
    setControllerText(quantityController, quantity);
    setControllerText(totalController, total);
  }

  static void setControllerText(TextEditingController controller, double value) {
    final text = formatFlexibleDouble(value);
    if (controller.text == text) return;
    controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
