import 'package:flutter/material.dart';

import '../../features/reminders/presentation/pages/reminders_page.dart';

/// Composition-root navigation into the reminders list.
Future<void> openRemindersPage(BuildContext context) {
  return Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      builder: (context) => const RemindersPage(),
    ),
  );
}
