import 'package:car_history/features/catalog/domain/entities/catalog_save_result.dart';
import 'package:car_history/features/catalog/presentation/catalog_save_result_handler.dart';
import 'package:car_history/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'handleCatalogSaveResult confirms restore and runs onRestore',
    (tester) async {
      var restored = false;
      late BuildContext pageContext;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                pageContext = context;
                return TextButton(
                  onPressed: () async {
                    await handleCatalogSaveResult(
                      context: context,
                      result: CatalogSaveResult.needsRestoreConfirm,
                      emptyNameMessage: 'empty',
                      alreadyExistsMessage: 'exists',
                      restoreConfirmMessage: 'Restore deleted item?',
                      onError: (_) {},
                      onRestore: () async {
                        restored = true;
                      },
                    );
                  },
                  child: const Text('Trigger'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Trigger'));
      await tester.pumpAndSettle();

      expect(find.text('Restore deleted item?'), findsOneWidget);
      await tester.tap(find.text('Restore'));
      await tester.pumpAndSettle();

      expect(restored, isTrue);
      expect(pageContext.mounted, isTrue);
    },
  );

  testWidgets(
    'handleCatalogSaveResult maps emptyName via onError',
    (tester) async {
      String? error;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return TextButton(
                  onPressed: () async {
                    await handleCatalogSaveResult(
                      context: context,
                      result: CatalogSaveResult.emptyName,
                      emptyNameMessage: 'Name required',
                      alreadyExistsMessage: 'exists',
                      restoreConfirmMessage: 'restore?',
                      onError: (message) => error = message,
                      onRestore: () async {},
                    );
                  },
                  child: const Text('Trigger'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Trigger'));
      await tester.pumpAndSettle();

      expect(error, 'Name required');
      expect(find.text('restore?'), findsNothing);
    },
  );
}
