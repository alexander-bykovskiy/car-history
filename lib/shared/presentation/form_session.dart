import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'delete_confirm_dialog.dart';

/// Scaffold shell for [ChangeNotifier] form sessions: AppBar + SafeArea body
/// rebuilt via [ListenableBuilder].
class FormSessionScaffold extends StatelessWidget {
  const FormSessionScaffold({
    required this.title,
    required this.listenable,
    required this.body,
    super.key,
  });

  final String title;
  final Listenable listenable;
  final Widget Function(BuildContext context) body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        top: false,
        child: ListenableBuilder(
          listenable: listenable,
          builder: (context, _) => body(context),
        ),
      ),
    );
  }
}

/// SnackBar for unexpected save/delete failures (`formActionFailed`).
void showFormActionFailedSnack(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(l10n.formActionFailed)),
  );
}

/// Delete confirm dialog; returns `true` only when the user confirmed.
Future<bool> confirmFormDelete({
  required BuildContext context,
  required String message,
}) async {
  final confirmed = await showDeleteConfirmDialog(
    context,
    message: message,
  );
  return confirmed == true;
}
