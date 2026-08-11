import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'list_tip_banner.dart';

class SwipeDeleteTip extends StatelessWidget {
  const SwipeDeleteTip({required this.onDontShowAgain, super.key});

  final VoidCallback onDontShowAgain;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListTipBanner(
      icon: Icons.swipe_left,
      message: l10n.swipeDeleteTip,
      onDontShowAgain: onDontShowAgain,
    );
  }
}
