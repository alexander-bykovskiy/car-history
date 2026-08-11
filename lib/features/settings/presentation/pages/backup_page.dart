import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/backup_providers.dart';
import '../../di/preferences_providers.dart';
import '../../domain/repositories/backup_repository.dart';
import '../../../../l10n/app_localizations.dart';

class BackupPage extends ConsumerStatefulWidget {
  const BackupPage({super.key});

  @override
  ConsumerState<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends ConsumerState<BackupPage> {
  bool _busy = false;

  Future<void> _export() async {
    if (_busy) return;
    setState(() => _busy = true);
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final result = await ref.read(exportBackupUseCaseProvider).call();
    if (!mounted) return;
    setState(() => _busy = false);

    if (result.failure == BackupFailure.cancelled) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          result.ok
              ? l10n.backupExportSuccess
              : _exportFailureMessage(l10n, result.failure),
        ),
      ),
    );
  }

  Future<void> _share() async {
    if (_busy) return;
    setState(() => _busy = true);
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final result = await ref.read(shareBackupUseCaseProvider).call();
    if (!mounted) return;
    setState(() => _busy = false);

    if (result.failure == BackupFailure.cancelled) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          result.ok
              ? l10n.backupShareSuccess
              : _exportFailureMessage(l10n, result.failure),
        ),
      ),
    );
  }

  Future<void> _import() async {
    if (_busy) return;
    setState(() => _busy = true);
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final result = await ref.read(importBackupUseCaseProvider).call();
    if (!mounted) return;
    setState(() => _busy = false);

    if (result.failure == BackupFailure.cancelled) return;
    if (!result.ok) {
      messenger.showSnackBar(
        SnackBar(content: Text(_importFailureMessage(l10n, result.failure))),
      );
      return;
    }

    invalidateAppPreferences(ref);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          result.preferencesApplied
              ? l10n.backupImportSuccess(result.added, result.skipped)
              : l10n.backupImportPrefsFailed,
        ),
      ),
    );
  }

  String _exportFailureMessage(AppLocalizations l10n, BackupFailure? failure) {
    return switch (failure) {
      BackupFailure.io => l10n.backupExportFailed,
      _ => l10n.backupExportFailed,
    };
  }

  String _importFailureMessage(AppLocalizations l10n, BackupFailure? failure) {
    return switch (failure) {
      BackupFailure.empty => l10n.backupImportEmpty,
      BackupFailure.invalid => l10n.backupImportInvalid,
      BackupFailure.unsupportedVersion => l10n.backupImportUnsupportedVersion,
      BackupFailure.io => l10n.backupImportFailed,
      _ => l10n.backupImportFailed,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsBackup)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.backupDescription,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _busy ? null : _export,
            icon: const Icon(Icons.file_download_outlined),
            label: Text(l10n.backupExport),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _busy ? null : _share,
            icon: const Icon(Icons.share_outlined),
            label: Text(l10n.backupShare),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _busy ? null : _import,
            icon: const Icon(Icons.file_upload_outlined),
            label: Text(l10n.backupImport),
          ),
          if (_busy) ...[
            const SizedBox(height: 24),
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }
}
