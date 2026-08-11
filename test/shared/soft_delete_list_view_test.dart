import 'package:car_history/l10n/app_localizations.dart';
import 'package:car_history/shared/presentation/delete_confirm_dialog.dart';
import 'package:car_history/shared/presentation/soft_delete_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget wrap(Widget child) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(body: child),
    );
  }

  testWidgets('SoftDeleteListView shows confirm dialog and deletes on confirm',
      (tester) async {
    final deleted = <String>[];
    await tester.pumpWidget(
      wrap(
        SoftDeleteListView<String>(
          items: const ['alpha'],
          dismissibleKeyOf: (item) => item,
          deleteConfirmMessage: 'Delete this item?',
          onDelete: (item) async => deleted.add(item),
          itemBuilder: (context, item) => ListTile(title: Text(item)),
        ),
      ),
    );

    await tester.drag(find.text('alpha'), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(find.text('Delete this item?'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(deleted, ['alpha']);
    expect(find.text('alpha'), findsNothing);
  });

  testWidgets('showDeleteConfirmDialog returns false when cancelled',
      (tester) async {
    bool? result;
    await tester.pumpWidget(
      wrap(
        Builder(
          builder: (context) {
            return TextButton(
              onPressed: () async {
                result = await showDeleteConfirmDialog(
                  context,
                  message: 'Really?',
                );
              },
              child: const Text('open'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(result, isFalse);
  });
}
