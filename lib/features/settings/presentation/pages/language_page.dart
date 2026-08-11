import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../di/preferences_providers.dart';
import '../../domain/app_locale_option.dart';

class LanguagePage extends ConsumerWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selected = ref.watch(appLocalePreferenceProvider).value;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsLanguage)),
      body: selected == null
          ? const Center(child: CircularProgressIndicator())
          : RadioGroup<AppLocaleOption>(
              groupValue: selected,
              onChanged: (value) {
                if (value != null) {
                  ref.read(appLocalePreferenceProvider.notifier).set(value);
                }
              },
              child: ListView(
                children: [
                  for (final option in AppLocaleOption.values)
                    RadioListTile<AppLocaleOption>(
                      value: option,
                      title: Text(
                        option == AppLocaleOption.system
                            ? l10n.languageSystem
                            : option.nativeLabel,
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
