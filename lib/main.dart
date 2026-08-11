import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;

import 'app/di/app_providers.dart';
import 'bootstrap/app_dependencies.dart';
import 'features/cars/domain/entities/car.dart';
import 'features/settings/di/preferences_providers.dart';
import 'l10n/app_localizations.dart';
import 'shell/main_shell.dart';
import 'shell/splash_page.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Single ProviderScope only — nested scopes break dependency overrides
  // (selectedCarProvider would resolve carRepository in the parent container).
  runApp(const BootstrapApp());
}

class BootstrapApp extends StatefulWidget {
  const BootstrapApp({super.key});

  @override
  State<BootstrapApp> createState() => _BootstrapAppState();
}

class _BootstrapAppState extends State<BootstrapApp> {
  List<Override>? _overrides;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    final startedAt = DateTime.now();
    try {
      final deps = await AppDependencies.create();
      // Keep splash visible briefly so the SVG logo can be seen.
      const minSplash = Duration(milliseconds: 900);
      final elapsed = DateTime.now().difference(startedAt);
      if (elapsed < minSplash) {
        await Future<void>.delayed(minSplash - elapsed);
      }
      if (!mounted) return;
      setState(() => _overrides = deps.overrides);
    } catch (e, st) {
      debugPrint('App bootstrap failed: $e\n$st');
      if (!mounted) return;
      setState(() => _error = e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            final l10n = AppLocalizations.of(context);
            return Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    l10n.appStartFailed,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    final overrides = _overrides;
    if (overrides == null) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashPage(),
      );
    }

    return ProviderScope(
      overrides: overrides,
      child: const MainApp(),
    );
  }
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  ThemeData _themeFor(CarListItem? car) {
    final argb = car?.colorArgb;
    return buildAppTheme(argb != null ? Color(argb) : null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCar = ref.watch(selectedCarProvider).value;
    // Prefetch unit/currency prefs so lists are ready when opening forms.
    ref.watch(currencyCodeProvider);
    ref.watch(currencyCodesProvider);
    ref.watch(fuelVolumeUnitProvider);
    ref.watch(distanceUnitProvider);
    ref.watch(appLocalePreferenceProvider);

    final localeCode =
        ref.watch(appLocalePreferenceProvider).value?.languageCode;
    final localeOverride =
        localeCode == null ? null : Locale(localeCode);

    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: localeOverride,
      theme: _themeFor(selectedCar),
      home: const MainShell(),
    );
  }
}
