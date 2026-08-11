import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'splash_logo_svg.dart';

/// Branded splash shown while the app finishes startup work.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  static const backgroundColor = Color(0xFF125683);

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: backgroundColor,
      child: Center(
        child: _SplashLogo(),
      ),
    );
  }
}

class _SplashLogo extends StatelessWidget {
  const _SplashLogo();

  @override
  Widget build(BuildContext context) {
    // Keep mark inside a circular safe zone (matches Android 12 splash mask).
    final diameter = MediaQuery.sizeOf(context).shortestSide * 0.42;
    return SizedBox(
      width: diameter,
      height: diameter,
      child: ClipOval(
        child: ColoredBox(
          color: SplashPage.backgroundColor,
          child: Center(
            child: SizedBox(
              width: diameter * 0.62,
              height: diameter * 0.62,
              child: SvgPicture.string(
                kSplashLogoSvg,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
