import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'list_tip_banner.dart';

class DoubleTapEditTip extends StatelessWidget {
  const DoubleTapEditTip({required this.onDontShowAgain, super.key});

  final VoidCallback onDontShowAgain;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListTipBanner(
      icon: Icons.touch_app,
      message: l10n.doubleTapEditTip,
      onDontShowAgain: onDontShowAgain,
    );
  }
}
